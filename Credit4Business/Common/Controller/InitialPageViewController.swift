//
//  InitialPageViewController.swift
//  Credit4Business
//
//  Created by MacMini on 07/03/24.
//

import UIKit
import StepProgressBar
import IQKeyboardManagerSwift

enum DropDownType {
    case Business
    case Funding
    case Name
    case Duration
    case Representative
    case Director
    case BusinessSector
    case RegPost
    case RegPremise
    case TraPost
    case TraPremise
    case House
    case Address
    case Property
    case PaymentDay
    case step1
    case step2
    case companyName
    case bankName
    case history
    case loanNumber
    case none
}
enum DocumentType {
    case Photo
    case Passport
    case Bill
    case Premise
    case Account
    case Other
    case DrivingLicense
    case CouncilTax
    case none
}
enum BusinessMemberType : Int {
    case Director = 0
    case Partner = 1
    case SoleTrade = 2
    case none = 3
}
enum ModeOfApplication : String{
    case SelfMode
    case Representative
    case none
}
enum Option : String{
    case Yes
    case No
    case none
}
class InitialPageViewController: BaseViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var businessTypeView: UITextField!
    @IBOutlet weak var businessTypeTF: UITextField!
    @IBOutlet weak var businessTableHeight: NSLayoutConstraint!
    @IBOutlet weak var businessTable: UITableView!
    @IBOutlet weak var businessTableArrowActionView: UIView!
    @IBOutlet weak var businessTableArrow: UIImageView!
    @IBOutlet weak var businessTypeErrLabel: UILabel!
    @IBOutlet weak var businessTypeErrStack: UIStackView!

    @IBOutlet weak var tradingStyleView: UIView!
    @IBOutlet weak var tradingStyleTF: UITextField!
    @IBOutlet weak var tradingStyleErrLabel: UILabel!
    @IBOutlet weak var tradingStyleErrStack: UIStackView!

   
    @IBOutlet weak var companyNoView: UIStackView!
    @IBOutlet weak var companyNoTF: UITextField!
    @IBOutlet weak var companyNumberErrLabel: UILabel!
    @IBOutlet weak var companyNumberErrStack: UIStackView!

    @IBOutlet weak var companyNameTF: UITextField!
    @IBOutlet weak var companyNameErrLabel: UILabel!
    @IBOutlet weak var companyNameErrStack: UIStackView!

    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var fundingProcessView: UITextField!
    @IBOutlet weak var fundingProcessTF: UITextField!
    @IBOutlet weak var fundingTableHeight: NSLayoutConstraint!
    @IBOutlet weak var fundingTable: UITableView!
    @IBOutlet weak var fundingTableArrowActionView: UIView!
    @IBOutlet weak var fundingTableArrow: UIImageView!
    @IBOutlet weak var fundingProcessErrLabel: UILabel!
    @IBOutlet weak var fundingProcessErrStack: UIStackView!

    @IBOutlet weak var otherFundingPurposeStack: UIStackView!
    @IBOutlet weak var otherFundingPurposeView: UIStackView!
    @IBOutlet weak var otherFundingPurposeTF: UITextField!
    @IBOutlet weak var otherfundingProcessErrLabel: UILabel!
    @IBOutlet weak var otherfundingProcessErrStack: UIStackView!

    @IBOutlet weak var representativeImage: UIImageView!
    @IBOutlet weak var representativeView: UIView!
    @IBOutlet weak var selfImage: UIImageView!
    @IBOutlet weak var selfView: UIView!
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var representativeViewStack: UIStackView!
    @IBOutlet weak var representativeTableHeight: NSLayoutConstraint!
    @IBOutlet weak var representativeTable: UITableView!
    @IBOutlet weak var representativeTableArrowActionView: UIView!
    @IBOutlet weak var representativeTableArrow: UIImageView!
    @IBOutlet weak var representativeTypeView: UITextField!
    @IBOutlet weak var representativeTypeTF: UITextField!
    
    @IBOutlet weak var pendingAgreeButton: UIButton!
    @IBOutlet weak var pendingAgreementView: UIStackView!
    @IBOutlet weak var authorizeAgreeButton: UIButton!
    @IBOutlet weak var agreementView: UIStackView!
    
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var modeOfApplicationErrLabel: UILabel!
    @IBOutlet weak var modeOfApplicationErrStack: UIStackView!
    @IBOutlet weak var representativeErrLabel: UILabel!
    @IBOutlet weak var representativeErrStack: UIStackView!
    
   
    @IBOutlet weak var pageControl: CustomPageControl!
    //MARK: -------------------- Class Variable --------------------
    var selectedAdditionalResponse : AdditionalDataClass?
    var customerId = ""
    var delegate : CellDelegate?

    var businessTableHidden = true
    var fundingProcessTableHidden = true
    var nameTableHidden = true
    var durationTableHidden = true
    var representativeTableHidden = true
    var isAuthorizeAgreed = false
    var isPendingAgreed = false
    let userDefaults = UserDefaults.standard
    var dropdownType : DropDownType = .none
    var viewModel = HomeVM()
    var selectedBusinessType : Common?
    var selectedFundingProcess : Common?
    var selectedName : Common?
    var selectedDuration : Common?
    var selectedRepresentative : Common?
    var selectedMode : ModeOfApplication = .none
    var phone = ""
    var email = ""
    var isVerified = ""
    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.updateUI()
        self.manageActionMethods()
    }
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = true
        if UserDefaults.standard.value(forKey: "role") as? String != "" && isFromIncomplete {
            self.fetchAdditionalDetails()
        }
        if self.selectedAdditionalResponse != nil {
            self.showModelValues()
        }
    }
    
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
   //---------------------------------------
   // MARK: - Init With Story
   //---------------------------------------

   class func initWithStory() -> InitialPageViewController {
       let vc : InitialPageViewController = UIStoryboard.Main.instantiateViewController()
       return vc
   }
    
    //---------------------------------------
    // MARK: - Custom methods
    //---------------------------------------
    func setDelegates() {
        self.businessTable.delegate = self
        self.businessTable.dataSource = self
        self.fundingTable.delegate = self
        self.fundingTable.dataSource = self
        self.representativeTable.delegate = self
        self.representativeTable.dataSource = self
        self.companyNameTF.delegate = self
        self.tradingStyleTF.delegate = self
        self.companyNoTF.delegate = self
        self.otherFundingPurposeTF.delegate = self
        self.representativeTypeTF.delegate = self
        self.companyNameTF.keyboardType = .default
        self.tradingStyleTF.keyboardType = .default
        self.companyNoTF.keyboardType = .numberPad
    }
    func updateUI()
    {
        self.agreementView.isHidden = true
        self.pendingAgreementView.isHidden = true
        self.innerView.isHidden = true
//        email = self.userDefaults.value(forKey: "user_email") as? String ?? ""
//        phone = self.userDefaults.value(forKey: "user_phone") as? String ?? ""
//         isVerified = self.userDefaults.value(forKey: "isVerified") as? String ?? ""
//        if self.email != ""
//        {
//        }
//        if self.phone != ""
//        {
//        }
        self.pageControl.numberOfPages = 9
        self.setPagNumber(currentPage: 1)
        self.borderView.layer.borderWidth = 0.5
        self.borderView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
    }
    func setPagNumber(currentPage : Int) {
        self.pageControl.currentPage = currentPage
    }
    func manageActionMethods() {
        self.businessTableArrowActionView.addTapGestureRecognizer {
            self.dropdownType = .Business
            self.businessTableHidden = !self.businessTableHidden
            self.showHideTable()
        }
        self.businessTypeTF.addTapGestureRecognizer {
            self.dropdownType = .Business
            self.businessTableHidden = !self.businessTableHidden
            self.showHideTable()
        }
        self.fundingTableArrowActionView.addTapGestureRecognizer {
            self.dropdownType = .Funding
            self.fundingProcessTableHidden = !self.fundingProcessTableHidden
            self.showHideTable()
        }
        self.fundingProcessTF.addTapGestureRecognizer {
            self.dropdownType = .Funding
            self.fundingProcessTableHidden = !self.fundingProcessTableHidden
            self.showHideTable()
        }
      
        self.selfView.addTapGestureRecognizer {
            self.selectedMode = .SelfMode
//            self.representativeImage.image = UIImage(systemName: "circle")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
//            self.selfImage.image = UIImage(systemName: "dot.circle")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
//            if self.isVerified == "true" {
//                self.verifiedLabel.isHidden = false
//            }else{
//                self.verifiedLabel.isHidden = true
//                self.otpStackView.isHidden = false
//                self.otpStack.isHidden = false
//            }
            self.representativeImage.image = UIImage.init(named: "radioUnselected")
            self.selfImage.image = UIImage.init(named: "radioSelected")

            self.agreementView.isHidden = true
            self.pendingAgreementView.isHidden = true
            self.innerView.isHidden = true
            self.modeOfApplicationErrStack.isHidden = true
        }
        self.representativeView.addTapGestureRecognizer {
            self.selectedMode = .Representative
            self.selfImage.image = UIImage.init(named: "radioUnselected")
            self.representativeImage.image = UIImage.init(named: "radioSelected")
//            if self.isVerified == "true" {
//                self.verifiedLabel.isHidden = false
//            }else{
//                self.verifiedLabel.isHidden = true
//                self.otpStackView.isHidden = false
//                self.otpStack.isHidden = false
//            }
            self.agreementView.isHidden = false
            self.pendingAgreementView.isHidden = false
            self.innerView.isHidden = false
            self.modeOfApplicationErrStack.isHidden = true
        }
//        self.representativeTableArrowActionView.addTapGestureRecognizer {
//            self.dropdownType = .Representative
//            self.representativeTableHidden = !self.representativeTableHidden
//            self.showHideTable()
//        }
//        self.representativeTypeTF.addTapGestureRecognizer {
//            self.dropdownType = .Representative
//            self.representativeTableHidden = !self.representativeTableHidden
//            self.showHideTable()
//        }
        self.nextButton.addTapGestureRecognizer {
            if !isSkip {
                self.isValidTextFields()
                if self.goNext() {
                    self.updateModel()
                }}else{
//                    self.updateModel()
                    var vc = FundingViewController.initWithStory(loanId: "")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            
        }
        self.backButton.addTapGestureRecognizer {
            GlobalFundingModelObject = FundingModel()
            self.navigationController?.popViewController(animated: true)
        }

    }
    func showModelValues() {
        guard let initial = self.selectedAdditionalResponse else {return}
        self.companyNameTF.text = initial.companyName
        self.businessTypeTF.text = initial.businessType
//        self.selectedBusinessType = self.viewModel.businessTypeArray.filter({$0.description == initial.businessType}).first
        self.selectedBusinessType = self.viewModel.businessTypeArray.filter({$0.description.contains(initial.businessType)}).first
        print()
        self.businessTypeTF.text = self.selectedBusinessType?.description
        self.tradingStyleTF.text = initial.tradingStyle
        self.companyNoTF.text = initial.companyNumber
        self.fundingProcessTF.text = initial.fundingPurpose
        self.selectedFundingProcess = self.viewModel.fundingPurposeArray.filter({$0.description == initial.fundingPurpose}).first

        self.otherFundingPurposeTF.text = initial.otherFundingPurpose.debugDescription
        self.selectedMode = initial.modeOfApplication == "Representative" ? .Representative : .SelfMode
        self.showSelectedModeValues()
        if initial.representatives != nil {
//            self.selectedRepresentative = self.viewModel.representativeArray.value(atSafe: initial.representatives ?? 0)
            self.representativeTypeTF.text = initial.representatives

            self.isPendingAgreed = true
            self.isAuthorizeAgreed = true
            self.pendingAgreeButton.setImage(UIImage(named: "checkboxSelected"), for: .normal)
            self.authorizeAgreeButton.setImage(UIImage(named: "checkboxSelected"), for: .normal)

        }
    }
    func showSelectedModeValues() {
        if selectedMode == .SelfMode {
            self.representativeImage.image = UIImage.init(named: "radioUnselected")
            self.selfImage.image = UIImage.init(named: "radioSelected")

            self.agreementView.isHidden = true
            self.pendingAgreementView.isHidden = true
            self.innerView.isHidden = true
            self.modeOfApplicationErrStack.isHidden = true
        }else if selectedMode == .Representative {
            self.selectedMode = .Representative
            self.selfImage.image = UIImage.init(named: "radioUnselected")
            self.representativeImage.image = UIImage.init(named: "radioSelected")
//            if self.isVerified == "true" {
//                self.verifiedLabel.isHidden = false
//            }else{
//                self.verifiedLabel.isHidden = true
//                self.otpStackView.isHidden = false
//                self.otpStack.isHidden = false
//            }
            self.agreementView.isHidden = false
            self.pendingAgreementView.isHidden = false
            self.innerView.isHidden = false
            self.modeOfApplicationErrStack.isHidden = true
        }
    }
    func updateModel() {
        let model = GlobalFundingModelObject
        var initial = model.initial//InitialModel()
        initial.companyName = self.companyNameTF.text ?? ""
        initial.businessType = self.selectedBusinessType
//        initial.email = self.emailTF.text ?? ""
        initial.tradingStyle = self.tradingStyleTF.text ?? ""
        initial.companyNumber = self.companyNoTF.text ?? ""
//        initial.firstName = self.firstNameTF.text ?? ""
//        initial.lastName = self.lastNameTF.text ?? ""
//        initial.title = self.titleLabel.text ?? ""
//        initial.phone = self.phoneTF.text ?? ""
        initial.fundingProcess = self.fundingProcessTF.text ?? ""
        initial.otherFunding = self.otherFundingPurposeTF.text ?? ""
//        initial.fundRequest = self.fundRequestTF.text ?? ""
//        initial.duration = self.durationLabel.text ?? ""
        initial.modeOfApplication = self.selectedMode.rawValue
        initial.representative = self.representativeTypeTF.text ?? ""
        model.initial = initial
        
        var dict2 = JSON()
        dict2["company_name"] = initial.companyName
        dict2["business_type"] = initial.businessType?.description == "Limited Partnership (LLP)" ? "Limited Partnership" : initial.businessType?.description
//        dict2["email"] = initial.email
        dict2["trading_style"] = initial.tradingStyle
        dict2["company_number"] = initial.companyNumber
//        dict2["title"] = initial.title
//        dict2["first_name"] = initial.firstName
//        dict2["phone_number"] = initial.phone
//        dict2["last_name"] = initial.lastName
        if initial.fundingProcess == "Other (Please Specify)" {
            dict2["funding_purpose"] = "Other (please specify)"
        }else{
            dict2["funding_purpose"] = initial.fundingProcess
        }
        dict2["other_purpose_purpose"] = self.otherFundingPurposeTF.text ?? ""
//        dict2["fund_request_amount"] = initial.fundRequest
//        dict2["fund_request_duration_weeks"] = initial.duration
        dict2["agree_authorization"] = true
        dict2["is_pending_threatened_or_recently"] = true
        dict2["mode_of_application"] = initial.modeOfApplication == "SelfMode" ? "Self" : "Representative"
//        dict2["is_otp_verified"] = true
        if initial.modeOfApplication != "SelfMode" {
            dict2["representatives"] = initial.representative
        }
//        dict2["representatives"] = (self.viewModel.representativeArray.firstIndex(where: ({$0.description == initial.representative})) ?? 0) + 1

//        dict2["apply_for_funding_assisted"] = false
        //self.callGeneralDetailsAPI(parms: dict2)
        
        self.createAdditionalDetails(params: dict2)
    }
    func createAdditionalDetails(params: JSON) {
        var url = APIEnums.createAdditional.rawValue
        if customerId != "" {
            url = url + "?customer_id=\(customerId)"
        }
        APIService.shared.makeRequest(endpoint: url,
                                      withLoader: true,
                                      method: .post,
                                      params: params) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    if self.delegate != nil {
                        self.delegate?.reload()
                        self.dismiss(animated: true)
                    }else{
                        var vc = FundingViewController.initWithStory(loanId: "")
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else if data.statusCode == 401 {
                    self.tokenRefreshApi(params: params)
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
    
    func tokenRefreshApi(params: JSON) {
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

                    self.createAdditionalDetails(params: params)
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
    func fetchAdditionalDetails() {
        APIService.shared.retrieveAdditionalFormDetails() { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedAdditionalResponse = responseData
                        self.showModelValues()
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
    func callGeneralDetailsAPI(parms: [AnyHashable: Any]){
        self.viewModel
            .GeneralDetailsApicall(parms: parms){(result) in
                switch result{
                case .success:
                var vc = FundingViewController.initWithStory(loanId: "")
                self.navigationController?.pushViewController(vc, animated: true)

                case .failure(let error):
                    break
                }
            }
    }
    @IBAction func pendingAgreeAction(_ sender: Any) {
        self.isPendingAgreed = !self.isPendingAgreed
        if !self.isPendingAgreed{
            self.pendingAgreeButton.setImage(UIImage(named: "checkboxUnselected"), for: .normal)
        }else{
            self.modeOfApplicationErrLabel.text = "Please choose the Mode of application"

            self.modeOfApplicationErrStack.isHidden = self.isAuthorizeAgreed ? true : false
            self.pendingAgreeButton.setImage(UIImage(named: "checkboxSelected"), for: .normal)
        }
    }
    @IBAction func authorizeAgreeAction(_ sender: Any) {
        self.isAuthorizeAgreed = !self.isAuthorizeAgreed
        if !self.isAuthorizeAgreed{
            self.authorizeAgreeButton.setImage(UIImage(named: "checkboxUnselected"), for: .normal)
        }
        else{
            self.modeOfApplicationErrLabel.text = "Please choose the Mode of application"

            self.modeOfApplicationErrStack.isHidden = self.isPendingAgreed ? true : false
            self.authorizeAgreeButton.setImage(UIImage(named: "checkboxSelected"), for: .normal)
        }
    }
    
    func showHideTable() {
        switch self.dropdownType {
      
        case .Business:
            if self.businessTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        case .Funding:
            if self.fundingProcessTableHidden {
                self.removeTransparentView()
            }else{
                self.addTransparentView()
            }
        case .Name:
            if self.nameTableHidden {
                self.removeTransparentView()
            }else{
                self.addTransparentView()
            }
        case .Duration:
            if self.durationTableHidden {
                self.removeTransparentView()
            }else{
                self.addTransparentView()
            }
        case .Representative:
            if self.representativeTableHidden {
                self.removeTransparentView()
            }else{
                self.addTransparentView()
            }
        default:
            break
        }
        
    }
}

extension InitialPageViewController {
    func addTransparentView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                switch self.dropdownType {
               
                case .Business:
                    self.businessTable.isHidden = false
                    self.businessTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)

                    self.businessTableHeight.constant = CGFloat(self.viewModel.businessTypeArray.count * 50)
                    self.businessTable.reloadData()
                    self.view.layoutIfNeeded()

                case .Funding:
                    self.fundingTable.isHidden = false
                    self.fundingTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                    self.fundingTableHeight.constant = CGFloat(self.viewModel.fundingPurposeArray.count * 50)
                    self.fundingTable.reloadData()
                    self.view.layoutIfNeeded()
                case .Representative:
                    self.representativeTable.isHidden = false
                    self.representativeTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                    self.representativeTableHeight.constant = CGFloat(self.viewModel.representativeArray.count * 50)
                    self.representativeTable.reloadData()
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
            
            case .Business:
                self.businessTable.isHidden = true
                self.businessTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.businessTableHeight.constant = 0
                self.businessTable.reloadData()
            case .Funding:
                self.fundingTable.isHidden = true
                self.fundingTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.fundingTableHeight.constant = 0
                self.fundingTable.reloadData()
          
            case .Representative:
                self.representativeTable.isHidden = true
                self.representativeTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.representativeTableHeight.constant = 0
                self.representativeTable.reloadData()
            default:
                break

            }
        }, completion: nil)
    }
}
extension InitialPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch self.dropdownType {
        case .Business:
            count = self.viewModel.businessTypeArray.count
        case .Funding:
            count = self.viewModel.fundingPurposeArray.count
        case .Name:
            count = self.viewModel.nameArray.count
        case .Duration:
            count = self.viewModel.durationArray.count
        case .Representative:
            count = self.viewModel.representativeArray.count
        default:
            break

        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.dropdownType == .Business {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? CellClass else {
                return UITableViewCell()
            }
            cell.documentLabel.text = self.viewModel.businessTypeArray.value(atSafe: indexPath.row)?.description
            cell.documentSelectAction.setTitle("", for: .normal)
            cell.separatorLabel.isHidden = (indexPath.row == self.viewModel.businessTypeArray.count - 1)
            cell.documentSelectAction.addTapGestureRecognizer {
                self.businessTypeTF.text = "\(self.viewModel.businessTypeArray.value(atSafe: indexPath.row)?.description ?? "")"
                self.selectedBusinessType = self.viewModel.businessTypeArray.value(atSafe: indexPath.row)
                self.businessTableHidden = !self.businessTableHidden
                self.dropdownType = .Business
                self.removeTransparentView()
                self.businessTypeErrStack.isHidden = true
            }
        }
        else if self.dropdownType == .Funding {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as? CellClass3 else {
                return UITableViewCell()
            }
            cell.label2.text = self.viewModel.fundingPurposeArray.value(atSafe: indexPath.row)?.description
            cell.action2.setTitle("", for: .normal)
            cell.separator2.isHidden = (indexPath.row == self.viewModel.fundingPurposeArray.count - 1)
            cell.action2.addTapGestureRecognizer {
                self.fundingProcessTF.text = "\(self.viewModel.fundingPurposeArray.value(atSafe: indexPath.row)?.description ?? "")"
                self.selectedFundingProcess = self.viewModel.fundingPurposeArray.value(atSafe: indexPath.row)
                self.fundingProcessTableHidden = !self.fundingProcessTableHidden
                self.dropdownType = .Funding
                self.removeTransparentView()
                if self.selectedFundingProcess?.description == self.viewModel.fundingPurposeArray.value(atSafe: self.viewModel.fundingPurposeArray.count - 1)?.description ?? "" {
                    self.otherFundingPurposeStack.isHidden = false
                }else{
                    self.otherFundingPurposeStack.isHidden = true
                }
                self.fundingProcessErrStack.isHidden = true
            }
        }
        
        else if self.dropdownType == .Representative {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as? CellClass5 else {
                return UITableViewCell()
            }
            cell.label4.text = self.viewModel.representativeArray.value(atSafe: indexPath.row)?.description
            cell.action4.setTitle("", for: .normal)
            cell.separator4.isHidden = (indexPath.row == self.viewModel.representativeArray.count - 1)
            cell.action4.addTapGestureRecognizer {
                self.representativeTypeTF.text = "\(self.viewModel.representativeArray.value(atSafe: indexPath.row)?.description ?? "")"
                self.selectedRepresentative = self.viewModel.representativeArray.value(atSafe: indexPath.row)
                self.representativeTableHidden = !self.representativeTableHidden
                self.dropdownType = .Representative
                self.removeTransparentView()
                self.modeOfApplicationErrStack.isHidden = true
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
//MARK: -------------------------- UITextField Delegate Methods --------------------------
extension InitialPageViewController : UITextFieldDelegate {
    
    
    func updateProceedButtonUI(enabled: Bool) {
        self.nextButton.isUserInteractionEnabled = enabled
//        self.nextButton.backgroundColor = enabled ? UIColor.init(named: "blue") :  UIColor.init(named: "grayborder")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.companyNameTF {
            self.companyNameErrStack.isHidden = true
        }
        
        if textField == self.tradingStyleTF {
            self.tradingStyleErrStack.isHidden = true
        }
        if textField == self.companyNoTF {
            self.companyNumberErrStack.isHidden = true
        }
      
        if textField == self.otherFundingPurposeTF {
            self.otherfundingProcessErrStack.isHidden = true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        switch textField {
        case self.companyNameTF:
            if (self.companyNameTF.text == nil || self.companyNameTF.text == "") {
                self.companyNameErrStack.isHidden = false
                self.companyNameErrLabel.text = "Please enter company Name"
            }
        
        case self.tradingStyleTF:
            if (self.tradingStyleTF.text == nil || self.tradingStyleTF.text == "") {
                self.tradingStyleErrStack.isHidden = false
                self.tradingStyleErrLabel.text = "Please enter Business / Shop Name"
            }
        case self.companyNoTF:
            if (self.companyNoTF.text == nil || self.companyNoTF.text == "") {
                self.companyNumberErrStack.isHidden = false
                self.companyNumberErrLabel.text = "Please enter company Number"
            }
       
        case self.otherFundingPurposeTF:
            if (self.otherFundingPurposeTF.text == nil || self.otherFundingPurposeTF.text == "") && !self.otherFundingPurposeTF.isHidden {
                self.otherfundingProcessErrStack.isHidden = false
                self.otherfundingProcessErrLabel.text = "Please fill the details"
            }
        default:
            break
        }
        //        self.updateNextButton()
    }
   
        func goNext() -> Bool {
            if (self.companyNameTF.text == nil || self.companyNameTF.text == "") {
                return false
            }
            if (self.selectedBusinessType?.description == nil || self.selectedBusinessType?.description == "") {
                return false
            }
            if (self.tradingStyleTF.text == nil || self.tradingStyleTF.text == "") {
                return false
            }
            if (self.companyNoTF.text == nil || self.companyNoTF.text == "") {
                return false
            }
            if (self.selectedFundingProcess?.description == nil || self.selectedFundingProcess?.description == "") {
                return false
            }
//
            if !otherFundingPurposeStack.isHidden && (self.otherFundingPurposeTF.text == nil || self.otherFundingPurposeTF.text == "") {
                return false
            }
            if (self.selectedMode == .none) {
                return false
            }
            if ((self.representativeTypeTF.text == nil || self.representativeTypeTF.text == "") && self.selectedMode == .Representative) {
                return false

            }
            if (!isPendingAgreed || !isAuthorizeAgreed) && self.selectedMode == .Representative {
                return false
            }
            return true
        }
    
    func isValidTextFields() {
        if (self.companyNameTF.text == nil || self.companyNameTF.text == "") {
            self.companyNameErrStack.isHidden = false
            self.companyNameErrLabel.text = "Please enter company Name"
        }
        if (self.selectedBusinessType?.description == nil || self.selectedBusinessType?.description == "") {
            self.businessTypeErrStack.isHidden = false
            self.businessTypeErrLabel.text = "Please select business type"
        }
        if (self.tradingStyleTF.text == nil || self.tradingStyleTF.text == "") {
            self.tradingStyleErrStack.isHidden = false
            self.tradingStyleErrLabel.text = "Please enter Business / Shop Name"
        }
        if (self.companyNoTF.text == nil || self.companyNoTF.text == "") {
            self.companyNumberErrStack.isHidden = false
            self.companyNumberErrLabel.text = "Please enter company Number"
        }
        if !otherFundingPurposeStack.isHidden && (self.otherFundingPurposeTF.text == nil || self.otherFundingPurposeTF.text == "") {
            self.otherfundingProcessErrStack.isHidden = false
            self.otherfundingProcessErrLabel.text = "Please fill the details"
        }

        if (self.selectedFundingProcess?.description == nil || self.selectedFundingProcess?.description == "") {
            self.fundingProcessErrStack.isHidden = false
            self.fundingProcessErrLabel.text = "Please select Funding Process"
        }

        if (self.selectedMode == .none) {
            self.modeOfApplicationErrStack.isHidden = false
            self.modeOfApplicationErrLabel.text = "Please choose the Mode of application"
        }
        if ((self.representativeTypeTF.text == nil || self.representativeTypeTF.text == "") && self.selectedMode == .Representative) {
            self.modeOfApplicationErrStack.isHidden = false
            self.modeOfApplicationErrLabel.text = "Please enter Representative"
        }
        if (!isPendingAgreed || !isAuthorizeAgreed) && self.selectedMode == .Representative {
            self.modeOfApplicationErrStack.isHidden = false
            self.modeOfApplicationErrLabel.text = "Please agree the terms and conditions"
        }
    }

}
enum Validations {
    
    enum RegexType : String {
        case AlpabetsAndSpace                       = "^[A-Za-z ]{0,700}$"//"[\\p{L} ]{0,350}$"////*
        case AlphaNumeric                           = "^[A-Za-z0-9 ]*$"
        case OnlyNumber                             = "^[0-9]*$"
        case OnlyNonZeroNumber                      = "^[1-9][0-9]*$"
        case Amount                                 = "^[0-9.]*$"
        case UserId                                 = "^[a-z][a-z0-9._]*$"
        case AllowDecimal                           = "^[0-9]*((\\.|,)[0-9]{0,2})?$"
        case VIN                                    = "^[A-HJ-NPR-Z0-9]{0,50}$"//"^[A-HJ-NPR-Z0-9]*$"
        
        case Password                               = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*\\d)[a-zA-Z\\d|#@$!%*?&.]{6,}$"
        case Allow700                               = "[\\p{L}\\d -.,_/]{0,350}$"//"^[A-Za-z0-9-.,_/ ]{0,700}$"
        case AllowAmount                            = "^([1-9][0-9]{0,4}(\\.)?[0-9]{0,2})?$"
        case AllowPincode                           = "^([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z])))) {0,1}[0-9][A-Za-z]{2})$"
        case validMobileNumber                      = "^[0-9+]{0,1}+[0-9]{9,9}$"
        case fakeMobileNumber                       = #"(\d)\1{9}"#//"([0-9])\\1*"
        case dummyMobileNumber                      = "^[0-5].*$"
        case nameValidation                         = "^(?=.*[a-zA-Z ])[a-zA-Z0-9 ]{3,25}$"
        case AllowBankAccount = "^[0-9]{8}$"
        case AllowSortCode = "^[0-9]{6}$"
    }
    
    enum PhoneNumber : Int {
        case Minimum                                = 10
       // case Maximum                                = 16
    }
    
    enum Password : Int {
        case Minimum                                = 8
        case Maximum                                = 30
    }
    
    enum MaxCharacterLimit: Int {
        case Name                                   = 15
        case VIN                                    = 17
        case LargestTank                            = 6
        case Notes                                  = 100
        case Ticket                                 = 250
        case Feedback                               = 350
        case Odometer                               = 7
        case FuelCost                               = 10
        case Email                                  = 254
        case Search                                 = 20
        case StandardName                           = 255
        case ComRegNumber                           = 25
        case NozzleCount                            = 2
        case card                                   = 16
        case cvv                                    = 3
        case imageKbSize                            = 6000
    }
   
}
