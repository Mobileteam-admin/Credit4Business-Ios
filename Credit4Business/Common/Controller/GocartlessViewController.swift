//
//  GocartlessViewController.swift
//  Credit4Business
//
//  Created by MacMini on 13/06/24.
//

import UIKit
import StepProgressBar
import IQKeyboardManagerSwift
import Photos
import MobileCoreServices
import UniformTypeIdentifiers

class GocartlessViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: CustomPageControl!
    @IBOutlet weak var step1Stack: UIStackView!
    var viewModel = HomeVM()
    @IBOutlet weak var step1ErrLabel: UILabel!
    @IBOutlet weak var step1ErrStack: UIStackView!
    @IBOutlet weak var step2Stack: UIStackView!
    @IBOutlet weak var step2ErrLabel: UILabel!
    @IBOutlet weak var step2ErrStack: UIStackView!
    @IBOutlet weak var step1TF: UITextField!
    @IBOutlet weak var step1TableHeight: NSLayoutConstraint!
    @IBOutlet weak var step1Table: UITableView!
    @IBOutlet weak var step1TableArrowActionView: UIView!
    @IBOutlet weak var step1TableArrow: UIImageView!
    @IBOutlet weak var step2TF: UITextField!
    @IBOutlet weak var step2TableHeight: NSLayoutConstraint!
    @IBOutlet weak var step2Table: UITableView!
    @IBOutlet weak var step2TableArrowActionView: UIView!
    @IBOutlet weak var step2TableArrow: UIImageView!

    @IBOutlet weak var step3Stack: UIView!
    @IBOutlet weak var step2DropDown: UIStackView!
    @IBOutlet weak var step2StatusButton: UIButton!
    @IBOutlet weak var step1StatusButton: UIButton!
    @IBOutlet weak var requisitionButton: UIButton!
    @IBOutlet weak var requisitionStack: UIView!
    
    @IBOutlet weak var gocardlessTableHeight: NSLayoutConstraint!
    @IBOutlet weak var gocardlessTableView: UIView!
    @IBOutlet weak var gocardlessTable: UITableView!
    
    @IBOutlet weak var bankTF: UITextField!
    @IBOutlet weak var bankTableHeight: NSLayoutConstraint!
    @IBOutlet weak var bankTable: UITableView!
    @IBOutlet weak var bankTableArrowActionView: UIView!
    @IBOutlet weak var bankTableArrow: UIImageView!
    @IBOutlet weak var bankErrLabel: UILabel!
    @IBOutlet weak var bankErrStack: UIStackView!

    @IBOutlet weak var accNoErrLabel: UILabel! //tradingstyle
    @IBOutlet weak var accNoErrStack: UIStackView!
    @IBOutlet weak var accNoTF: UITextField!

    @IBOutlet weak var sortCodeErrLabel: UILabel! //tradingstyle
    @IBOutlet weak var sortCodeErrStack: UIStackView!
    @IBOutlet weak var sortCodeTF: UITextField!

    @IBOutlet weak var accHolderNameErrLabel: UILabel! //tradingstyle
    @IBOutlet weak var accHolderNameErrStack: UIStackView!
    @IBOutlet weak var accHolderNameTF: UITextField!

    @IBOutlet weak var countryCodeErrLabel: UILabel! //tradingstyle
    @IBOutlet weak var countryCodeErrStack: UIStackView!
    @IBOutlet weak var countryCodeTF: UITextField!
    
    @IBOutlet weak var addBankAccountBtn: UIButton!
    @IBOutlet weak var agreementImage: UIImageView!
    @IBOutlet weak var agreementView: UIView!
    @IBOutlet weak var accountFileUploadView: UIView!
    @IBOutlet weak var accountFileUploadLabel: UILabel!
    @IBOutlet weak var accountFileUploadErrLabel: UILabel!
    @IBOutlet weak var accountFileUploadErrStack: UIStackView!
    @IBOutlet weak var accountFileUploadButton: UIButton!

    @IBOutlet weak var accountsTable: UITableView!
    @IBOutlet weak var accountTableHeight: NSLayoutConstraint!
    var selectedGocardlessStatement = [GocardlessData]()
    var selectedGocardlessManualStatement = [BankDetail]()

    @IBOutlet weak var GoHomeButton: UIButton!
    @IBOutlet weak var commentButton: UIImageView!
    
    @IBOutlet weak var prevButton: UIButton!
    
    @IBOutlet weak var documentStack: UIStackView!
    @IBOutlet weak var countryCodeStack: UIStackView!
    @IBOutlet weak var accountHolderStack: UIStackView!
    @IBOutlet weak var sortCodeStack: UIStackView!
    @IBOutlet weak var accountNumberStack: UIStackView!
    @IBOutlet weak var bankNumberStack: UIStackView!
    
    var step1TableHidden = true
    var step2TableHidden = true
    var bankTableHidden = true
    var selectedStep1 : BankData?
    var selectedBankName : BankData?
    var selectedStep2 : String?
    var dropdownType : DropDownType = .none
    var bankArray = [BankData]()
    var bankAccountArray = [Account]()
    var requisitionData : RequisitionClass?
    var requisitionLink = ""
    var loanId = ""
    var loanModel : LoanModel?
    var isAgreed = true
    var documentType : DocumentType = .none
    var isDocumentUploaded = false
    var bankStatementArray = [UploadDocumentModel]()
    
    @IBOutlet weak var generateRegenerateBtn: UIButton!
    //MARK: -------------------- Class Variable --------------------
    var accountFileUploadStr = ""
  
    var accountFileUploadMIME = ""
   
    var accountFileUploadType = ""
    
    var accountFileName = ""
   
    var accountFileUploadData = Data()
    var selectedDocumentsResponse : DocumentsDataClass?

    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.updateUI()
        self.manageActionMethods()
        self.fetchBankDetails()
        self.fetchLoanDetails()
        self.addObserverOnHeightTbl()
        self.gocardlessTable.isHidden = true
        self.gocardlessTableView.isHidden = true
        let attributedTitle = NSMutableAttributedString(string: "Generate Link", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 11.0), NSAttributedString.Key.foregroundColor: UIColor(named: "blue"),NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])

        self.generateRegenerateBtn.setAttributedTitle(attributedTitle, for: .normal)

        self.gocardlessTableHeight.constant = 0
        //if !self.isAgreed {
            self.fetchGocardlessManualStatementDetails()
        //}else{
            self.fetchGocardlessStatementDetails()
        //}
        self.checkLoanStatus()
    }
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.isEnabled = true
        self.navigationController?.isNavigationBarHidden = true
        if let tabbar = self.parent?.parent as? TabBarController {
            if let navigationController = tabbar.parent as? UINavigationController {
                navigationController.isNavigationBarHidden = true
                tabbar.tabBar.isHidden = true
            }
        }
        self.fetchBankAccountDetails()
    }
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.isEnabled = false
    }
    func checkLoanStatus() {
        checkLoanStatus(loanId: self.loanId)
        if canEditForms && self.isAgreed && GlobalmodeOfApplication != .Representative {
            self.step1Stack.isHidden = false

        }else{
            self.step1Stack.isHidden = true
        }

    }
    //---------------------------------------
    // MARK: - Init With Story
    //---------------------------------------

    class func initWithStory(loanId: String) -> GocartlessViewController {
        let vc : GocartlessViewController = UIStoryboard.Login.instantiateViewController()
        vc.loanId = loanId
        return vc
    }
    //---------------------------------------
    // MARK: - Custom methods
    //---------------------------------------
    func setDelegates() {
        self.step1Table.delegate = self
        self.step1Table.dataSource = self
        self.step2Table.delegate = self
        self.step2Table.dataSource = self
        self.gocardlessTable.delegate = self
        self.gocardlessTable.dataSource = self
        self.pageControl.numberOfPages = 9
        self.setPagNumber(currentPage: 8)
        self.accNoTF.delegate = self
        self.accHolderNameTF.delegate = self
        self.sortCodeTF.delegate = self
        self.countryCodeTF.delegate = self
        self.accNoTF.keyboardType = .numberPad
        self.sortCodeTF.keyboardType = .numberPad
        self.accountsTable.delegate = self
        self.accountsTable.dataSource = self
        self.bankTable.delegate = self
        self.bankTable.dataSource = self
    }
    func showModelValues() {
        var item = self.selectedDocumentsResponse
        
        if item?.businessAccountStatement?.count ?? 0 > 0 {
            self.accountsTable.isHidden = false
            guard let array = item?.businessAccountStatement else{
                return
            }
            self.bankStatementArray.removeAll()
            for element in array {
                var filename = URL(fileURLWithPath: element.file).deletingPathExtension().lastPathComponent
                var obj = UploadDocumentModel(data: Data(), fileName: filename, mimeType: "", fileType: "")
                self.bankStatementArray.append(obj)
            }
            self.accountsTable.reloadData()
        }
    }
    func setPagNumber(currentPage : Int) {
        self.pageControl.currentPage = currentPage
    }
    func updateUI()
    {
        self.agreementImage.image = self.isAgreed ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
        self.step2Stack.isHidden = true
        self.requisitionStack.isHidden = true
        self.nextButton.isHidden = true
        self.accountsTable.isHidden = true
        self.bankNumberStack.isHidden = self.isAgreed
        self.accountNumberStack.isHidden = self.isAgreed
        self.accountHolderStack.isHidden = self.isAgreed
        self.sortCodeStack.isHidden = self.isAgreed
        self.countryCodeStack.isHidden = self.isAgreed
        self.addBankAccountBtn.isHidden = self.isAgreed
        self.documentStack.isHidden = self.isAgreed
        self.step1Stack.isHidden = !self.isAgreed

    }
    func manageActionMethods() {
        self.generateRegenerateBtn.addTapGestureRecognizer {
            if self.step1TF.text != "" {
                var params = JSON()
                params["bank_name"] = self.step1TF.text
                params["institution_id"] = "SANDBOXFINANCE_SFIN0000"
                self.createRequisitionDetails(loanId:self.loanId,params: params)            }
           
        }
        self.addBankAccountBtn.addTapGestureRecognizer {
            self.isValidTextFields()
            if self.goNext() {
                var dicts = JSON()
                dicts["continue_with_gocardless"] = "False"
                dicts["bank_country_code"] = "GB"
                dicts["account_holder_name"] = self.accHolderNameTF.text ?? ""
                dicts["bank_sort_code"] = self.sortCodeTF.text ?? ""
                dicts["bank_account_number"] = self.accNoTF.text ?? ""
                dicts["bank_name"] = self.selectedBankName?.name ?? ""
                var dataArray = [String: Any]()
                dataArray["business_account_statements"] = self.bankStatementArray
                if self.isDocumentUploaded {
                    self.createDocumentDetails(paramDict: dicts, dataArray: dataArray)
                }else {
                    self.createDocumentDetails(paramDict: dicts, dataArray: JSON())
                }
               // self.createBankDetails(loanId: self.loanId, params: dicts)
            }
        }
        self.accountFileUploadButton.addTapGestureRecognizer {
            self.documentType = .Account
            self.redirectToImageChooseVC(isPhoto: false)
        }
        self.agreementView.addTapGestureRecognizer {
            self.isAgreed = !self.isAgreed
            self.agreementImage.image = self.isAgreed ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
            self.bankNumberStack.isHidden = self.isAgreed
            self.accountNumberStack.isHidden = self.isAgreed
            self.accountHolderStack.isHidden = self.isAgreed
            self.sortCodeStack.isHidden = self.isAgreed
            self.countryCodeStack.isHidden = self.isAgreed
            self.addBankAccountBtn.isHidden = self.isAgreed
            self.documentStack.isHidden = self.isAgreed
            self.step1Stack.isHidden = !self.isAgreed
            self.step2Stack.isHidden = !self.isAgreed
            self.step3Stack.isHidden = !self.isAgreed
           // self.step2Stack.isHidden = !self.isAgreed
            self.countryCodeErrStack.isHidden = true
            self.bankErrStack.isHidden = true
            self.accNoErrStack.isHidden = true
            self.accHolderNameErrStack.isHidden = true
            self.sortCodeErrStack.isHidden = true
            if !self.isAgreed {
                self.fetchGocardlessManualStatementDetails()
            }else{
                self.fetchGocardlessStatementDetails()
            }
            if self.step1TF.text != "" && self.requisitionLink != "" && self.isAgreed {
                let attributedTitle = NSMutableAttributedString(string: "Completed", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: "yellow")])

                self.step1StatusButton.setAttributedTitle(attributedTitle, for: .normal)

                self.step2Stack.isHidden = false
                self.requisitionStack.isHidden = false
                self.step3Stack.isHidden = true
                self.step2DropDown.isHidden = true
            }
        }
        self.prevButton.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        self.GoHomeButton.addTapGestureRecognizer {
            self.navigationController?.popToRootViewController(animated: true)
        }
        self.commentButton.addTapGestureRecognizer {
            let vc = RemarksVC.initWithStory(loanId: self.loanId)
            vc.isRemarks = false
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        self.step1TableArrowActionView.addTapGestureRecognizer {
            self.dropdownType = .step1
            self.step1TableHidden = !self.step1TableHidden
            self.showHideTable()
        }
        self.step1TF.addTapGestureRecognizer {
            self.dropdownType = .step1
            self.step1TableHidden = !self.step1TableHidden
            self.showHideTable()
        }
        self.bankTF.addTapGestureRecognizer {
            self.dropdownType = .bankName
            self.bankTableHidden = !self.bankTableHidden
            self.showHideTable()
        }
        self.bankTableArrowActionView.addTapGestureRecognizer {
            self.dropdownType = .bankName
            self.bankTableHidden = !self.bankTableHidden
            self.showHideTable()
        }
        self.step2TableArrowActionView.addTapGestureRecognizer {
            self.dropdownType = .step2
            self.step2TableHidden = !self.step2TableHidden
            self.showHideTable()
        }
        self.step2TF.addTapGestureRecognizer {
            self.dropdownType = .step2
            self.step2TableHidden = !self.step2TableHidden
            self.showHideTable()
        }
        self.requisitionButton.addTapGestureRecognizer {
            self.step2Stack.isHidden = false
            let attributedTitle = NSMutableAttributedString(string: "Completed", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: "yellow")])

            self.step1StatusButton.setAttributedTitle(attributedTitle, for: .normal)

            var vc = WebViewController.initWithStory()
            vc.strPageTitle = ""
            vc.isToRedirect = true
            vc.strWebUrl = self.requisitionLink //self.requisitionData?.link ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.nextButton.addTapGestureRecognizer {
            self.formSubmission()
            //self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    func fetchLoanDetails() {
        APIService.shared.retrieveLoanDetails() { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data
                        self.loanModel = responseData
                        if self.loanModel?.data.count != 0 {
                            for element in self.loanModel!.data {
                                if element.id == self.loanId {
                                    var model = element.customer.loanDetails.filter({$0.loanID == self.loanId}).first

                                    if model?.currentStatus.lowercased() == "inprogress" && model?.upcomingStatus.lowercased() == "submission_waiting" {
                                        self.nextButton.isHidden = false
                                    }else if model!.currentStatus.lowercased().contains("submitted") {
                                        self.GoHomeButton.isHidden = false
                                        self.nextButton.isHidden = true
                                    }
                                    else{
                                        self.nextButton.isHidden = true
                                        self.GoHomeButton.isHidden = true
                                    }
                                }
                            }
                        }
                    }
                    catch {
                        
                    }
                }
                else {
                   // self.showAlert(title: "Info", message: data.statusMessage)
                }
            case .failure(let error):
               // self.showAlert(title: "Info", message: error.localizedDescription)
                print(error)
            }
        }
    }
    func formSubmission() {
        APIService.shared.makeRequest(endpoint: APIEnums.formSubmission.rawValue + "\(loanId)/",
                                      withLoader: true,
                                      method: .post,
                                      params: JSON()) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    if GlobalFundingModelObject.initial.modeOfApplication == "Representative" {
                        self.showAlertWithAction(title: "Funding Successfully Submitted!", message: "Your Funding Application has been successfully Submitted. After the agent confirmation we'll proceed further and get back to you soon.", IsGoBack: true)
                    }else{
                        self.showAlertWithAction(title: "Funding Successfully Submitted!", message: "Your Funding Application has been successfully Submitted, We'll get back to you soon.", IsGoBack: true)

                    }

                }
                else if data.statusCode == 401 {
                   // self.tokenRefreshApi()
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
    func showAlertWithAction(title: String, message: String,IsGoBack : Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .default,handler: { okay in
            if IsGoBack {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }))
        self.present(alertController, animated: true)
    }
    func showHideTable() {
        switch self.dropdownType {
        case .step1:
            if self.step1TableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        case .step2:
            if self.step2TableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        case .bankName:
            if self.bankTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        default:
            break
        }
        
    }
    func fetchBankDetails() {
        APIService.shared.retrieveBankDetails(loanId: self.loanId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data
                        self.bankArray.removeAll()
                        self.bankArray = data.data
                        var model = BankData(id: "SANDBOXFINANCE_SFIN0000", name: "ABN AMRO Bank Commercial(Test Bank)", bic: "ABNAGB2LXXX", transactionTotalDays: "540", countries: ["GB"], logo: "")
                        var model2 = BankData(id: "SANDBOXFINANCE_SFIN0000", name: "Allied Irish Banks Corporate (Test Bank)", bic: "AIBKGB2LXXX", transactionTotalDays: "730", countries: ["GB"], logo: "")
                        var model3 = BankData(id: "SANDBOXFINANCE_SFIN0000", name: "Alpha FX (Test Bank)", bic: "APAHGB2L", transactionTotalDays: "730", countries: ["GB"], logo: "")
                        var model4 = BankData(id: "SANDBOXFINANCE_SFIN0000", name: "Amazon card (Newday) (Test Bank)", bic: "NEWDUK00X01", transactionTotalDays: "730", countries: ["GB"], logo: "")
                        self.bankArray.append(model)
                        self.bankArray.append(model2)
                        self.bankArray.append(model3)
                        self.bankArray.append(model4)
                        self.step1Table.reloadData()
                        self.bankTable.reloadData()
                    }
                    catch {
                        
                    }
                }
                else {
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func fetchGocardlessManualStatementDetails() {
        APIService.shared.retrieveGocardlessManualStatementDetails(loanId: self.loanId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data
                        self.selectedGocardlessManualStatement = responseData.data.bankDetails
                        self.step1TF.text = self.selectedGocardlessManualStatement.first?.bankName ?? ""
                        self.requisitionLink = self.selectedGocardlessManualStatement.first?.requisitionLink ?? ""
                        if self.requisitionLink != ""
                        {
                            let attributedTitle = NSMutableAttributedString(string: "Re-Generate Link", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 11.0), NSAttributedString.Key.foregroundColor: UIColor(named: "blue"),NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])

                            self.generateRegenerateBtn.setAttributedTitle(attributedTitle, for: .normal)

                        }
                        if self.requisitionLink != "" && self.isAgreed {
                            let attributedTitle = NSMutableAttributedString(string: "Completed", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: "yellow")])

                            self.step1StatusButton.setAttributedTitle(attributedTitle, for: .normal)

                            self.step2Stack.isHidden = false
                            self.requisitionStack.isHidden = false
                            self.step3Stack.isHidden = true
                            self.step2DropDown.isHidden = true

                        }
                        self.gocardlessTable.isHidden = false
                        self.gocardlessTableView.isHidden = false
                        self.gocardlessTable.reloadData()
                    }
                    catch {
                        
                    }
                }
                else {
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func fetchGocardlessStatementDetails() {
        APIService.shared.retrieveGocardlessStatementDetails(loanId: self.loanId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data
                        self.selectedGocardlessStatement = responseData.data.filter({$0.gocardlessStatus == true})
                        self.gocardlessTable.isHidden = false
                        self.gocardlessTableView.isHidden = false
                        self.gocardlessTable.reloadData()
                    }
                    catch {
                        
                    }
                }
                else {
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func fetchBankAccountDetails() {
        APIService.shared.retrieveBankAccountDetails(loanId: self.loanId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data
                        self.bankAccountArray = data.data.accounts
                        if self.bankAccountArray.count != 0 {
                            self.step2DropDown.isHidden = false
                            let attributedTitle = NSMutableAttributedString(string: "Completed", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: "yellow")])
                            self.step1StatusButton.setAttributedTitle(attributedTitle, for: .normal)
                            self.step2StatusButton.setAttributedTitle(attributedTitle, for: .normal)

                            self.step3Stack.isHidden = false
                        }else{
                            self.step2DropDown.isHidden = true
                            self.step3Stack.isHidden = true
                        }
                        self.step2Table.reloadData()
                    }
                    catch {
                        
                    }
                }
                else {
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func createRequisitionDetails(loanId: String,params: JSON) {
        var url = APIEnums.createRequisition.rawValue + loanId + "/?request_from=mobile"
        
        APIService.shared.requisitionRequest(endpoint: url,
                                      withLoader: true,
                                      method: .post,
                                      params: params) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    self.step2Stack.isHidden = false
                    self.requisitionStack.isHidden = false
                    self.step3Stack.isHidden = true
                    self.step2DropDown.isHidden = true
                    self.requisitionData = data.data
                    self.requisitionLink = data.data.link
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
    func createDocumentDetails(paramDict: JSON,dataArray: [String: Any]) {
        var url = APIEnums.createManualBank.rawValue + loanId + "/"
       
        ConnectionHandler().uploadDocuments(wsMethod: url, paramDict: paramDict, dataArray: dataArray, viewController: self, isToShowProgress: true, isToStopInteraction: true) { response in
            if response.status_code == 200 {
                self.nextButton.isHidden = false
                self.showAlert(title: "Info", message: response.status_message)
                self.fetchGocardlessManualStatementDetails()
                self.fetchLoanDetails()
            }
            else {
                self.showAlert(title: "Info", message: response.status_message)
            }
        }
    }
    func createBankDetails(loanId: String,params: JSON) {
        var url = APIEnums.createManualBank.rawValue + loanId + "/"
        
        APIService.shared.makeRequest(endpoint: url,
                                      withLoader: true,
                                      method: .post,
                                      params: params) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    self.updateFilledForms()
                    self.showAlert(title: "Info", message: data.statusMessage)
                    self.fetchGocardlessManualStatementDetails()
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
    func updateFilledForms(){
        var params = JSON()
        params["gocardless_statement"] = "True"
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
    func confirmBankAccountDetails(loanId: String,params: JSON) {
        var url = APIEnums.retrieveBankAccounts.rawValue + "\(loanId)/"
        
        APIService.shared.makeRequest(endpoint: url,
                                      withLoader: true,
                                      method: .post,
                                      params: params) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    self.updateFilledForms()
                    let attributedTitle = NSMutableAttributedString(string: "Completed", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: "yellow")])

                    self.step2StatusButton.setAttributedTitle(attributedTitle, for: .normal)
                    self.nextButton.isHidden = false
                    self.showAlert(title: "Info", message: data.statusMessage)
                    self.fetchGocardlessStatementDetails()
                    self.fetchLoanDetails()
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
    func redirectToImageChooseVC(isPhoto: Bool)
    {
        var types: [String] = [kUTTypeJPEG as String,kUTTypePNG as String]
        if !isPhoto {
            types = [kUTTypePDF as String,kUTTypeSpreadsheet as String,kUTTypeJPEG as String,kUTTypePNG as String]
        }
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
        }
}
extension GocartlessViewController : UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let url = urls[0]
        let isSecuredURL = url.startAccessingSecurityScopedResource() == true
        let coordinator = NSFileCoordinator()
        var error: NSError? = nil
        coordinator.coordinate(readingItemAt: url, options: [], error: &error) { (url) -> Void in
            _ = urls.compactMap { (url: URL) -> URL? in
                // Create file URL to temporary folder
                var tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
                // Apend filename (name+extension) to URL
                tempURL.appendPathComponent(url.lastPathComponent)
                do {
                    // If file with same name exists remove it (replace file with new one)
                    if FileManager.default.fileExists(atPath: tempURL.path) {
                        try FileManager.default.removeItem(atPath: tempURL.path)
                    }
                    // Move file from app_id-Inbox to tmp/filename
                    try FileManager.default.moveItem(atPath: url.path, toPath: tempURL.path)
                    
                    
                    self.fileChecking(url:tempURL)
                    return tempURL
                } catch {
                    print(error.localizedDescription)
                    return nil
                }
            }
        }
        if (isSecuredURL) {
            url.stopAccessingSecurityScopedResource()
        }
        
        controller.dismiss(animated: true, completion: nil)
    }

    func fileChecking(url:URL){
        var size = self.sizePerMB(url: url)
        print(size)
        if size.description.toInt() >= 5 {
            DispatchQueue.main.async {
                self.showAlert(title: "Info", message: "Please upload the image upto 5MB")
            }
        }else{
            let document = url.lastPathComponent.components(separatedBy: ".")
            let fileName = "\(document[0])"
            let fileType = "\(document[1])"
            let fileMIMEType = self.mimeTypeForPath(fileType: fileType)

            print(fileName)
            print(fileType)
            self.isDocumentUploaded = true

            do {
                let fileData = try Data.init(contentsOf: url)
                let fileStream:String = fileData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
                switch self.documentType{
                
                case .Account:
                    self.accountsTable.isHidden = false
//                    self.selectedAccountFileName.text = fileName + "." + fileType
                    self.accountFileName = fileName + "." + fileType

                   // self.accountFileUploadLabel.text = fileName + "." + fileType
//                    self.accountFileUploadStr = fileStream
                    self.accountFileUploadData = fileData
                    self.accountFileUploadMIME = fileMIMEType
                    self.accountFileUploadType = fileType
                    var obj = UploadDocumentModel(data: self.accountFileUploadData, fileName: self.accountFileName, mimeType: self.accountFileUploadMIME, fileType: self.accountFileUploadType)
                    self.bankStatementArray.append(obj)
                    self.accountsTable.reloadData()
//                    self.accountFileUploadButton.isHidden = true
                    self.accountFileUploadErrStack.isHidden = true
                
                default: break
                }
                //            let decodeData = Data(base64Encoded: fileStream, options: .ignoreUnknownCharacters)
                //            body.append(decodeData!)
            }
            catch { }}
    }
}
extension GocartlessViewController {
    func addTransparentView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                switch self.dropdownType {
                case .step1:
                    self.step1Table.isHidden = false
                    self.step1TableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)

                    self.step1TableHeight.constant = CGFloat(self.bankArray.count * 50)
                    self.step1Table.reloadData()
                    self.view.layoutIfNeeded()
                case .bankName:
                    self.bankTable.isHidden = false
                    self.bankTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)

                    self.bankTableHeight.constant = CGFloat(self.bankArray.count * 50)
                    self.bankTable.reloadData()
                    self.view.layoutIfNeeded()
                case .step2:
                    self.step2Table.isHidden = false
                    self.step2TableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)

                    self.step2TableHeight.constant = CGFloat(self.bankAccountArray.count * 50)
                    self.step2Table.reloadData()
                    self.view.layoutIfNeeded()
                default:
                    break

                }
               
            }, completion: nil)
        }
        
    }
    
    @objc func removeTransparentView() {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            switch self.dropdownType {
            case .step1:
                self.step1Table.isHidden = true
                self.step1TableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.step1TableHeight.constant = 0
                self.step1Table.reloadData()
            case .bankName:
                self.bankTable.isHidden = true
                self.bankTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.bankTableHeight.constant = 0
                self.bankTable.reloadData()
            case .step2:
                self.step2Table.isHidden = true
                self.step2TableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.step2TableHeight.constant = 0
                self.step2Table.reloadData()
            default:
                break

            }
        }, completion: nil)
    }
}
extension GocartlessViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView == self.gocardlessTable {
            count = self.isAgreed ? self.selectedGocardlessStatement.count : self.selectedGocardlessManualStatement.count
        }
        else if tableView == self.accountsTable {
            return self.bankStatementArray.count
        }
        else {
            switch self.dropdownType {
            case .step1:
                count = self.bankArray.count
            case .step2:
                count = self.bankAccountArray.count
            case .bankName:
                count = self.bankArray.count
            default:
                break

            }
        }
       
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.dropdownType == .step1 && tableView == step1Table {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? CellClass else {
                return UITableViewCell()
            }
            cell.documentLabel.text = self.bankArray.value(atSafe: indexPath.row)?.name
            cell.documentSelectAction.setTitle("", for: .normal)
            cell.separatorLabel.isHidden = (indexPath.row == self.bankArray.count - 1)
            cell.documentSelectAction.addTapGestureRecognizer {
                self.step1TF.text = "\(self.bankArray.value(atSafe: indexPath.row)?.name ?? "")"
                self.selectedStep1 = self.bankArray.value(atSafe: indexPath.row)
                self.step1TableHidden = !self.step1TableHidden
                self.dropdownType = .step1
                self.removeTransparentView()
                self.step1ErrStack.isHidden = true
                var params = JSON()
                params["bank_name"] = self.step1TF.text
                params["institution_id"] = "SANDBOXFINANCE_SFIN0000"
                self.createRequisitionDetails(loanId:self.loanId,params: params)
            }
        }
        else if self.dropdownType == .step2 && tableView == step2Table {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as? CellClass3 else {
                return UITableViewCell()
            }
            cell.label2.text = self.bankAccountArray.value(atSafe: indexPath.row)?.accountNumber
            cell.action2.setTitle("", for: .normal)
            cell.separator2.isHidden = (indexPath.row == self.bankAccountArray.count - 1)
            cell.action2.addTapGestureRecognizer {
                self.step2TF.text = "\(self.bankAccountArray.value(atSafe: indexPath.row)?.accountNumber ?? "")"
                self.selectedStep2 = self.bankAccountArray.value(atSafe: indexPath.row)?.accountid
                self.step2TableHidden = !self.step2TableHidden
                self.dropdownType = .step2
                self.removeTransparentView()
                self.step2ErrStack.isHidden = true
                var params = JSON()
                params["account_number"] = self.selectedStep2
                self.confirmBankAccountDetails(loanId:self.loanId,params: params)
            }
        }
        else if self.dropdownType == .bankName && tableView == bankTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? CellClass2 else {
                return UITableViewCell()
            }
            cell.label1.text = self.bankArray.value(atSafe: indexPath.row)?.name
            cell.action1.setTitle("", for: .normal)
            cell.separator1.isHidden = (indexPath.row == self.bankArray.count - 1)
            cell.action1.addTapGestureRecognizer {
                if self.bankArray.value(atSafe: indexPath.row)?.name.lowercased().hasSuffix("test bank)") ?? false {
                    self.bankTF.text = "\(self.bankArray.value(atSafe: indexPath.row)?.name ?? "")"
                    self.selectedBankName = self.bankArray.value(atSafe: indexPath.row)
                    self.bankTableHidden = !self.bankTableHidden
                    self.dropdownType = .bankName
                    self.removeTransparentView()
                    self.bankErrStack.isHidden = true
                }else{
                    self.showAlert(title: "Info", message: "Please select the test banks")
                }
                
            }
        }
        else if tableView == self.accountsTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "documentUploadsCell", for: indexPath) as? DocumentUploadsCell else {
                return UITableViewCell()
            }

           
            cell.fileName.text = self.bankStatementArray.value(atSafe: indexPath.row)?.fileName
            cell.closeView.addTapGestureRecognizer {
                self.bankStatementArray.remove(at: indexPath.row)
                self.accountsTable.reloadData()
            }
            return cell

        }
        else if tableView == self.gocardlessTable {
            
            if self.isAgreed {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "gocardStatementCell", for: indexPath) as? GocardStatementCell else {
                    return UITableViewCell()
                }
                let model = self.selectedGocardlessStatement.value(atSafe: indexPath.row)
                cell.bankName.text = model?.bankName
                cell.startDate.text = model?.startDate
                cell.endDate.text = model?.endDate
                cell.totalPeriods.text = ((model?.totalPeriods as? Int) != nil) ? (model?.totalPeriods as? Int)?.description : (model?.totalPeriods as? String)
                var image = model?.isPrimaryAccount ?? false ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
                cell.primaryButton.setImage(image, for: .normal)
                return cell
            } else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "gocardStatementCell2", for: indexPath) as? GocardStatementCell else {
                    return UITableViewCell()
                }
                let model = self.selectedGocardlessManualStatement.value(atSafe: indexPath.row)
                cell.bankName.text = model?.bankName
                var image = model?.isPrimaryAccount ?? false ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
                cell.primaryButton.setImage(image, for: .normal)
                return cell
            }
           
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.gocardlessTable && self.isAgreed {
            return 135
        }
        else if tableView == self.gocardlessTable && !self.isAgreed {
            return 100
        }
        else {
            return 50
        }
    }
}
extension GocartlessViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.gocardlessTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.gocardlessTableHeight.constant = newvalue.height
        }
        if let obj = object as? UITableView, obj == self.accountsTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.accountTableHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.gocardlessTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.accountsTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.gocardlessTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        guard let tblView2 = self.accountsTable else {return}
        if let _ = tblView2.observationInfo {
            tblView2.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
extension GocartlessViewController : UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.accNoTF {
            self.accNoErrStack.isHidden = true
        }
        if textField == self.accHolderNameTF {
            self.accHolderNameErrStack.isHidden = true
        }
        if textField == self.sortCodeTF {
            self.sortCodeErrStack.isHidden = true
        }
        if textField == self.countryCodeTF {
            self.countryCodeErrStack.isHidden = true
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {

        switch textField {
        case self.accNoTF:
            let eTest       = NSPredicate(format:"SELF MATCHES %@", Validations.RegexType.AllowBankAccount.rawValue)
            let result      = eTest.evaluate(with: self.accNoTF.text)

            if (self.accNoTF.text == nil || self.accNoTF.text == "") {
                self.accNoErrStack.isHidden = false
                self.accNoErrLabel.text = "Please enter Account Number"
            }
            else if result == false {
                self.accNoErrStack.isHidden = false
                self.accNoErrLabel.text = "Valid Account Number is required"
            }
        case self.sortCodeTF:
            let eTest       = NSPredicate(format:"SELF MATCHES %@", Validations.RegexType.AllowSortCode.rawValue)
            let result      = eTest.evaluate(with: self.sortCodeTF.text)

            if (self.sortCodeTF.text == nil || self.sortCodeTF.text == "") {
                self.sortCodeErrStack.isHidden = false
                self.sortCodeErrLabel.text = "Please enter Sort Code"
            }
            else if result == false {
                self.sortCodeErrStack.isHidden = false
                self.sortCodeErrLabel.text = "Valid Sort Code is required"
            }
        case self.accHolderNameTF:
            if (self.accHolderNameTF.text == nil || self.accHolderNameTF.text == "") {
                self.accHolderNameErrStack.isHidden = false
                self.accHolderNameErrLabel.text = "Please enter Account Holder Name"
            }

        case self.countryCodeTF:
            if (self.countryCodeTF.text == nil || self.countryCodeTF.text == "") {
                self.countryCodeErrStack.isHidden = false
                self.countryCodeErrLabel.text = "Please enter Country Code"
            }
        default:
            break
        }
        //        self.updateNextButton()
    }
    func goNext() -> Bool {
        if (self.countryCodeTF.text == nil || self.countryCodeTF.text == "") {
            return false
        }
        if (self.accHolderNameTF.text == nil || self.accHolderNameTF.text == "") {
            return false
        }
        if (self.sortCodeTF.text == nil || self.sortCodeTF.text == "") {
            return false
        }
        if (self.accNoTF.text == nil || self.accNoTF.text == "") {
            return false
        }
        if (self.selectedBankName?.name == nil || self.selectedBankName?.name == "") {
            return false
        }
        if !self.isDocumentUploaded {
            return false
        }
        return true
    }
    func isValidTextFields() {
        if (self.countryCodeTF.text == nil || self.countryCodeTF.text == "") {
            self.countryCodeErrStack.isHidden = false
            self.countryCodeErrLabel.text = "Please enter Country Code"
        }
        if (self.selectedBankName?.name == nil || self.selectedBankName?.name == "") {
            self.bankErrStack.isHidden = false
            self.bankErrLabel.text = "Please select Bank Name"
        }
        if (self.accNoTF.text == nil || self.accNoTF.text == "") {
            self.accNoErrStack.isHidden = false
            self.accNoErrLabel.text = "Please enter Account Number"
        }
        if (self.accHolderNameTF.text == nil || self.accHolderNameTF.text == "") {
            self.accHolderNameErrStack.isHidden = false
            self.accHolderNameErrLabel.text = "Please enter Account Holder Name"
        }
        if (self.sortCodeTF.text == nil || self.sortCodeTF.text == "") {
            self.sortCodeErrStack.isHidden = false
            self.sortCodeErrLabel.text = "Please enter Sort Code"
        }
        if !self.isDocumentUploaded {
            
            self.accountFileUploadErrStack.isHidden = false
            self.accountFileUploadErrLabel.text = "Please upload the document"
        }
    }
}
