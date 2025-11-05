//
//  LeadsDetailsVC.swift
//  Credit4Business
//
//  Created by MacMini on 29/04/24.
//

import UIKit
import SDWebImage
import Photos
import MobileCoreServices
import UniformTypeIdentifiers
import IQKeyboardManagerSwift
class LeadsDetailsVC: UIViewController,CellDelegate, loanSubmitDelegate {
    func reload(loanDetails: LoanSubmitModel) {
        self.loanStatus = loanDetails.loanStatusData.currentStatus
        self.loanUpcomingStatus = loanDetails.loanStatusData.upcomingStatus
        self.showSubmit()
        self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.selectedIndex = 0
    }
    
    func reload() {
        if self.selectedIndex == 0 {
            self.fetchPersonalDetails()
        }
//        else if self.selectedIndex == 1 {
//            self.fetchAdditionalDetails(customerId: self.customerData.id)
//        }
        else if self.selectedIndex == 1 {
            self.fetchBusinessDetails()
        }else if self.selectedIndex == 2 {
            self.fetchPremiseDetails()
        }
        else if self.selectedIndex == 3 {
            self.fetchDirectorDetails()
        }
        else if self.selectedIndex == 4 {
            self.fetchConsentDetails()
        }
        else if self.selectedIndex == 5 {
            self.fetchUploadedDocuments()
        }
        else if self.selectedIndex == 6 {
            self.fetchGuarantorDetails()
        }
        self.showSubmit()

    }
    
    func particularReloadOf() {
        
    }
    
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    
    @IBOutlet weak var submitLoanBtnView: UIView!
    @IBOutlet weak var submitLoanButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var detailsTable: UITableView!
    @IBOutlet weak var headersCollection: UICollectionView!
    @IBOutlet weak var remarksButton: UIButton!
    @IBOutlet weak var detailTableHeight: NSLayoutConstraint!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var agreementStack: UIStackView!
    @IBOutlet weak var leadsImage: UIImageView!
    @IBOutlet weak var loanStatusButton: UIButton!
    @IBOutlet weak var leadPhone: UILabel!
    @IBOutlet weak var leadName: UILabel!
    @IBOutlet weak var leadsNameHeader: UILabel!
    @IBOutlet weak var identityVerificationView: UIView!
    
    @IBOutlet weak var identityVerificationResentBtn: UIButton!
    @IBOutlet weak var identityVerificationSendBtn: UIButton!
    @IBOutlet weak var identityVerificationFailView: UIView!
    @IBOutlet weak var directorsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var directorsTable: UITableView!
    @IBOutlet weak var directorKycStatusLabel: UILabel!
    @IBOutlet weak var identityVerificationSuccessView: UIStackView!
    
    
    @IBOutlet weak var fetchBankAccountsBtn: UIButton!
    @IBOutlet weak var step1Stack: UIStackView!
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

    @IBOutlet weak var gocardlessView: UIView!
    @IBOutlet weak var step2StatusButton: UIButton!
    @IBOutlet weak var step1StatusButton: UIButton!
    @IBOutlet weak var requisitionButton: UIButton!
    @IBOutlet weak var requisitionStack: UIView!
    
    @IBOutlet weak var step3Stack: UIView!
    @IBOutlet weak var step2DropDown: UIStackView!

    @IBOutlet weak var gocardlessTableHeight: NSLayoutConstraint!
    @IBOutlet weak var gocardlessTable: UITableView!
    @IBOutlet weak var gocardlessStatusButton: UIButton!
    
    @IBOutlet weak var gocardlessStatusView: UIView!
    
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
    var selectedGocardlessManualStatement = [BankDetail]()
    
    @IBOutlet weak var documentStack: UIStackView!
    @IBOutlet weak var countryCodeStack: UIStackView!
    @IBOutlet weak var accountHolderStack: UIStackView!
    @IBOutlet weak var sortCodeStack: UIStackView!
    @IBOutlet weak var accountNumberStack: UIStackView!
    @IBOutlet weak var bankNumberStack: UIStackView!
    var bankTableHidden = true
    var selectedBankName : BankData?
    var isAgreed = true
    var documentType : DocumentType = .none
    var isDocumentUploaded = false
    var bankStatementArray = [UploadDocumentModel]()
    var accountFileUploadStr = ""
  
    var accountFileUploadMIME = ""
   
    var accountFileUploadType = ""
    
    var accountFileName = ""
   
    var accountFileUploadData = Data()
    var selectedDocumentsResponseForGocardless : DocumentsDataClass?
    var sections = [SectionData]()

    //MARK: -------------------- Class Variable --------------------
    var customerName = ""
    var customerPhone = ""
    var customerId = ""
    var customerImage = ""
    var completePersonalDetail = false
    var completeBusinessDetail = false
    var completeBusinessPremisDetail = false
    var completeMarketingPreference = false
    var completeDocuments = false
    var completeGuarantors = false
    var directorDetail = false
    var identityVerified = false
    var gocardlessStatement = false
    var loanID = ""
    var loanStatus = ""
    var loanUpcomingStatus = ""
//    var customerName = ""
//    var customerPhone = ""
    var viewModel = HomeVM()
    var menuItems = ["Personal Details", "Business Details","Business Premise Details","Director/Proprietor Details", "Market Preferences","Documents Upload","Guarantor Details","Identity Verification","GoCardless"]//,"Signed Contract"]
    var selectedIndex = 0
    var selectedPersonalResponse : PersonalDataClass?
    var personalKVArray = [MenuModel]()
    var selectedAdditionalResponse : AdditionalDataClass?
    var additionalKVArray = [MenuModel]()
    var selectedBusinessResponse : BusinessDataClass?
    var businessKVArray = [MenuModel]()
    var registerKVArray = [MenuModel]()
    var tradingKVArray = [MenuModel]()
    var directorDictionary = [[MenuModel]]()
    var selectedConsentResponse : DataClass?
    var selectedDocumentsResponse : DocumentsDataClass?
    var selectedPremiseResponse : PremiseDataClass?
    var selectedDirectorsResponse = [SelectedDirector]()
    var selectedGuarantorResponse : GuarantorDataClass?
    var guarantorKVArray = [MenuModel]()
  //  var documentsKVArray = [MenuModel]()
    
    var photoArray = [MenuModel]()
    var passportArray = [MenuModel]()
    var utilityArray = [MenuModel]()
    var licenseArray = [MenuModel]()
    var councilArray = [MenuModel]()
    var leaseArray = [MenuModel]()

    var otherDocumentsKVArray = [MenuModel]()
    var statementDocumentsKVArray = [MenuModel]()
    //var isStatementAvailable = false
   // var isOtherAvailable = false
    var signedContractKVArray = [MenuModel]()
    var selectedSignedContractResponse : ContractData?
    var selectedIdentityVerificationResponse: IdentityVerificationStatusModel?
    var step1TableHidden = true
    var step2TableHidden = true
    var selectedStep1 : BankData?
    var selectedStep2 : String?
    var dropdownType : DropDownType = .none
    var bankArray = [BankData]()
    var bankAccountArray = [Account]()
    var requisitionData : RequisitionClass?
    var selectedGocardlessStatement = [GocardlessData]()
    var requisitionLink = ""
    @IBOutlet weak var generateRegenerateBtn: UIButton!

    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.addObserverOnHeightTbl()
        self.manageActionMethods()
        let attributedTitle = NSMutableAttributedString(string: "Generate Link", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 11.0), NSAttributedString.Key.foregroundColor: UIColor(named: "blue"),NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])

        self.generateRegenerateBtn.setAttributedTitle(attributedTitle, for: .normal)

        self.fetchCompanyDetails()
        self.fetchPersonalDetails()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.isEnabled = true
        self.navigationController?.isNavigationBarHidden = true
        if let tabbar = self.parent?.parent as? TabBarController {
            if let navigationController = tabbar.parent as? UINavigationController {
                navigationController.isNavigationBarHidden = true
            }
        }

//        self.tabBarController?.tabBar.isHidden = true
       self.showSubmit()
    }
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.isEnabled = false
    }
    func showSubmit() {
        self.fetchLoanDetails()
//        if ((self.loanStatus.lowercased() == "submitted" && self.loanUpcomingStatus.lowercased() == "agent_submission_waiting") || (self.loanStatus.lowercased() == "inprogress" && self.loanUpcomingStatus.lowercased() == "submission_waiting")) && completePersonalDetail && completeBusinessDetail && completeBusinessPremisDetail && directorDetail && identityVerified && gocardlessStatement{
//            self.submitLoanBtnView.isHidden = false
//        }
//        else {
//            self.submitLoanBtnView.isHidden = true
//        }
    }
    func setDelegates() {
        self.headersCollection.delegate = self
        self.headersCollection.dataSource = self
        self.detailsTable.delegate = self
        self.detailsTable.dataSource = self
        self.gocardlessTable.delegate = self
        self.gocardlessTable.dataSource = self
        self.directorsTable.delegate = self
        self.directorsTable.dataSource = self
        self.step1Table.delegate = self
        self.step1Table.dataSource = self
        self.step2Table.delegate = self
        self.step2Table.dataSource = self
        self.leadsNameHeader.text = self.customerName
        self.leadName.text = self.customerName
        self.leadPhone.text = "+44 " + self.customerPhone
        if self.loanStatus != "" {
           // cell.loanStatusButton.isHidden = false
            var color = "yellow"
            if self.loanStatus == "Admin_Cash_Disbursed" {
                color = "green"
            }else if self.loanStatus.lowercased().contains("rejected") ?? false || self.loanStatus.lowercased().contains("returned") ?? false {
                color = "red"
            }
            self.loanStatusButton.backgroundColor = UIColor(named: color)?.withAlphaComponent(0.4)
            let attributedTitle = NSMutableAttributedString(string: self.loanStatus, attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: color)])

            self.loanStatusButton.setAttributedTitle(attributedTitle, for: .normal)
            var status = self.loanStatus.replacingOccurrences(of: "_", with: "")
            if self.loanStatus == "Inprogress" || self.loanStatus == "Submitted" ||  self.loanStatus == "Underwriter returned" {
                self.editButton.isHidden = false
            }else{
                self.editButton.isHidden = true
            }
            
        }
        self.leadsImage.sd_setImage(with: URL(string: self.customerImage ?? ""))
        self.step2Stack.isHidden = true
        self.requisitionStack.isHidden = true
        self.gocardlessTable.isHidden = true
        self.gocardlessStatusView.isHidden = true
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
    func manageActionMethods() {
        self.generateRegenerateBtn.addTapGestureRecognizer {
            if self.step1TF.text != "" {
                var params = JSON()
                params["bank_name"] = self.step1TF.text
                params["institution_id"] = "SANDBOXFINANCE_SFIN0000"
                self.createRequisitionDetails(loanId:self.loanID,params: params)            }
           
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

            //self.step2Stack.isHidden = !self.isAgreed
            self.accNoErrStack.isHidden = true
            self.accHolderNameErrStack.isHidden = true
            self.sortCodeErrStack.isHidden = true
            self.countryCodeErrStack.isHidden = true
            self.bankErrStack.isHidden = true
           // if !self.isAgreed {
                self.fetchGocardlessManualStatementDetails()
           // }else{
                self.fetchGocardlessStatementDetails()
           // }
            if self.step1TF.text != "" && self.requisitionLink != "" && self.isAgreed && !self.step1Stack.isHidden {
                let attributedTitle = NSMutableAttributedString(string: "Completed", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: "yellow")])

                self.step1StatusButton.setAttributedTitle(attributedTitle, for: .normal)

                self.step2Stack.isHidden = false
                self.requisitionStack.isHidden = false
                self.step3Stack.isHidden = true
                self.step2DropDown.isHidden = true
            }
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
        self.submitLoanButton.addTapGestureRecognizer {
            let vc = SubmitPopupVC.initWithStory(loanId: self.loanID)
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            self.present(vc, animated: true)
        }
        self.backBtn.addTapGestureRecognizer {

            self.navigationController?.popViewController(animated: true)
        }
        self.identityVerificationSendBtn.addTapGestureRecognizer {
            self.createIdentityDetails()
            self.identityVerificationSendBtn.isHidden = true
            self.identityVerificationResentBtn.isHidden = false
        }
        self.identityVerificationResentBtn.addTapGestureRecognizer {
            self.createIdentityDetails()
        }
        self.remarksButton.addTapGestureRecognizer {
            let vc = RemarksVC.initWithStory(loanId: self.loanID)
            vc.isRemarks = true
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        self.commentButton.addTapGestureRecognizer {
            let vc = RemarksVC.initWithStory(loanId: self.loanID)
            vc.isRemarks = false
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        self.editButton.addTapGestureRecognizer {
            if self.selectedIndex == 0 {
                let vc = PersonalViewController.initWithStory(loanId: "")
                vc.selectedPersonalResponse = self.selectedPersonalResponse
                vc.loanId = self.loanID
                vc.delegate = self
                vc.modalPresentationStyle = .formSheet
                self.present(vc, animated: true)
            }
//            else if self.selectedIndex == 1 {
//                let vc = InitialPageViewController.initWithStory()
//                vc.selectedAdditionalResponse = self.selectedAdditionalResponse
//                vc.customerId = self.customerData.id
//                vc.delegate = self
//                vc.modalPresentationStyle = .formSheet
//                self.present(vc, animated: true)
//            }
            else if self.selectedIndex == 1 {
                let vc = FundingViewController.initWithStory(loanId: "")
                vc.selectedBusinessResponse = self.selectedBusinessResponse
                vc.loanId = self.loanID
                vc.delegate = self
                vc.modalPresentationStyle = .formSheet
                self.present(vc, animated: true)
            }
            else if self.selectedIndex == 2 {
                let vc = PremiseDetailsViewController.initWithStory(loanId: "")
                vc.selectedPremiseResponse = self.selectedPremiseResponse
                vc.loanId = self.loanID
                vc.delegate = self
                vc.modalPresentationStyle = .formSheet
                self.present(vc, animated: true)
            }
//            else if self.selectedIndex == 4 {
//                let vc = DirectorDetailsViewController.initWithStory()
//                vc.selectedDirector = self.selectedDirectorsResponse.first
//                vc.customerId = self.customerData.id
//                vc.delegate = self
//                vc.modalPresentationStyle = .formSheet
//                self.present(vc, animated: true)
//            }
            else if self.selectedIndex == 4 {
                let vc = ConsentViewController.initWithStory(loanId: "")
                vc.selectedConsentResponse = self.selectedConsentResponse
                vc.loanId = self.loanID
                vc.delegate = self
                vc.modalPresentationStyle = .formSheet
                self.present(vc, animated: true)
            }
            else if self.selectedIndex == 5 {
                let vc = DocumentUploadViewController.initWithStory(loanId: "")
                vc.selectedDocumentsResponse = self.selectedDocumentsResponse
                vc.loanId = self.loanID
                vc.delegate = self
                vc.modalPresentationStyle = .formSheet
                self.present(vc, animated: true)
            }
            else if self.selectedIndex == 6 {
                let vc = GuarantorDetailsViewController.initWithStory(loanId: "")
                vc.selectedGuarantorResponse = self.selectedGuarantorResponse
                vc.loanId = self.loanID
                vc.delegate = self
                vc.modalPresentationStyle = .formSheet
                self.present(vc, animated: true)
            }
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
            var params = JSON()
            params["bank_name"] = self.step1TF.text
            params["institution_id"] = "SANDBOXFINANCE_SFIN0000"
            self.createRequisitionDetails(loanId:self.loanID,params: params)
//            var vc = WebViewController.initWithStory()
//            vc.strPageTitle = ""
//            vc.isToRedirect = true
//            vc.strWebUrl = self.requisitionData?.link ?? ""
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.fetchBankAccountsBtn.addTapGestureRecognizer {
            self.fetchBankAccountDetails()
        }
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
    //---------------------------------------
    // MARK: - Init With Story
    //---------------------------------------

    class func initWithStory(customerId: String, customerName: String, customerPhone: String, customerImage: String) -> LeadsDetailsVC {
        let vc : LeadsDetailsVC = UIStoryboard.Login.instantiateViewController()
        vc.customerId = customerId
        vc.customerName = customerName
        vc.customerPhone = customerPhone
        vc.customerImage = customerImage
        return vc
    }
//    class func initWithStory(customerId: String, customerName: String, customerPhone: String, customerImage: String,completePersonalDetail: Bool,completeBusinessDetail: Bool, completeBusinessPremisDetail: Bool, completeMarketingPreference: Bool, completeDocuments: Bool, completeGuarantors: Bool, directorDetail: Bool,identityVerified: Bool, gocardlessStatement: Bool) -> LeadsDetailsVC {
//          let vc : LeadsDetailsVC = UIStoryboard.Login.instantiateViewController()
//          vc.customerId = customerId
//          vc.customerName = customerName
//          vc.customerPhone = customerPhone
//          vc.customerImage = customerImage
//          vc.completePersonalDetail = completePersonalDetail
//          vc.completeBusinessDetail = completeBusinessDetail
//          vc.completeBusinessPremisDetail = completeBusinessPremisDetail
//          vc.completeMarketingPreference = completeMarketingPreference
//          vc.completeDocuments = completeDocuments
//          vc.completeGuarantors = completeGuarantors
//          vc.directorDetail = directorDetail
//          vc.identityVerified = identityVerified
//          vc.gocardlessStatement = gocardlessStatement
//
//          return vc
//      }
}
extension LeadsDetailsVC : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCollectionViewCell",
                                                      for: indexPath) as! ProfileCollectionViewCell
        cell.titleLabel.text = self.menuItems.value(atSafe: indexPath.row)
        cell.separatorLabel.isHidden = self.selectedIndex == indexPath.row ? false : true

        cell.addTapGestureRecognizer {
            self.selectedIndex = indexPath.row
            self.headersCollection.reloadData()
            self.detailsTable.reloadData()
           // self.editButton.isHidden = false
            var status = self.loanStatus.replacingOccurrences(of: "_", with: "")
            if self.loanStatus == "Inprogress" || self.loanStatus == "Submitted" ||  self.loanStatus == "Underwriter returned" {
                self.editButton.isHidden = false
            }else{
                self.editButton.isHidden = true
            }
            self.detailsTable.isHidden = false
            self.identityVerificationView.isHidden = true
            self.gocardlessView.isHidden = true
           // self.isAgreed = false
            self.agreementImage.image = self.isAgreed ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")

            switch self.selectedIndex {
            case 0:
                self.fetchPersonalDetails()
                break
//            case 1:
//                self.fetchAdditionalDetails(customerId: self.customerData.id)
//                break
            case 1:
                self.fetchBusinessDetails()
                break
            case 2:
                self.fetchPremiseDetails()
                
                break
            case 3:
                self.editButton.isHidden = true
                self.fetchDirectorDetails()
                break
            case 4:
                self.fetchConsentDetails()
                break
            case 5:
                self.fetchUploadedDocuments()
                break
            case 6:
                self.fetchGuarantorDetails()
                break
            case 7:
                self.editButton.isHidden = true

                self.detailsTable.isHidden = true
                self.identityVerificationView.isHidden = false
                self.identityVerificationSendBtn.isHidden = false
                self.identityVerificationResentBtn.isHidden = true
                self.fetchIdentityVerificationStatus()
                break
            case 8:
                self.editButton.isHidden = true
                self.agreementStack.isHidden = true
                self.agreementImage.image = self.isAgreed ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")

                self.detailsTable.isHidden = true
                self.gocardlessView.isHidden = false
                self.step1Stack.isHidden = true
                self.step2Stack.isHidden = true
                self.bankNumberStack.isHidden = true
                self.accountNumberStack.isHidden = true
                self.accountHolderStack.isHidden = true
                self.sortCodeStack.isHidden = true
                self.countryCodeStack.isHidden = true
                self.addBankAccountBtn.isHidden = true
                self.documentStack.isHidden = true
                if self.loanStatus.lowercased().contains("rejected") || self.loanStatus.lowercased().contains("inprogress") {
                    self.agreementStack.isHidden = false
                    self.bankNumberStack.isHidden = self.isAgreed
                    self.accountNumberStack.isHidden = self.isAgreed
                    self.accountHolderStack.isHidden = self.isAgreed
                    self.sortCodeStack.isHidden = self.isAgreed
                    self.countryCodeStack.isHidden = self.isAgreed
                    self.addBankAccountBtn.isHidden = self.isAgreed
                    self.documentStack.isHidden = self.isAgreed
                    self.step1Stack.isHidden = !self.isAgreed

                }
                self.fetchBankDetails()
              //  if !self.isAgreed {
                    self.fetchGocardlessManualStatementDetails()
               // }else{
                    self.fetchGocardlessStatementDetails()
              //  }
                break

            case 9:
                self.fetchContractDetails()
                break
        default:
                  break
            }
            
//                self.menuTable.isHidden = false
//                self.addressProofView.isHidden = true
//                self.securityView.isHidden = true
//                self.photoIDView.isHidden = true
//
//            case 1:
//                self.menuTable.isHidden = true
//                self.addressProofView.isHidden = true
//                self.securityView.isHidden = true
//                self.photoIDView.isHidden = false
//
//            case 2:
//                self.menuTable.isHidden = true
//                self.addressProofView.isHidden = false
//                self.securityView.isHidden = true
//                self.photoIDView.isHidden = true
//
//            case 3:
//                self.menuTable.isHidden = true
//                self.addressProofView.isHidden = true
//                self.securityView.isHidden = false
//                self.photoIDView.isHidden = true
//
//            default:
//                break
//            }
        }
        return cell
    }
}
extension LeadsDetailsVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.directorsTable || tableView == self.gocardlessTable {
            return 1
        }
        else{
            if self.selectedIndex == 2 {
                return 2
            }
            if self.selectedIndex == 5 {
                return self.sections.count
            }
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.directorsTable {
            return self.selectedIdentityVerificationResponse?.data.count ?? 0
        }
        else if tableView == self.gocardlessTable {
            return self.isAgreed ? self.selectedGocardlessStatement.count : self.selectedGocardlessManualStatement.count
        }
        else if tableView == self.accountsTable {
            return self.bankStatementArray.count
        }
        else {
            switch self.selectedIndex {
            case 0:
                return personalKVArray.count
                //        case 1:
                //            return self.additionalKVArray.count
            case 1:
                return self.businessKVArray.count
            case 2:
                return section == 0 ? self.registerKVArray.count : self.tradingKVArray.count
            case 3:
                return self.directorDictionary.count
            case 4:
                return 3
            case 5:
//                if section == 0 {
//                    return self.sections.count
//                }else if section == 1 && self.isStatementAvailable {
//                    return self.statementDocumentsKVArray.count
//                }else if section == 1 && self.isOtherAvailable {
//                    return self.otherDocumentsKVArray.count
//                }else if section == 2 && self.isOtherAvailable {
//                    return self.otherDocumentsKVArray.count
//                }else{
//                    return 0
//                }
                return self.sections.value(atSafe: section)?.items.count ?? 0
            case 6:
                return self.guarantorKVArray.count
            case 8:
                var count = 0
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
                return count
            case 9:
                return self.signedContractKVArray.count
            default:
                return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == detailsTable {
            
            if self.selectedIndex == 4 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "marketingTableViewCell", for: indexPath) as? MarketingTableViewCell else {
                    return UITableViewCell()
                }
                if indexPath.row == 0 {
                    cell.consentTitle.text = "I consent to receiving marketing information form Credit4Business Loans and its trading group of companies on products related to my current product by:"
                    let consent1 = self.selectedConsentResponse?.receivingMarketingInfo
                    cell.option1Image.image =  consent1?.email == true ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
                    cell.option2Image.image =  consent1?.post == true ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
                    cell.option3Image.image =  consent1?.sms == true ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
                    cell.option4Image.image =  consent1?.socialMedia == true ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
                    cell.option5Image.image =  consent1?.telephone == true ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
                }
                else if indexPath.row == 1 {
                    cell.consentTitle.text = "I consent to receiving marketing information form Credit4Business Loans and its trading group of companies on products related to my current product by:"
                    let consent1 = self.selectedConsentResponse?.sendingMarketingInformation
                    cell.option1Image.image =  consent1?.email == true ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
                    cell.option2Image.image =  consent1?.post == true ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
                    cell.option3Image.image =  consent1?.sms == true ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
                    cell.option4Image.image =  consent1?.socialMedia == true ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
                    cell.option5Image.image =  consent1?.telephone == true ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
                }else{
                        cell.consentTitle.text = "I consent to receiving marketing information form Credit4Business Loans and its trading group of companies on products related to my current product by:"
                    let consent1 = self.selectedConsentResponse?.thirdPartySharing
                        cell.option1Image.image =  consent1?.email == true ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
                        cell.option2Image.image =  consent1?.post == true ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
                        cell.option3Image.image =  consent1?.sms == true ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
                        cell.option4Image.image =  consent1?.socialMedia == true ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
                        cell.option5Image.image =  consent1?.telephone == true ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
                }
                return cell
            }
            if self.selectedIndex == 2 && self.registerKVArray.value(atSafe: indexPath.row)?.title == "Document" && indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "documentTableViewCell", for: indexPath) as? DocumentTableViewCell else {
                    return UITableViewCell()
                }
                cell.selectedFileView.isHidden = false
                cell.uploadView.isHidden = true
                cell.fileTypeLabel.text = "Documents"
                cell.selectedFileName.text = self.selectedPremiseResponse?.registeredAddress?.leasehold?.document
                var path = self.selectedPremiseResponse?.registeredAddress?.leasehold?.document
                if path != "" && path != nil {
                    let fileName = URL(fileURLWithPath: path ?? "").deletingPathExtension().lastPathComponent
                    cell.selectedFileName.text = fileName
                }
                cell.selectedViewButton.addTapGestureRecognizer {
                    var vc = WebViewController.initWithStory()
                    vc.strPageTitle = "Document"
                    vc.strWebUrl = self.selectedPremiseResponse?.registeredAddress?.leasehold?.document ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                return cell
            }
            if self.selectedIndex == 2 && self.tradingKVArray.value(atSafe: indexPath.row)?.title == "Document" && indexPath.section == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "documentTableViewCell", for: indexPath) as? DocumentTableViewCell else {
                    return UITableViewCell()
                }
                cell.selectedFileView.isHidden = false
                cell.uploadView.isHidden = true
                cell.fileTypeLabel.text = "Documents"
                cell.selectedFileName.text = self.selectedPremiseResponse?.tradingAddress?.leasehold?.document
                var path = self.selectedPremiseResponse?.tradingAddress?.leasehold?.document
                if path != "" && path != nil {
                    let fileName = URL(fileURLWithPath: path ?? "").deletingPathExtension().lastPathComponent
                    cell.selectedFileName.text = fileName
                }
                cell.selectedViewButton.addTapGestureRecognizer {
                    var vc = WebViewController.initWithStory()
                    vc.strPageTitle = "Document"
                    vc.strWebUrl = self.selectedPremiseResponse?.registeredAddress?.leasehold?.document ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                return cell
            }
//            if self.selectedIndex == 8 {
//
//            }
            if self.selectedIndex == 9 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "documentTableViewCell", for: indexPath) as? DocumentTableViewCell else {
                    return UITableViewCell()
                }
                cell.selectedFileView.isHidden = false
                cell.uploadView.isHidden = true
                var path = ""
                var model = self.signedContractKVArray.value(atSafe: indexPath.row)
                cell.fileTypeLabel.text = model?.title
                cell.selectedFileName.text = model?.value
               path = model?.value ?? ""
               if path != "" && path != nil {
                   let fileName = URL(fileURLWithPath: path ).deletingPathExtension().lastPathComponent
                   cell.selectedFileName.text = fileName
               }
                cell.selectedViewButton.addTapGestureRecognizer {
                    if path != "" {
                        self.downloadFileCompletionHandler(urlstring: path) {(destinationUrl, error) in
                                  if let url = destinationUrl {
                                      print(url)
                                  } else {
                                      print(error!)
                                  }
                                  
                              }
                    }else {
                        self.showAlert(title: "Info", message: "The selected document Url is not valid")
                    }

                    
                }
                return cell

            }
            if self.selectedIndex == 5 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "documentTableViewCell", for: indexPath) as? DocumentTableViewCell else {
                    return UITableViewCell()
                }
                cell.selectedFileView.isHidden = false
                cell.uploadView.isHidden = true
                var path = ""
                
//                if indexPath.section == 0 {
                    var model = self.sections.value(atSafe: indexPath.section)
                    cell.fileTypeLabel.text = model?.title
                    cell.selectedFileName.text = model?.items.value(atSafe: indexPath.row)
                   path = model?.items.value(atSafe: indexPath.row) ?? ""
                   if path != "" && path != nil {
                       let fileName = URL(fileURLWithPath: path ).deletingPathExtension().lastPathComponent
                       cell.selectedFileName.text = fileName
                   }
                cell.fileTypeLabel.isHidden = indexPath.row != 0

//                }
//                else if indexPath.section == 1 && self.isStatementAvailable {
//                    var model = self.statementDocumentsKVArray.value(atSafe: indexPath.row)
//                    cell.fileTypeLabel.text = model?.title
//                    cell.selectedFileName.text = model?.value
//                   path = model?.value ?? ""
//                   if path != "" && path != nil {
//                       let fileName = URL(fileURLWithPath: path ).deletingPathExtension().lastPathComponent
//                       cell.selectedFileName.text = fileName
//                   }
//                    cell.fileTypeLabel.isHidden = indexPath.row != 0
//                }
//                else if indexPath.section == 1 && self.isOtherAvailable {
//                    var model = self.otherDocumentsKVArray.value(atSafe: indexPath.row)
//                    cell.fileTypeLabel.text = model?.title
//                    cell.selectedFileName.text = model?.value
//                   path = model?.value ?? ""
//                   if path != "" && path != nil {
//                       let fileName = URL(fileURLWithPath: path ).deletingPathExtension().lastPathComponent
//                       cell.selectedFileName.text = fileName
//                   }
//                    cell.fileTypeLabel.isHidden = indexPath.row != 0
//
//                }
//                else if indexPath.section == 2 && self.isOtherAvailable {
//                    var model = self.otherDocumentsKVArray.value(atSafe: indexPath.row)
//                    cell.fileTypeLabel.text = model?.title
//                    cell.selectedFileName.text = model?.value
//                   path = model?.value ?? ""
//                   if path != "" && path != nil {
//                       let fileName = URL(fileURLWithPath: path ).deletingPathExtension().lastPathComponent
//                       cell.selectedFileName.text = fileName
//                   }
//                    cell.fileTypeLabel.isHidden = indexPath.row != 0
//
//                }
//                switch indexPath.row {
//                case 0:
//                    cell.fileTypeLabel.text = "Photo of owner in business premises"
//                    cell.selectedFileName.text = self.selectedDocumentsResponse?.photo
//                    path = self.selectedDocumentsResponse?.photo ?? ""
//                    if path != "" && path != nil {
//                        let fileName = URL(fileURLWithPath: path ).deletingPathExtension().lastPathComponent
//                        cell.selectedFileName.text = fileName
//                    }
//
//                case 1:
//                    cell.fileTypeLabel.text = "Passport/Driving License"
//                    cell.selectedFileName.text = self.selectedDocumentsResponse?.passport
//
//                     path = self.selectedDocumentsResponse?.passport ?? ""
//                    if path != "" && path != nil {
//                        let fileName = URL(fileURLWithPath: path ).deletingPathExtension().lastPathComponent
//                        cell.selectedFileName.text = fileName
//                    }
//                case 2:
//                    cell.fileTypeLabel.text = "Latest Utility bill of Trading Business"
//                    cell.selectedFileName.text = self.selectedDocumentsResponse?.utilityBillOfTradingBusiness
//                     path = self.selectedDocumentsResponse?.utilityBillOfTradingBusiness ?? ""
//                    if path != "" && path != nil {
//                        let fileName = URL(fileURLWithPath: path ).deletingPathExtension().lastPathComponent
//                        cell.selectedFileName.text = fileName
//                    }
//                case 3:
//                    cell.fileTypeLabel.text = "Business premises lease deed"
//                    cell.selectedFileName.text = self.selectedDocumentsResponse?.leaseDeed
//                     path = self.selectedDocumentsResponse?.leaseDeed ?? ""
//                    if path != "" && path != nil {
//                        let fileName = URL(fileURLWithPath: path ).deletingPathExtension().lastPathComponent
//                        cell.selectedFileName.text = fileName
//                    }
//                case 4:
//                    cell.fileTypeLabel.text = "Business account statement for 6 months"
//                    cell.selectedFileName.text = self.selectedDocumentsResponse?.businessAccountStatement?.first
//                    path = self.selectedDocumentsResponse?.businessAccountStatement?.first ?? ""
//                    if path != "" && path != nil {
//                        let fileName = URL(fileURLWithPath: path ).deletingPathExtension().lastPathComponent
//                        cell.selectedFileName.text = fileName
//                    }
//                case 5:
//                    cell.fileTypeLabel.text = "Other Files"
//                    cell.selectedFileName.text = self.selectedDocumentsResponse?.otherFiles?.first
//                    path = self.selectedDocumentsResponse?.otherFiles?.first ?? ""
//                    if path != "" && path != nil {
//                        let fileName = URL(fileURLWithPath: path ).deletingPathExtension().lastPathComponent
//                        cell.selectedFileName.text = fileName
//                    }
//                default: break
//                }
                cell.selectedViewButton.addTapGestureRecognizer {
                    if path != "" {
                        var vc = WebViewController.initWithStory()
                        vc.strPageTitle = "Document"
                        vc.strWebUrl = path
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else {
                        self.showAlert(title: "Info", message: "The selected document Url is not valid")
                    }
                    
                }
                return cell
            }
            if self.selectedIndex == 3 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "paymentHistoryCell", for: indexPath) as? PaymentHistoryCell else {
                    return UITableViewCell()
                }
                cell.isDirector = true
                cell.delegate = self

                guard let model = self.selectedDirectorsResponse.value(atSafe: indexPath.row) else {return UITableViewCell()}
                
                if model.isExtended ?? false {
                    cell.innerTable.isHidden = false
                    cell.innerTableHidden = false
                    cell.showHideTable()
                    
                }else{
                    cell.innerTable.isHidden = true
                    cell.innerTableHidden = true
                    cell.showHideTable()
                    
                }
                cell.directorModel = self.directorDictionary.value(atSafe: indexPath.row) ?? [MenuModel]()
                cell.imageLabel.text = "Activity"
                cell.titleLabel.text = model.firstName + model.lastName
                cell.subTitleLabel.text = "+44" + model.phoneNumber
                cell.imageActionView.addTapGestureRecognizer {
                    cell.innerTableHidden = !cell.innerTableHidden
                    guard var model = self.selectedDirectorsResponse.value(atSafe: indexPath.row) else {return}
                    model.isExtended = !(model.isExtended ?? false)
                    cell.showHideTable()
                    self.detailsTable.reloadData()
                }
                var status = self.loanStatus.replacingOccurrences(of: "_", with: "")
                if self.loanStatus == "Inprogress" || self.loanStatus == "Submitted" ||  self.loanStatus == "Underwriter returned" {
                    cell.editButton.isHidden = false
                }else{
                    cell.editButton.isHidden = true
                }
                cell.editButton.addTapGestureRecognizer {
                    let vc = DirectorDetailsViewController.initWithStory(loanId: "")
                    vc.selectedDirector = self.selectedDirectorsResponse.value(atSafe: indexPath.row)
                    vc.customerId = self.customerId
                    vc.loanId = self.loanID
                    vc.delegate = self
                    vc.modalPresentationStyle = .formSheet
                    self.present(vc, animated: true)
                }
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "leadsDetailsCell", for: indexPath) as? LeadsDetailsCell else {
                return UITableViewCell()
            }
            var array = [MenuModel]()
            switch self.selectedIndex {
            case 0:
                array = self.personalKVArray
//            case 1:
//                array = self.additionalKVArray
            case 1:
                array = self.businessKVArray
            case 2:
                array = indexPath.section == 0 ? self.registerKVArray : self.tradingKVArray
            case 6:
                array = self.guarantorKVArray
            default:
                break
            }
//            if self.selectedIndex == 0 && indexPath.row == self.personalKVArray.count {
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: "repaymentCelll", for: indexPath) as? RepaymentCelll else {
//                    return UITableViewCell()
//                }
//                guard let funding = self.selectedPersonalResponse?.fundRequestAmount, let weeks = self.selectedPersonalResponse?.fundRequestDurationWeeks, funding != "", weeks != 0 else{
//                    return UITableViewCell()
//                }
//                var merchant = 1.2
//                var cost = (Double(weeks) ?? 0.00) * merchant
//                var merchantPer = cost / 100
//                var multiply = (1 + merchantPer)
//                var repay = (Double(funding.toInt()) ) * multiply
//                var installment = repay/Double(weeks)
//                print(installment)
//                cell.repaymentTF.text = "£ \(repay.description.toInt())"
//                cell.weeklyInstallmentTF.text = "£ \(installment.description.toInt())"
//                return cell
//            }else{
                cell.titleLabel.text = array.value(atSafe: indexPath.row)?.title
                cell.valueLabel.text = array.value(atSafe: indexPath.row)?.value

                return cell

//            }
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
            }else{
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
        else if self.dropdownType == .step1 && tableView == step1Table {
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
                self.step2Stack.isHidden = false
                self.step1ErrStack.isHidden = true
                self.requisitionStack.isHidden = false
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
                self.confirmBankAccountDetails(loanId:self.loanID,params: params)
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
        else if tableView == self.directorsTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "kycStatusCell", for: indexPath) as? KYCStatusCell else {
                return UITableViewCell()
            }
            var model = self.selectedIdentityVerificationResponse?.data.value(atSafe: indexPath.row)
            cell.emailValueLabel.text = model?.customer.email
            cell.nameValueLabel.text = (model?.customer.firstName ?? "") + " " + (model?.customer.lastName ?? "")
            cell.phoneValueLabel.text = model?.customer.phoneNumber
            if model?.customer != nil {
                let attributedTitle = NSMutableAttributedString(string: model?.kycStatus == true ? "Completed" : "Inprogress", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0) ?? .boldSystemFont(ofSize: 10.0), NSAttributedString.Key.foregroundColor: UIColor(named: "green") ?? .green])

                    cell.kycStatusButton.setAttributedTitle(attributedTitle, for: .normal)
            }
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.center

            let title1 = NSMutableAttributedString(string: model?.documentVerification == "Passed" ? "Document Verification \n Passed" : "Document Verification \n \(model?.documentVerification ?? "")", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 11.0) ?? .boldSystemFont(ofSize: 12.0), NSAttributedString.Key.foregroundColor: model?.documentVerification == "Passed" ? UIColor(named: "green") ?? .green : UIColor(named: "yellow") ?? .green, NSAttributedString.Key.paragraphStyle: style ])

            cell.verificationStatus1.setAttributedTitle(title1, for: .normal)
            cell.verificationStatus1.backgroundColor = model?.documentVerification == "Passed" ? UIColor(named: "greenBackground") ?? .green : UIColor(named: "yellowBackground") ?? .green
            cell.verificationStatus1.isHidden = model?.documentVerification == ""
            
            let title2 = NSMutableAttributedString(string: model?.livenessCheck == "Live" ? "Liveness Check \n Live" : "Liveness Check \n \(model?.livenessCheck ?? "")", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 11.0) ?? .boldSystemFont(ofSize: 12.0), NSAttributedString.Key.foregroundColor: model?.livenessCheck == "Live" ? UIColor(named: "green") ?? .green : UIColor(named: "yellow") ?? .green, NSAttributedString.Key.paragraphStyle: style ])

            cell.verificationStatus2.setAttributedTitle(title2, for: .normal)
            cell.verificationStatus2.backgroundColor = model?.livenessCheck == "Live" ? UIColor(named: "greenBackground") ?? .green : UIColor(named: "yellowBackground") ?? .green
            cell.verificationStatus2.isHidden = model?.livenessCheck == ""
            
            let title3 = NSMutableAttributedString(string: model?.faceMatch == "Passed" ? "Face Match \n Passed" : "Face Match \n \(model?.faceMatch ?? "")", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 11.0) ?? .boldSystemFont(ofSize: 12.0), NSAttributedString.Key.foregroundColor: model?.faceMatch == "Passed" ? UIColor(named: "green") ?? .green : UIColor(named: "yellow") ?? .green, NSAttributedString.Key.paragraphStyle: style ])

            cell.verificationStatus3.setAttributedTitle(title3, for: .normal)
            cell.verificationStatus3.backgroundColor = model?.faceMatch == "Passed" ? UIColor(named: "greenBackground") ?? .green : UIColor(named: "yellowBackground") ?? .green
            cell.verificationStatus3.isHidden = model?.faceMatch == ""
            
            let title4 = NSMutableAttributedString(string: model?.kycAmlCheck == "Passed" ? "KYC/AML Check \n Passed" : "KYC/AML Check \n \(model?.kycAmlCheck ?? "")", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 11.0) ?? .boldSystemFont(ofSize: 12.0), NSAttributedString.Key.foregroundColor: model?.kycAmlCheck == "Passed" ? UIColor(named: "green") ?? .green : UIColor(named: "yellow") ?? .green, NSAttributedString.Key.paragraphStyle: style ])

            cell.verificationStatus4.setAttributedTitle(title4, for: .normal)
            cell.verificationStatus4.backgroundColor = model?.kycAmlCheck == "Passed" ? UIColor(named: "greenBackground") ?? .green : UIColor(named: "yellowBackground") ?? .green
            cell.verificationStatus4.isHidden = model?.kycAmlCheck == ""
            
            cell.viewCertificate.isHidden = model?.certificate == ""
            cell.viewCertificate.addTapGestureRecognizer {
                    var vc = WebViewController.initWithStory()
                    vc.strPageTitle = "Document"
                vc.strWebUrl = APIBaseUrl + (model?.certificate ?? "")
                    self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
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
        else if self.selectedIndex == 8 {
            return 50
        }
        else{
            return UITableView.automaticDimension
        }
    }
}
extension LeadsDetailsVC {
    private func downloadFileCompletionHandler(urlstring: String, completion: @escaping (URL?, Error?) -> Void) {

            let url = URL(string: urlstring)!
            let documentsUrl =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
            print(destinationUrl)

//        var urlAppend = urlstring + ".pdf"
//            let url = URL(string: urlAppend)!
//        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            let dataPath = documentsUrl.appendingPathComponent("Credit4Business2")
//        let destinationUrl = dataPath.appendingPathComponent("/" + "Sample.pdf")
        
            if FileManager().fileExists(atPath: destinationUrl.path) {
                print("File already exists [\(destinationUrl.path)]")
    //            try! FileManager().removeItem(at: destinationUrl)
                completion(destinationUrl, nil)
                return
            }

            let request = URLRequest(url: url)


            let task = URLSession.shared.downloadTask(with: request) { tempFileUrl, response, error in
    //            print(tempFileUrl, response, error)
                if error != nil {
                    completion(nil, error)
                    return
                }

                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        if let tempFileUrl = tempFileUrl {
                            print("download finished")
                            try? FileManager.default.moveItem(at: tempFileUrl, to: destinationUrl)
                            completion(destinationUrl, error)
                        } else {
                            completion(nil, error)
                        }

                    }
                }

            }
            task.resume()
        }
    func fetchIdentityVerificationStatus() {
        APIService.shared.retrieveIdentityVerificationStatus(loanId: self.loanID ) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedIdentityVerificationResponse = data
                        if self.selectedIdentityVerificationResponse?.data.first?.kycStatus == true {
//                            var params = JSON()
//                            params["identity_verified"] = "True"
//
//                            self.updateFilledForms(params: params)
                            self.identityVerificationFailView.isHidden = true
                            self.identityVerificationSuccessView.isHidden = false
                            self.directorsTable.isHidden = false
                            self.directorKycStatusLabel.isHidden = false
                            self.directorsTable.reloadData()
                        }
                        else if self.selectedIdentityVerificationResponse?.data.first?.kycStatus == false {
                            self.identityVerificationFailView.isHidden = true
                            self.identityVerificationSuccessView.isHidden = false
                            self.directorsTable.isHidden = false
                            self.directorKycStatusLabel.isHidden = false
                            self.directorsTable.reloadData()

                        }
                        else{
                            self.identityVerificationFailView.isHidden = false
                            self.identityVerificationSuccessView.isHidden = true
                            self.directorsTable.isHidden = true
                            self.directorKycStatusLabel.isHidden = true
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
    func createRemarks(json: JSON) {
        var url = APIEnums.retrieveRemarks.rawValue
        if self.loanID != "" {
            url = url + "\(self.loanID)/"
        }
        APIService.shared.makeRequest(endpoint: url,
                                      withLoader: true,
                                      method: .post,
                                      params: json) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    
                }
                else if data.statusCode == 401 {
                    
                }
                else {
//                    self.showAlert(title: "Info", message: data.statusMessage)
                }

            case .failure(let error):
                print(error)
//                self.showAlert(title: "Info", message: error.localizedDescription)
            }
        }
    }
    func fetchLoanDetails() {
        APIService.shared.retrieveLoanDetailsWithLoanID(loanId: self.loanID) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data
                        var model = responseData.data
                        let loanStatus = responseData.data.customer.loanDetails.filter({$0.loanID == responseData.data.id}).first?.currentStatus ?? ""
                        let upcomingStatus = responseData.data.customer.loanDetails.filter({$0.loanID == responseData.data.id}).first?.upcomingStatus ?? ""
                        if loanStatus != "" {
                            self.loanStatus = loanStatus
                            self.completePersonalDetail = model.completePersonalDetail ?? false
                            self.completeBusinessDetail = model.completeBusinessDetail ?? false
                            self.completeBusinessPremisDetail = model.completeBusinessPremisDetail ?? false
                            self.completeMarketingPreference = model.completeMarketingPreference ?? false
                            self.completeDocuments = model.completeDocuments ?? false
                            self.completeGuarantors = model.completeGuarantors ?? false
                            self.directorDetail = model.directorDetail ?? false
                            self.identityVerified = model.identityVerified ?? false
                            self.gocardlessStatement = model.gocardlessStatement ?? false
                        }
                        if upcomingStatus != "" {
                            self.loanUpcomingStatus = upcomingStatus
                        }
                        if ((self.loanStatus.lowercased() == "submitted" && self.loanUpcomingStatus.lowercased() == "agent_submission_waiting") || (self.loanStatus.lowercased() == "inprogress" && self.loanUpcomingStatus.lowercased() == "submission_waiting")) && self.completePersonalDetail && self.completeBusinessDetail && self.completeBusinessPremisDetail && self.directorDetail && self.identityVerified && self.gocardlessStatement{
                            self.submitLoanBtnView.isHidden = false
                        }
                        else {
                            self.submitLoanBtnView.isHidden = true
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
    func fetchCompanyDetails() {
        APIService.shared.retrieveCompanyDetails(loanId: self.loanID ) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                       
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
    func updateFilledForms(params: JSON){
        var url = APIEnums.updateFilledForms.rawValue
        if self.loanID != "" {
            url = url + "\(self.loanID)/"
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
        APIService.shared.makeRequest(endpoint: APIEnums.createIdentity.rawValue + "\(self.loanID)/",
                                      withLoader: true,
                                      method: .post,
                                      params: JSON()) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    var params = JSON()
                    params["identity_verified"] = "True"

                    self.updateFilledForms(params: params)
                    self.fetchIdentityVerificationStatus()
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
    func fetchPersonalDetails() {
        APIService.shared.retrievePersonalFormDetails(loanId: self.loanID ) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedPersonalResponse = responseData
                        self.createModelArrayForPersonal()
                        self.detailsTable.reloadData()
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
    func createModelArrayForPersonal() {
        self.personalKVArray.removeAll()
        let email = MenuModel.init(title: "Email", value: self.selectedPersonalResponse?.email ?? "", apiKey: "")
        let title = self.selectedPersonalResponse?.title ?? ""
        let fname = self.selectedPersonalResponse?.firstName ?? ""
        let lname = self.selectedPersonalResponse?.lastName ?? ""
        let fullname = fname + " " + lname

        let name = MenuModel.init(title: "Name", value: fullname, apiKey: "")
        let dob = MenuModel.init(title: "Is User 18+ ?", value: self.selectedPersonalResponse?.isMajor.description ?? "", apiKey: "")
        let pincode = MenuModel.init(title: "Postcode", value: self.selectedPersonalResponse?.pincode ?? "", apiKey: "")
        let address = MenuModel.init(title: "Address", value: self.selectedPersonalResponse?.address ?? "", apiKey: "")
        
        let phone = MenuModel.init(title: "Phone Number", value: self.selectedPersonalResponse?.phoneNumber ?? "", apiKey: "")
        let amount = MenuModel.init(title: "Amount you Need", value: self.selectedPersonalResponse?.fundRequestAmount ?? "", apiKey: "")
        let duration = MenuModel.init(title: "Duration (In weeks)", value: self.selectedPersonalResponse?.fundRequestDurationWeeks.description ?? "", apiKey: "")
        let day = MenuModel.init(title: "Repayment Day of Week", value: self.selectedPersonalResponse?.repaymentDayOfWeek.description ?? "", apiKey: "")
        self.personalKVArray.append(email)
        self.personalKVArray.append(name)
        self.personalKVArray.append(dob)
        self.personalKVArray.append(pincode)
        self.personalKVArray.append(address)
        self.personalKVArray.append(phone)
        self.personalKVArray.append(amount)
        self.personalKVArray.append(duration)
        self.personalKVArray.append(day)
        let companyName = MenuModel.init(title: "Company Name", value: self.selectedPersonalResponse?.company.companyName ?? "", apiKey: "")
      
        let businessType = MenuModel.init(title: "Business Type", value: self.selectedPersonalResponse?.company.businessType ?? "", apiKey: "")
        let tradingStyle = MenuModel.init(title: "Business / Shop Name", value: self.selectedPersonalResponse?.company.tradingStyle ?? "", apiKey: "")
        let companyNumber = MenuModel.init(title: "Company Number", value: self.selectedPersonalResponse?.company.companyNumber ?? "", apiKey: "")
        
        let fundingPurpose = MenuModel.init(title: "Funding Purpose", value: self.selectedPersonalResponse?.company.fundingPurpose ?? "", apiKey: "")
        if let other = self.selectedPersonalResponse?.company.otherFundingPurpose, other != ""{
            fundingPurpose.value = other
        }
        let modeOfApplication = MenuModel.init(title: "Mode Of Application", value: self.selectedPersonalResponse?.modeOfApplication ?? "", apiKey: "")
        self.personalKVArray.append(companyName)
        self.personalKVArray.append(businessType)
        self.personalKVArray.append(tradingStyle)
        self.personalKVArray.append(companyNumber)
        self.personalKVArray.append(fundingPurpose)
        self.personalKVArray.append(modeOfApplication)

        if let representative = self.selectedPersonalResponse?.representatives{
            let representativeObj = MenuModel.init(title: "Representative", value: self.selectedPersonalResponse?.representatives ?? "", apiKey: "")
            self.personalKVArray.append(representativeObj)
        }

    }
    func fetchAdditionalDetails(customerId: String) {
        APIService.shared.retrieveAdditionalDetailsFromAgent(customerId: customerId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedAdditionalResponse = responseData
                        self.createModelArrayForAdditional()
                        self.detailsTable.reloadData()
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
    func createModelArrayForAdditional() {
        self.additionalKVArray.removeAll()
        let companyName = MenuModel.init(title: "Company Name", value: self.selectedAdditionalResponse?.companyName ?? "", apiKey: "")
      
        let businessType = MenuModel.init(title: "Business Type", value: self.selectedAdditionalResponse?.businessType ?? "", apiKey: "")
        let tradingStyle = MenuModel.init(title: "Business / Shop Name", value: self.selectedAdditionalResponse?.tradingStyle ?? "", apiKey: "")
        let companyNumber = MenuModel.init(title: "Company Number", value: self.selectedAdditionalResponse?.companyNumber ?? "", apiKey: "")
        
        let fundingPurpose = MenuModel.init(title: "Funding Purpose", value: self.selectedAdditionalResponse?.fundingPurpose ?? "", apiKey: "")
        if let other = self.selectedAdditionalResponse?.otherFundingPurpose, other != ""{
            fundingPurpose.value = other
        }
        let modeOfApplication = MenuModel.init(title: "Mode Of Application", value: self.selectedAdditionalResponse?.modeOfApplication ?? "", apiKey: "")
        self.additionalKVArray.append(companyName)
        self.additionalKVArray.append(businessType)
        self.additionalKVArray.append(tradingStyle)
        self.additionalKVArray.append(companyNumber)
        self.additionalKVArray.append(fundingPurpose)
        self.additionalKVArray.append(modeOfApplication)

        if let representative = self.selectedAdditionalResponse?.representatives{
            let representativeObj = MenuModel.init(title: "Representative", value: self.selectedAdditionalResponse?.representatives ?? "", apiKey: "")
            self.additionalKVArray.append(representativeObj)
        }
    }
    func fetchBusinessDetails() {
        APIService.shared.retrieveBusinessFormDetails(loanId: self.loanID) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedBusinessResponse = responseData
                        self.createModelArrayForBusiness()
                        self.detailsTable.reloadData()
                    }
                    catch {
                        
                    }
                }
                else {
                   // self.showAlert(title: "Info", message: data.statusMessage)
                }
            case .failure(let error):
                //self.showAlert(title: "Info", message: error.localizedDescription)
                print(error)
            }
        }
    }
    func createModelArrayForBusiness() {
        self.businessKVArray.removeAll()
        let businessType = MenuModel.init(title: "Business Type", value: self.selectedBusinessResponse?.businessType ?? "", apiKey: "")

        let numberOfDirectors = MenuModel.init(title: "Number Of Directors", value: self.selectedBusinessResponse?.numberOfDirectors.description ?? "", apiKey: "")
      
        let startTradingDate = MenuModel.init(title: "When did your business start trading", value: self.selectedBusinessResponse?.startTradingDate ?? "", apiKey: "")
        
        let isProfitable = MenuModel.init(title: "In the last 12 months has your business been profitable?", value: self.selectedBusinessResponse?.isProfitable ?? "", apiKey: "")
        let acceptsCardPayment = MenuModel.init(title: "Does your business accept card payment?", value: self.selectedBusinessResponse?.acceptsCardPayment ?? "", apiKey: "")
       
        let averageMonthlyTurnover = MenuModel.init(title: "Average Monthly Turnover", value: self.selectedBusinessResponse?.averageMonthlyTurnover ?? "", apiKey: "")

        let businessSector = MenuModel.init(title: "Business Sector", value: self.selectedBusinessResponse?.businessSector ?? "", apiKey: "")

        if let other = self.selectedBusinessResponse?.otherBusinessName, other != ""{
            businessSector.value = other
        }
        self.businessKVArray.append(businessType)
        self.businessKVArray.append(numberOfDirectors)
        self.businessKVArray.append(startTradingDate)
        self.businessKVArray.append(isProfitable)
        self.businessKVArray.append(acceptsCardPayment)
        self.businessKVArray.append(averageMonthlyTurnover)
        if let cardSales = self.selectedBusinessResponse?.averageWeeklyCardSales, cardSales != ""{
            let averageWeeklyCardSales = MenuModel.init(title: "Average Weekly Card Sales", value: cardSales, apiKey: "")
            self.businessKVArray.append(averageWeeklyCardSales)
        }
        self.businessKVArray.append(businessSector)
        
    }
    func fetchConsentDetails() {
        APIService.shared.retrieveConsentFormDetails(loanId: self.loanID) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedConsentResponse = responseData
                        self.detailsTable.reloadData()
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
    func fetchUploadedDocuments() {
        APIService.shared.retrieveDocumentsFormDetails(loanId: self.loanID) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedDocumentsResponse = responseData
                       // self.isStatementAvailable = false
                        //self.isOtherAvailable = false
                        self.createModelArrayForUploadedDocumnets()
                        self.detailsTable.reloadData()
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
    func fetchContractDetails() {
        APIService.shared.retrieveContractDetails(loanId: self.loanID) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedSignedContractResponse = responseData
                        self.createModelArrayForSignedContract()
                        self.detailsTable.reloadData()
                      
                    }
                    catch {
                        
                    }
                   // self.documentTable.reloadData()
                }
                else {
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func createModelArrayForSignedContract() {
        self.signedContractKVArray.removeAll()
        if self.selectedSignedContractResponse?.signedPDF != "" {
            let photo = MenuModel.init(title: "CASH ADVANCE AGREEMENT", value: self.selectedSignedContractResponse?.signedPDF ?? "", apiKey: "")
            self.signedContractKVArray.append(photo)
        }
    }
    struct SectionData {
        let title: String
        let items: [String] // Or your custom data type for rows
    }
    func createModelArrayForUploadedDocumnets() {
        self.photoArray.removeAll()
        self.passportArray.removeAll()
        self.licenseArray.removeAll()
        self.leaseArray.removeAll()
        self.councilArray.removeAll()
        self.utilityArray.removeAll()
        self.otherDocumentsKVArray.removeAll()
        self.statementDocumentsKVArray.removeAll()
        self.sections.removeAll()
        
        if self.selectedDocumentsResponse?.photo?.count ?? 0 != 0 {
            for item in self.selectedDocumentsResponse?.photo ?? [MultipleDocumentsDataClass]() {
                let photo = MenuModel.init(title: "Photo of owner in business premises", value: item.file, apiKey: "")
                self.photoArray.append(photo)
            }
            
        }
        if self.selectedDocumentsResponse?.passport?.count ?? 0 != 0 {
            for item in self.selectedDocumentsResponse?.passport ?? [MultipleDocumentsDataClass]() {
                let photo = MenuModel.init(title: "Passport", value: item.file, apiKey: "")
                self.passportArray.append(photo)
            }
            
        }
        if self.selectedDocumentsResponse?.drivingLicense?.count ?? 0 != 0 {
            for item in self.selectedDocumentsResponse?.drivingLicense ?? [MultipleDocumentsDataClass]() {
                let photo = MenuModel.init(title: "Driving License", value: item.file, apiKey: "")
                self.licenseArray.append(photo)
            }
            
        }
        if self.selectedDocumentsResponse?.councilTax?.count ?? 0 != 0 {
            for item in self.selectedDocumentsResponse?.councilTax ?? [MultipleDocumentsDataClass]() {
                let photo = MenuModel.init(title: "Council Tax", value: item.file, apiKey: "")
                self.councilArray.append(photo)
            }
            
        }
        if self.selectedDocumentsResponse?.utilityBillOfTradingBusiness?.count ?? 0 != 0 {
            for item in self.selectedDocumentsResponse?.utilityBillOfTradingBusiness ?? [MultipleDocumentsDataClass]() {
                let photo = MenuModel.init(title: "Latest Utility bill of Trading Business", value: item.file, apiKey: "")
                self.utilityArray.append(photo)
            }
            
        }
        if self.selectedDocumentsResponse?.leaseDeed?.count ?? 0 != 0 {
            for item in self.selectedDocumentsResponse?.leaseDeed ?? [MultipleDocumentsDataClass]() {
                let photo = MenuModel.init(title: "Business premises lease deed", value: item.file, apiKey: "")
                self.leaseArray.append(photo)
            }
            
        }
        if self.photoArray.count != 0 {
            sections.append(SectionData(title: "Photo of owner in business premises", items: self.photoArray.map({$0.value})))
        }
        if self.passportArray.count != 0 {
            sections.append(SectionData(title: "Passport", items: self.passportArray.map({$0.value})))
        }
        if self.licenseArray.count != 0 {
            sections.append(SectionData(title: "Driving License", items: self.licenseArray.map({$0.value})))
        }
        if self.councilArray.count != 0 {
            sections.append(SectionData(title: "Council Tax", items: self.councilArray.map({$0.value})))
        }
        if self.utilityArray.count != 0 {
            sections.append(SectionData(title: "Latest Utility bill of Trading Business", items: self.utilityArray.map({$0.value})))
        }
        if self.leaseArray.count != 0 {
            sections.append(SectionData(title: "Business premises lease deed", items: self.leaseArray.map({$0.value})))
        }
        
//        if self.selectedDocumentsResponse?.photo != "" {
//            let photo = MenuModel.init(title: "Photo of owner in business premises", value: self.selectedDocumentsResponse?.photo ?? "", apiKey: "")
//            self.documentsKVArray.append(photo)
//        }
//        if self.selectedDocumentsResponse?.passport != "" {
//            let photo = MenuModel.init(title: "Passport", value: self.selectedDocumentsResponse?.passport ?? "", apiKey: "")
//            self.documentsKVArray.append(photo)
//        }
//        if self.selectedDocumentsResponse?.drivingLicense != "" {
//            let photo = MenuModel.init(title: "Driving License", value: self.selectedDocumentsResponse?.drivingLicense ?? "", apiKey: "")
//            self.documentsKVArray.append(photo)
//        }
//        if self.selectedDocumentsResponse?.councilTax != "" {
//            let photo = MenuModel.init(title: "Council Tax", value: self.selectedDocumentsResponse?.councilTax ?? "", apiKey: "")
//            self.documentsKVArray.append(photo)
//        }
//        if self.selectedDocumentsResponse?.utilityBillOfTradingBusiness != "" {
//            let photo = MenuModel.init(title: "Latest Utility bill of Trading Business", value: self.selectedDocumentsResponse?.utilityBillOfTradingBusiness ?? "", apiKey: "")
//            self.documentsKVArray.append(photo)
//        }
//        if self.selectedDocumentsResponse?.leaseDeed != "" {
//            let photo = MenuModel.init(title: "Business premises lease deed", value: self.selectedDocumentsResponse?.leaseDeed ?? "", apiKey: "")
//            self.documentsKVArray.append(photo)
//        }
        if self.selectedDocumentsResponse?.businessAccountStatement?.count ?? 0 != 0 {
            for item in self.selectedDocumentsResponse?.businessAccountStatement ?? [MultipleDocumentsDataClass]() {
                let photo = MenuModel.init(title: "Business account statement for 6 months", value: item.file, apiKey: "")
                self.statementDocumentsKVArray.append(photo)
               // self.isStatementAvailable = true
            }
            
        }
        if self.selectedDocumentsResponse?.otherFiles?.count ?? 0 != 0 {
            for item in self.selectedDocumentsResponse?.otherFiles ?? [MultipleDocumentsDataClass]() {
                let photo = MenuModel.init(title: "Other Files", value: item.file, apiKey: "")
                self.otherDocumentsKVArray.append(photo)
                    // self.isOtherAvailable = true
            }
            
        }
        if self.statementDocumentsKVArray.count != 0 {
            sections.append(SectionData(title: "Business account statement for 6 months", items: self.statementDocumentsKVArray.map({$0.value})))
        }
        if self.otherDocumentsKVArray.count != 0 {
            sections.append(SectionData(title: "Other Files", items: self.otherDocumentsKVArray.map({$0.value})))
        }
    }
    func fetchPremiseDetails() {
        APIService.shared.retrievePremiseFormDetails(loanId: self.loanID) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedPremiseResponse = responseData
                        self.createModelArrayForPremises()
                        self.detailsTable.reloadData()
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
    func createModelArrayForPremises() {
        self.registerKVArray.removeAll()
        let address = MenuModel.init(title: "Registered Address", value: self.selectedPremiseResponse?.registeredAddress?.addressLine1 ?? "", apiKey: "")

        let postcode = MenuModel.init(title: "Registered Post code", value: self.selectedPremiseResponse?.registeredAddress?.postCode ?? "", apiKey: "")
      
        let premiseType = MenuModel.init(title: "Registered Premise Type", value: self.selectedPremiseResponse?.registeredAddress?.premiseType ?? "", apiKey: "")
        var start = self.selectedPremiseResponse?.registeredAddress?.leasehold?.startDate ?? ""
        var end = self.selectedPremiseResponse?.registeredAddress?.leasehold?.endDate ?? ""
        var period = start + " - " +  end
        let timePeriod = MenuModel.init(title: "Registered Lease Time period", value: period, apiKey: "")
        let document = MenuModel.init(title: "Registered Document", value: self.selectedPremiseResponse?.registeredAddress?.leasehold?.document ?? "", apiKey: "")
       
        self.registerKVArray.append(address)
        self.registerKVArray.append(postcode)
        self.registerKVArray.append(premiseType)
        if start != "" && end != "" {
            self.registerKVArray.append(timePeriod)
        }
        if document.value != "" {
            self.registerKVArray.append(document)
        }
        self.tradingKVArray.removeAll()

//        if self.selectedPremiseResponse?.tradingSameAsRegistered ?? false{
//            self.tradingKVArray = self.registerKVArray
//        }else{
            let address1 = MenuModel.init(title: "Trading Address", value: self.selectedPremiseResponse?.tradingAddress?.addressLine1 ?? "", apiKey: "")

            let postcode1 = MenuModel.init(title: "Trading Post code", value: self.selectedPremiseResponse?.tradingAddress?.postCode ?? "", apiKey: "")
          
            let premiseType1 = MenuModel.init(title: "Trading Premise Type", value: self.selectedPremiseResponse?.tradingAddress?.premiseType ?? "", apiKey: "")
            var start1 = self.selectedPremiseResponse?.tradingAddress?.leasehold?.startDate ?? ""
            var end1 = self.selectedPremiseResponse?.tradingAddress?.leasehold?.endDate ?? ""
            var period1 = start1 + " - " +  end1
            let timePeriod1 = MenuModel.init(title: "Trading Lease Time period", value: period1, apiKey: "")
            let document1 = MenuModel.init(title: "Trading Document", value: self.selectedPremiseResponse?.tradingAddress?.leasehold?.document ?? "", apiKey: "")
           
            self.tradingKVArray.append(address1)
            self.tradingKVArray.append(postcode1)
            self.tradingKVArray.append(premiseType1)
            if start1 != "" && end1 != "" {
                self.tradingKVArray.append(timePeriod1)
            }
            if document1.value != "" {
                self.tradingKVArray.append(document1)
            }
        //}
        
    }
    func fetchDirectorDetails() {
        APIService.shared.retrieveDirectorsFormDetails(loanId: self.loanID) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedDirectorsResponse = responseData.directors
                        self.createModelArrayForDirectors()
                        self.detailsTable.reloadData()
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
    func createModelArrayForDirectors() {
        self.directorDictionary.removeAll()
        for item in self.selectedDirectorsResponse {
            var array = [MenuModel]()
            
            
            for (index,stay) in item.stay.enumerated() {
                let pincode = MenuModel.init(title: "Stay Postcode \(index + 1)", value: stay.pincode, apiKey: "")
                let address = MenuModel.init(title: "Stay Address \(index + 1)", value: stay.address, apiKey: "")
                let house = MenuModel.init(title: "Stay House Ownership \(index + 1)", value: stay.houseOwnership, apiKey: "")
                let duration = MenuModel.init(title: "Stay Duration \(index + 1)", value: stay.startDate + " - " + stay.endDate, apiKey: "")
                array.append(pincode)
                array.append(address)
                array.append(house)
                array.append(duration)
            }
            if item.ownsOtherProperty == "Yes" && item.ownedPropertyCount != 0 {
                for (index,element) in item.ownedProperty.enumerated() {
                    let address = MenuModel.init(title: "Property Address \(index + 1)", value: element.address, apiKey: "")
                    array.append(address)
                }
            }
            self.directorDictionary.append(array)
        }
       
    }
    func fetchGuarantorDetails() {
        APIService.shared.retrieveGuarantorFormDetails(loanId: self.loanID) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedGuarantorResponse = responseData
                        self.createModelArrayForGuarantor()
                        self.detailsTable.reloadData()
//                        self.showModelValues()
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
    func createModelArrayForGuarantor() {
        self.guarantorKVArray.removeAll()
        var title = self.selectedGuarantorResponse?.title ?? ""
        var fname = self.selectedGuarantorResponse?.firstName ?? ""
        var lname = self.selectedGuarantorResponse?.lastName ?? ""
        var fullName = title + " " + fname + " " + lname
        let name = MenuModel.init(title: "Name", value: fullName, apiKey: "")
      
        let phone = MenuModel.init(title: "Phone Number", value: self.selectedGuarantorResponse?.phoneNumber.description ?? "", apiKey: "")
        let email = MenuModel.init(title: "Email", value: self.selectedGuarantorResponse?.email ?? "", apiKey: "")
     //   let address = MenuModel.init(title: "Address", value: self.selectedGuarantorResponse?.address ?? "", apiKey: "")
        
        self.guarantorKVArray.append(name)
        self.guarantorKVArray.append(phone)
        self.guarantorKVArray.append(email)
        //self.guarantorKVArray.append(address)
        guard let res = self.selectedGuarantorResponse else { return }
            for (index,stay) in res.stay.enumerated() {
                let pincode = MenuModel.init(title: "Stay Postcode \(index + 1)", value: stay.pincode, apiKey: "")
                let address = MenuModel.init(title: "Stay Address \(index + 1)", value: stay.address, apiKey: "")
                let house = MenuModel.init(title: "Stay House Ownership \(index + 1)", value: stay.houseOwnership, apiKey: "")
                let duration = MenuModel.init(title: "Stay Duration \(index + 1)", value: stay.startDate + " - " + stay.endDate, apiKey: "")
                self.guarantorKVArray.append(pincode)
                self.guarantorKVArray.append(address)
                self.guarantorKVArray.append(house)
                self.guarantorKVArray.append(duration)
            }
            if res.ownsOtherProperty == "Yes" && res.ownedPropertyCount != 0 {
                for (index,element) in res.ownedProperty.enumerated() {
                    let address = MenuModel.init(title: "Property Address \(index + 1)", value: element.address, apiKey: "")
                    self.guarantorKVArray.append(address)
                }
            }
        
        
    }
    func fetchBankDetails() {
        APIService.shared.retrieveBankDetails(loanId: self.loanID) { result in
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
                        self.bankTable.reloadData()
                        self.step1Table.reloadData()
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
        APIService.shared.retrieveGocardlessStatementDetails(loanId: self.loanID) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data
                        self.selectedGocardlessStatement = responseData.data.filter({$0.gocardlessStatus == true})
                        self.gocardlessTable.isHidden = true
                        self.gocardlessStatusView.isHidden = true
                        if self.selectedGocardlessStatement.count != 0 {
                            self.showSubmit()
                        }
                        for item in self.selectedGocardlessStatement {
                            self.gocardlessTable.isHidden = false
                            self.gocardlessStatusView.isHidden = true
                            self.gocardlessTable.reloadData()

                            //return
                        }
                        if self.isAgreed && (self.loanStatus.lowercased().contains("rejected") || self.loanStatus.lowercased().contains("inprogress")) {
                            self.step1Stack.isHidden = false
                            self.fetchBankDetails()
                            //                            self.dropdownType = .step1
//                            self.showHideTable()
                        }
                    }
                    catch {
                        
                    }
                }
                else {
                    self.gocardlessStatusView.isHidden = false
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func fetchGocardlessManualStatementDetails() {
        APIService.shared.retrieveGocardlessManualStatementDetails(loanId: self.loanID) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data
                        self.selectedGocardlessManualStatement = responseData.data.bankDetails
                        self.gocardlessTable.isHidden = true
                        self.gocardlessStatusView.isHidden = true
                        if self.selectedGocardlessManualStatement.count != 0 {
                            self.showSubmit()
                        }
                        for item in self.selectedGocardlessManualStatement {
                            self.gocardlessTable.isHidden = false
                            self.gocardlessStatusView.isHidden = true
                            self.step1TF.text = self.selectedGocardlessManualStatement.first?.bankName ?? ""
                            self.requisitionLink = self.selectedGocardlessManualStatement.first?.requisitionLink ?? ""
                            if self.requisitionLink != ""
                            {
                                let attributedTitle = NSMutableAttributedString(string: "Re-Generate Link", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 11.0), NSAttributedString.Key.foregroundColor: UIColor(named: "blue"),NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])

                                self.generateRegenerateBtn.setAttributedTitle(attributedTitle, for: .normal)

                            }
                            if self.requisitionLink != "" && self.isAgreed && !self.step1Stack.isHidden {
                                let attributedTitle = NSMutableAttributedString(string: "Completed", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: "yellow")])

                                self.step1StatusButton.setAttributedTitle(attributedTitle, for: .normal)

                                self.step2Stack.isHidden = false
                                self.requisitionStack.isHidden = false
                                self.step3Stack.isHidden = true
                                self.step2DropDown.isHidden = true

                            }

                            self.gocardlessTable.reloadData()

                            //return
                        }
                        if self.isAgreed && (self.loanStatus.lowercased().contains("rejected") || self.loanStatus.lowercased().contains("inprogress")) {
                            //self.step1Stack.isHidden = false
                            self.bankNumberStack.isHidden = self.isAgreed
                            self.accountNumberStack.isHidden = self.isAgreed
                            self.accountHolderStack.isHidden = self.isAgreed
                            self.sortCodeStack.isHidden = self.isAgreed
                            self.countryCodeStack.isHidden = self.isAgreed
                            self.addBankAccountBtn.isHidden = self.isAgreed
                            self.documentStack.isHidden = self.isAgreed
                            self.fetchBankDetails()
                            //                            self.dropdownType = .step1
//                            self.showHideTable()
                        }
                    }
                    catch {
                        
                    }
                }
                else {
                    self.gocardlessStatusView.isHidden = false
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func createDocumentDetails(paramDict: JSON,dataArray: [String: Any]) {
        var url = APIEnums.createManualBank.rawValue + self.loanID + "/"
       
        ConnectionHandler().uploadDocuments(wsMethod: url, paramDict: paramDict, dataArray: dataArray, viewController: self, isToShowProgress: true, isToStopInteraction: true) { response in
            if response.status_code == 200 {
                var params = JSON()
                params["gocardless_statement"] = "True"
                self.updateFilledForms(params: params)
                self.showAlert(title: "Info", message: response.status_message)
                self.loanUpcomingStatus = "submission_waiting"
                self.fetchGocardlessManualStatementDetails()
            }
            else {
                self.showAlert(title: "Info", message: response.status_message)
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
    func fetchBankAccountDetails() {
        APIService.shared.retrieveBankAccountDetails(loanId: self.loanID) { result in
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
                    self.showAlert(title: "Info", message: data.statusMessage)
                    self.step2Stack.isHidden = (self.step1Stack.isHidden ? true : false)
                    let attributedTitle = NSMutableAttributedString(string: "Completed", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: "yellow")])

                    self.step1StatusButton.setAttributedTitle(attributedTitle, for: .normal)

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
    func confirmBankAccountDetails(loanId: String,params: JSON) {
        var url = APIEnums.retrieveBankAccounts.rawValue + "\(loanId)/"
        
        APIService.shared.makeRequest(endpoint: url,
                                      withLoader: true,
                                      method: .post,
                                      params: params) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    var params = JSON()
                    params["gocardless_statement"] = "True"
                    self.updateFilledForms(params: params)
                    let attributedTitle = NSMutableAttributedString(string: "Completed", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: "yellow")])

                    self.step2StatusButton.setAttributedTitle(attributedTitle, for: .normal)
                    self.fetchGocardlessStatementDetails()
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
}
extension LeadsDetailsVC{
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
//MARK: -------------------------- Observers Methods --------------------------
extension LeadsDetailsVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.detailsTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.detailTableHeight.constant = newvalue.height
        }
        if let obj = object as? UITableView, obj == self.directorsTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.directorsTableHeight.constant = newvalue.height
        }
        if let obj = object as? UITableView, obj == self.gocardlessTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.gocardlessTableHeight.constant = newvalue.height
        }
        if let obj = object as? UITableView, obj == self.accountsTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.accountTableHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
      //  self.detailsTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.directorsTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.gocardlessTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.accountsTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.detailsTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        guard let tblView2 = self.directorsTable else {return}
        if let _ = tblView2.observationInfo {
            tblView2.removeObserver(self, forKeyPath: "contentSize")
        }
        guard let tblView3 = self.gocardlessTable else {return}
        if let _ = tblView3.observationInfo {
            tblView3.removeObserver(self, forKeyPath: "contentSize")
        }
        guard let tblView5 = self.accountsTable else {return}
        if let _ = tblView5.observationInfo {
            tblView5.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
extension LeadsDetailsVC : UIDocumentPickerDelegate {
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
extension LeadsDetailsVC : UITextFieldDelegate {

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
