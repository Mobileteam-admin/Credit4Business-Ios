//
//  IdentityVerificationVC.swift
//  Credit4Business
//
//  Created by MacMini on 15/05/24.
//

import UIKit
import IQKeyboardManagerSwift
class IdentityVerificationVC: UIViewController {
    
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------

    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pageControl: CustomPageControl!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var directorsTableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    var viewModel = HomeVM()
    var isVerified = false
    var selectedDirectorResponse : IdentityVerificationStatusModel?
    @IBOutlet weak var sendButtonView: UIView!
    @IBOutlet weak var commentButton: UIImageView!

    var loanId = ""
    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObserverOnHeightTbl()
        self.updateUI()
        self.manageActionMethods()
    }
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = true
        //self.fetchGuarantorDetails()
        self.fetchIdentityVerificationStatus()
    }
    
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
   //---------------------------------------
   // MARK: - Init With Story
   //---------------------------------------

    class func initWithStory(loanId: String) -> IdentityVerificationVC {
       let vc : IdentityVerificationVC = UIStoryboard.Main.instantiateViewController()
        vc.loanId = loanId
       return vc
   }
    
    //---------------------------------------
    // MARK: - Custom methods
    //---------------------------------------
   
    func updateUI()
    {
        self.pageControl.numberOfPages = 9
        self.setPagNumber(currentPage: 7)
        self.directorsTableView.delegate = self
        self.directorsTableView.dataSource = self
        self.sendButton.isHidden = false
        self.resendButton.isHidden = true
    }
    func setPagNumber(currentPage : Int) {
        self.pageControl.currentPage = currentPage
    }

    func checkKYCStatus() {
        var isVerified = true
        if self.selectedDirectorResponse != nil {
            for element in self.selectedDirectorResponse!.data {
                if element.kycStatus == false {
                    isVerified = false
                }
            }
        }
        if self.selectedDirectorResponse?.data.count == 0 {
            isVerified = false
        }
        else{
            isVerified = true
        }
        
        if isVerified {
            self.sendButtonView.isHidden = true
        }else{
            self.checkSendButtonStatus()
        }
        self.isVerified = isVerified
        var selectedBusinessType = self.viewModel.businessTypeArray.filter({$0.description.contains(GlobalFundingModelObject.business.businessType)}).first

         var businessMemberType = BusinessMemberType(rawValue: selectedBusinessType?.id ?? 0) ?? .none
        var title = ""
        switch businessMemberType {
        case .SoleTrade:
            title = "Proprietor KYC Status"
        case .Director:
            title = "Directors KYC Status"
        case .Partner:
            title = "Partners KYC Status"
        default:
            title = "Partners KYC Status"
        }

        self.directorLabel.text = title
    }
    func fetchIdentityVerificationStatus() {
        APIService.shared.retrieveIdentityVerificationStatus(loanId: self.loanId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedDirectorResponse = data
                        self.checkKYCStatus()
                        self.directorsTableView.reloadData()
                    }
                    catch {
                        
                    }
                }
                else {
                    self.checkSendButtonStatus()
                    self.directorsTableView.isHidden = true
                   // self.showAlert(title: "Info", message: data.statusMessage)
                }
            case .failure(let error):
               // self.showAlert(title: "Info", message: error.localizedDescription)
                print(error)
                self.checkSendButtonStatus()
                self.directorsTableView.isHidden = true
            }
        }
    }
    func checkSendButtonStatus() {
        checkLoanStatus(loanId: self.loanId)
        if (canEditForms && GlobalmodeOfApplication != .Representative){
            self.sendButtonView.isHidden = false

        }else{
            self.isVerified = true
            self.sendButtonView.isHidden = true
        }

    }
    func updateFilledForms(){
        var params = JSON()
        params["identity_verified"] = "True"
        var url = APIEnums.updateFilledForms.rawValue
        if loanId != "" {
            url = url + "\(loanId)/"
        }
      
        APIService.shared.makeRequest(endpoint: url,
                                      withLoader: true,
                                      method: .post,
                                      params: params) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                }
                else if data.statusCode == 401 {
                    self.showAlert(title: "Info", message: data.statusMessage)
                }
                else {
                    self.showAlert(title: "Info", message: data.statusMessage)
                }

            case .failure(let error):
                print(error)
                self.showAlert(title: "Info", message: error.localizedDescription)
            }
        }
    }
    func createIdentityDetails() {
        APIService.shared.makeRequest(endpoint: APIEnums.createIdentity.rawValue + "\(loanId)/",
                                      withLoader: true,
                                      method: .post,
                                      params: JSON()) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    self.updateFilledForms()
                    self.isVerified = true
                    self.showAlert(title: "Identity Verification Send!", message: "Identity Verification Email send to your email id please check!")
                    self.fetchIdentityVerificationStatus()
                }
                else if data.statusCode == 401 {
                    self.tokenRefreshApi()
                }
                else {
                    self.showAlert(title: "Info", message: data.statusMessage)
                }

            case .failure(let error):
                print(error)
                self.showAlert(title: "Info", message: error.localizedDescription)
            }
        }
    }
    func tokenRefreshApi() {
        var dict = JSON()
        dict["refresh"] = UserDefaults.standard.value(forKey: "refresh") as? String
        APIService.shared.refreshTokenRequest(endpoint: APIEnums.refreshToken.rawValue,
                                      withLoader: true,
                                      method: .post,
                                      params: dict) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    UserDefaults.standard.set(data.access, forKey:"access")
                    UserDefaults.standard.set(data.refresh, forKey:"refresh")

                    self.createIdentityDetails()
                }
                else {
                    self.showAlert(title: "Info", message: data.statusMessage)
                }

            case .failure(let error):
                print(error)
                self.showAlert(title: "Info", message: error.localizedDescription)
            }
        }

    }

    func manageActionMethods() {
        self.commentButton.addTapGestureRecognizer {
            let vc = RemarksVC.initWithStory(loanId: self.loanId)
            vc.isRemarks = false
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        self.sendButton.addTapGestureRecognizer {
            self.createIdentityDetails()
            self.sendButton.isHidden = true
            self.resendButton.isHidden = false
        }
        self.resendButton.addTapGestureRecognizer {
            self.createIdentityDetails()
        }
        self.backButton.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        self.nextButton.addTapGestureRecognizer {
            if self.isVerified {
//                self.showAlertWithAction(title: "Funding Successfully Submitted!", message: "Your Funding Application has been successfully Submitted, We'll get back to you soon.", IsGoBack: true)
                //self.formSubmission()
                let vc = GocartlessViewController.initWithStory(loanId: self.loanId)
                self.navigationController?.pushViewController(vc, animated: true)

            }else{
                self.showAlert(title: "Info", message: "Please verify your identity")
            }
        }
    }

}
extension IdentityVerificationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedDirectorResponse?.data.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kycStatusCell", for: indexPath) as? KYCStatusCell else {
            return UITableViewCell()
        }
        var model = self.selectedDirectorResponse?.data.value(atSafe: indexPath.row)
//        if model?.director == nil {
//            cell.emailValueLabel.text = model?.guarantor?.email
//            cell.nameValueLabel.text = (model?.guarantor?.firstName ?? "") + " " + (model?.guarantor?.lastName ?? "")
//            cell.phoneValueLabel.text = model?.guarantor?.phoneNumber.description
//            if model?.guarantor != nil {
//                let attributedTitle = NSMutableAttributedString(string: model?.kycStatus == true ? "Completed" : "Inprogress", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0) ?? .boldSystemFont(ofSize: 10.0), NSAttributedString.Key.foregroundColor: UIColor(named: "green") ?? .green])
//
//                    cell.kycStatusButton.setAttributedTitle(attributedTitle, for: .normal)
//            }
//        }else{
        cell.emailValueLabel.text = model?.customer.email
        cell.nameValueLabel.text = (model?.customer.firstName ?? "") + " " + (model?.customer.lastName ?? "")
        cell.phoneValueLabel.text = model?.customer.phoneNumber
            if model?.customer != nil {
                let attributedTitle = NSMutableAttributedString(string: model?.kycStatus == true ? "Completed" : "Inprogress", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0) ?? .boldSystemFont(ofSize: 10.0), NSAttributedString.Key.foregroundColor: UIColor(named: "green") ?? .green])

                    cell.kycStatusButton.setAttributedTitle(attributedTitle, for: .normal)
            }
           
//        }
        
        return cell
    }
}
//MARK: -------------------------- Observers Methods --------------------------
extension IdentityVerificationVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.directorsTableView, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.tableHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.directorsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.directorsTableView else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
