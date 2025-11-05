//
//  ProfileDetailsVC.swift
//  Credit4Business
//
//  Created by MacMini on 04/09/24.
//

import UIKit
import Photos
import MobileCoreServices
import UniformTypeIdentifiers
import IQKeyboardManagerSwift

class ProfileDetailsVC: UIViewController, CellDelegate {
    func reload() {
        self.detailsTable.reloadData()
    }
    
    func particularReloadOf() {
        self.detailsTable.reloadData()

    }
    
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var detailsTable: UITableView!
    @IBOutlet weak var detailTableHeight: NSLayoutConstraint!
    @IBOutlet weak var leadsImage: UIImageView!
    @IBOutlet weak var loanStatusButton: UIButton!
    @IBOutlet weak var leadName: UILabel!
    @IBOutlet weak var leadsNameHeader: UILabel!
    @IBOutlet weak var headersCollection: UICollectionView!
    
    @IBOutlet weak var gotoApplicationBtn: UIButton!
    @IBOutlet weak var detailsView: UIView!
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
    @IBOutlet weak var agreementStack: UIStackView!
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

    //MARK: -------------------- Class Variable --------------------
    var loanData : LoanData?
    var loanDetailsIndex = 0
    var viewModel = HomeVM()
    var companyKVArray = [MenuModel]()
    var loanKVArray = [MenuModel]()
//    var menuItems = ["Unit Profile", "Contract Details","History","Photo ID","Address Proof","Other Files", "Bank Statements","GoCardless", "Funding Offer"]
//    var menuItems = ["Funding","Unit Profile","Contract Details","History","GoCardless", "Funding Offer"]
    var menuItems = ["Funding","Unit Profile","History","GoCardless", "Funding Offer"]
    var selectedIndex = 0
    var selectedIndexText = "Funding"
    var selectedDocumentIndex = 0
    var selectedPhotoIdResponse : PhotoIDDataClass?
    var selectedAddressProofResponse : AddressProofDataClass?
    var selectedOtherResponse : OtherData?
    var selectedBankStatementResponse : BankStatementData?
    var customerModel = [CustomerData]()
    var customerObject : CustomerModel?
    var searchList = [CustomerData]()
    var loanModel : LoanModel?
    var currentTripPageIndex = 1{
        didSet {
            print(currentTripPageIndex.description)
        }
    }
    var totalTripPages = 1{
        didSet {
            print(totalTripPages.description)
        }
    }
    var HittedTripPageIndex = 0
    var oneTimeForHistory : Bool = true
    var paymentArray = [FundingPayment]()
    var historyArray = [FundingPaymentHistory]()
    var step1TableHidden = true
    var step2TableHidden = true
    var selectedStep1 : BankData?
    var selectedStep2 : String?
    var dropdownType : DropDownType = .none
    var fundingOfferArray = [FundingOfferData]()
    var bankArray = [BankData]()
    var bankAccountArray = [Account]()
    var requisitionData : RequisitionClass?
    var selectedGocardlessStatement = [GocardlessData]()
    var loanId = ""
    var statementModel: StatementDataClass?
    var requisitionLink = ""
    @IBOutlet weak var generateRegenerateBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        var model = self.loanData
        let status = model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.currentStatus ?? ""
        if status == "Admin_Cash_Disbursed" {
            self.menuItems.removeAll()
            self.menuItems.append("Funding")
            self.menuItems.append("Unit Profile")
            self.menuItems.append("Contract Details")
            self.menuItems.append("History")
            self.menuItems.append("GoCardless")
            self.menuItems.append("Funding Offer")
        }
        
        self.setDelegates()
        self.addObserverOnHeightTbl()
        self.manageActionMethods()
        self.createModelArrayForLoan()

        self.createModelArrayForCompany()
        let attributedTitle = NSMutableAttributedString(string: "Generate Link", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 11.0), NSAttributedString.Key.foregroundColor: UIColor(named: "blue"),NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])

        self.generateRegenerateBtn.setAttributedTitle(attributedTitle, for: .normal)

        self.fetchBankDetails()
        self.bankStatementArray.removeAll()
        self.accountsTable.isHidden = true
        self.accountsTable.reloadData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        self.navigationController?.isNavigationBarHidden = true
        if let tabbar = self.parent?.parent as? TabBarController {
            if let navigationController = tabbar.parent as? UINavigationController {
                navigationController.isNavigationBarHidden = true
            }
        }
        self.fetchBankAccountDetails()
        self.fetchStatementDetails()
//        self.tabBarController?.tabBar.isHidden = true
    }
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    func setDelegates() {
        self.headersCollection.delegate = self
        self.headersCollection.dataSource = self
        self.detailsTable.delegate = self
        self.detailsTable.dataSource = self
        self.gocardlessTable.delegate = self
        self.gocardlessTable.dataSource = self
        self.step1Table.delegate = self
        self.step1Table.dataSource = self
        self.step2Table.delegate = self
        self.step2Table.dataSource = self
        self.leadsNameHeader.text = self.loanData?.customer.companyName
        self.leadName.text = self.loanData?.customer.companyName
        var color = "yellow"
        if loanData?.customer.loanDetails.filter({$0.loanID == loanData?.id}).first?.currentStatus == "Admin_Cash_Disbursed" {
            color = "green"
        }else if loanData?.customer.loanDetails.filter({$0.loanID == loanData?.id}).first?.currentStatus.lowercased().contains("rejected") ?? false || loanData?.customer.loanDetails.filter({$0.loanID == loanData?.id}).first?.currentStatus.lowercased().contains("returned") ?? false {
            color = "red"
        }
        self.loanStatusButton.backgroundColor = UIColor(named: color)?.withAlphaComponent(0.4)
        if loanData?.customer.loanDetails.filter({$0.loanID == loanData?.id}).first?.currentStatus != "" {
            // cell.loanStatusButton.isHidden = false
            let attributedTitle = NSMutableAttributedString(string: loanData?.customer.loanDetails.filter({$0.loanID == loanData?.id}).first?.currentStatus ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: color)])
            self.loanStatusButton.setAttributedTitle(attributedTitle, for: .normal)
        }

        self.step2Stack.isHidden = true
        self.requisitionStack.isHidden = true
        self.gocardlessTable.isHidden = true
        self.gocardlessStatusView.isHidden = true
        self.gotoApplicationBtn.isHidden = false
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

                   //self.step2Stack.isHidden = !self.isAgreed
                   //if !self.isAgreed {
                       self.fetchGocardlessManualStatementDetails()
                  // }else{
                       self.fetchGocardlessStatementDetails()
                  // }
                   if self.step1TF.text != "" && self.requisitionLink != "" && self.isAgreed {
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
        self.backBtn.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        self.gotoApplicationBtn.addTapGestureRecognizer {
            var model = self.loanData

            let vc = LeadsDetailsVC.initWithStory(customerId: model?.customer.id ?? "", customerName: (model?.customer.firstName ?? "") + " " + (model?.customer.lastName ?? ""), customerPhone: model?.customer.phoneNumber ?? "", customerImage: model?.customer.image ?? "")
            vc.loanID = self.loanData?.id ?? ""//model?.customer.loanDetails.value(atSafe: self.loanDetailsIndex)?.loanID ?? ""
            vc.loanStatus = self.loanData?.customer.loanDetails.filter({$0.loanID == self.loanData?.id}).first?.currentStatus ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
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
            self.step2Stack.isHidden = false
            let attributedTitle = NSMutableAttributedString(string: "Completed", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: "yellow")])

            self.step1StatusButton.setAttributedTitle(attributedTitle, for: .normal)

            var vc = WebViewController.initWithStory()
            vc.strPageTitle = ""
            vc.isToRedirect = true
            vc.strWebUrl = self.requisitionLink//self.requisitionData?.link ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
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
    func fetchFundingOfferDetails() {
        APIService.shared.retrieveFundingOfferDetails(loanId: self.loanData?.id ?? "") { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data
                        self.fundingOfferArray = data.data
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
    func fetchStatementDetails() {
        APIService.shared.retrieveStatementDetails(loanId: self.loanData?.id ?? "") { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data
                        self.statementModel = data.data
                        
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
    func fetchBankDetails() {
        APIService.shared.retrieveBankDetails(loanId: "") { result in
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
        APIService.shared.retrieveGocardlessManualStatementDetails(loanId: self.loanData?.id ?? "") { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data
                        self.selectedGocardlessManualStatement = responseData.data.bankDetails
                        self.gocardlessTable.isHidden = true
                        self.gocardlessStatusView.isHidden = true

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
                            if self.requisitionLink != "" && self.isAgreed {
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
                        var loansta = self.loanData?.customer.loanDetails.filter({$0.loanID == self.loanData?.id}).first?.currentStatus.lowercased() ?? ""
                        if loansta.hasSuffix("submitted") ?? false || loansta == "admin_cash_disbursed" {
                            self.bankNumberStack.isHidden = true
                            self.accountNumberStack.isHidden = true
                            self.accountHolderStack.isHidden = true
                            self.sortCodeStack.isHidden = true
                            self.countryCodeStack.isHidden = true
                            self.addBankAccountBtn.isHidden = true
                            self.documentStack.isHidden = true
                        }else{
                            if !self.isAgreed {
                                self.bankNumberStack.isHidden = false
                                self.accountNumberStack.isHidden = false
                                self.accountHolderStack.isHidden = false
                                self.sortCodeStack.isHidden = false
                                self.countryCodeStack.isHidden = false
                                self.addBankAccountBtn.isHidden = false
                                self.documentStack.isHidden = false
                                
                            }
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
    func fetchGocardlessStatementDetails() {
        APIService.shared.retrieveGocardlessStatementDetails(loanId: self.loanData?.id ?? "") { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data
                        self.selectedGocardlessStatement = responseData.data.filter({$0.gocardlessStatus == true})
                        self.gocardlessTable.isHidden = true
                        self.gocardlessStatusView.isHidden = true

                        for item in self.selectedGocardlessStatement {
                            self.gocardlessTable.isHidden = false
                            self.gocardlessStatusView.isHidden = true
                            self.gocardlessTable.reloadData()

                           // return
                        }
                        var loansta = self.loanData?.customer.loanDetails.filter({$0.loanID == self.loanData?.id}).first?.currentStatus.lowercased() ?? ""

                        if loansta.hasSuffix("submitted") ?? false || loansta == "admin_cash_disbursed" {
                            self.step1Stack.isHidden = true
                        }else{
                            if self.isAgreed {
                                self.step1Stack.isHidden = false
                            }
                        }
//                        if self.gocardlessTable.isHidden {
//                            self.step1Stack.isHidden = false
////                            self.dropdownType = .step1
////                            self.showHideTable()
//                        }
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
        var url = APIEnums.createManualBank.rawValue + (self.loanData?.id ?? "") + "/"
           
            ConnectionHandler().uploadDocuments(wsMethod: url, paramDict: paramDict, dataArray: dataArray, viewController: self, isToShowProgress: true, isToStopInteraction: true) { response in
                if response.status_code == 200 {
                    self.showAlert(title: "Info", message: response.status_message)
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
        APIService.shared.retrieveBankAccountDetails(loanId: self.loanData?.id ?? "") { result in
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
    func confirmBankAccountDetails(loanId: String,params: JSON) {
        var url = APIEnums.retrieveBankAccounts.rawValue + "\(loanId)/"
        
        APIService.shared.makeRequest(endpoint: url,
                                      withLoader: true,
                                      method: .post,
                                      params: params) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    let attributedTitle = NSMutableAttributedString(string: "Completed", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: "yellow")])

                    self.step2StatusButton.setAttributedTitle(attributedTitle, for: .normal)
                    //self.nextButton.isHidden = false
                    self.showAlert(title: "Info", message: data.statusMessage)
                    self.fetchGocardlessStatementDetails()
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
    func createModelArrayForLoan() {
        self.loanKVArray.removeAll()
        var model = self.loanData
        let status = MenuModel.init(title: "Application Status", value: model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.currentStatus ?? "", apiKey: "")
        let manager = MenuModel.init(title: "Manager Approved:", value: model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.approvedByManager == true ? "Approved" : "Pending", apiKey: "")
        let admin = MenuModel.init(title: "Admin Approved:", value: model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.approvedByAdmin == true ? "Approved" : "Pending", apiKey: "")
        
       
        self.loanKVArray.append(status)
        self.loanKVArray.append(manager)
        self.loanKVArray.append(admin)
    }
    //---------------------------------------
    // MARK: - Init With Story
    //---------------------------------------

    class func initWithStory(loanData: LoanData,index: Int) -> ProfileDetailsVC {
        let vc : ProfileDetailsVC = UIStoryboard.Login.instantiateViewController()
        vc.loanData = loanData
        vc.loanDetailsIndex = index
        return vc
    }
    func createModelArrayForCompany() {
        self.companyKVArray.removeAll()
        let name = MenuModel.init(title: "Company Name", value: self.loanData?.customer.companyName ?? "", apiKey: "")
        let id = MenuModel.init(title: "ID", value: self.loanData?.customer.id ?? "", apiKey: "")
//        let status = MenuModel.init(title: "Company Status", value: self.loanData?.customer.companyStatus ?? "", apiKey: "")
//        let number = MenuModel.init(title: "Company Number", value: self.loanData?.customer.companyNumber ?? "", apiKey: "")
//        let businessType = MenuModel.init(title: "Business Type", value: self.loanData?.customer.businessType ?? "", apiKey: "")
//        let tradingStyle = MenuModel.init(title: "Trading Style", value: self.loanData?.customer.tradingStyle ?? "", apiKey: "")
//        let fundingPurpose = MenuModel.init(title: "Funding Purpose", value: self.loanData?.customer.fundingPurpose ?? "", apiKey: "")
//        let otherPurpose = MenuModel.init(title: "Other Funding Purpose", value: self.loanData?.customer.otherFundingPurpose ?? "", apiKey: "")


        self.companyKVArray.append(name)
        self.companyKVArray.append(id)
//        self.companyKVArray.append(status)
//        self.companyKVArray.append(number)
//        self.companyKVArray.append(businessType)
//        self.companyKVArray.append(tradingStyle)
//        self.companyKVArray.append(fundingPurpose)
//        if self.companyDetails?.otherFundingPurpose != "" {
//            self.companyKVArray.append(otherPurpose)
//        }
        self.detailsTable.reloadData()
    }
}
extension ProfileDetailsVC {
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
extension ProfileDetailsVC : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCollectionViewCell",
                                                      for: indexPath) as! ProfileCollectionViewCell
        cell.titleLabel.text = self.menuItems.value(atSafe: indexPath.row)
        cell.separatorLabel.isHidden = self.selectedIndex == indexPath.row ? false : true

        cell.addTapGestureRecognizer {
            self.selectedIndexText = self.menuItems.value(atSafe: indexPath.row) ?? ""
            self.selectedIndex = indexPath.row
            self.headersCollection.reloadData()
            self.detailsView.isHidden = false
            self.gocardlessView.isHidden = true
            self.gotoApplicationBtn.isHidden = true
          //  self.isAgreed = false
            self.agreementImage.image = self.isAgreed ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")

//            if cell.titleLabel.text != "Funding Offer" {
                self.detailsTable.reloadData()
//            }
            switch self.selectedIndexText {
            case "Funding":
                self.gotoApplicationBtn.isHidden = false
                break
            case "Unit Profile":
                break
            case "Contract Details":
//                self.currentTripPageIndex = 0
//                self.HittedTripPageIndex = 0
//                self.fetchCustomerDetails(url: APIEnums.customersList.rawValue)
                self.fetchPaymentDetails()
            case "History":
                self.fetchPaymentDetails()
                self.fetchLoanDetails()
//            case 3:
//                self.fetchPhotoIDDetails()
//                break
//            case 4:
//                self.fetchAddressProofDetails()
//                break
//            case 5:
//                self.fetchOtherFilesDetails()
//                break
//            case 6:
//                self.fetchBankStatementDetails()
//                break
            case "GoCardless":
                self.detailsView.isHidden = true
                self.gocardlessView.isHidden = false
                self.agreementStack.isHidden = true
                self.step1Stack.isHidden = true
                self.step2Stack.isHidden = true
                self.bankNumberStack.isHidden = true
                self.accountNumberStack.isHidden = true
                self.accountHolderStack.isHidden = true
                self.sortCodeStack.isHidden = true
                self.countryCodeStack.isHidden = true
                self.addBankAccountBtn.isHidden = true
                self.documentStack.isHidden = true
                var loansta = self.loanData?.customer.loanDetails.filter({$0.loanID == self.loanData?.id}).first?.currentStatus
                if loansta != "Agent_Submitted" && loansta != "Underwriter_Submitted" && loansta != "Admin_Cash_Disbursed" {
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
              //  self.fetchGocardlessStatementDetails()
              //  if !self.isAgreed {
                    self.fetchGocardlessManualStatementDetails()
               // }else{
                    self.fetchGocardlessStatementDetails()
              //  }
            case "Funding Offer":
                self.fetchFundingOfferDetails()
                break

        default:
                  break
            }

        }
        return cell
    }
}
extension ProfileDetailsVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
//        if tableView == self.detailsTable {
//            return 1
//        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.selectedIndexText {
        case "Funding":
            return self.loanKVArray.count
        case "Unit Profile":
            return self.companyKVArray.count
        case "Contract Details":
            return self.paymentArray.count
        case "History":
            return 1
//        case 3:
//            return self.viewModel.documentArray.count
//        case 4:
//            return self.viewModel.documentArray2.count
//        case 5:
//            return self.viewModel.otherArray.count
//        case 6:
//            return self.viewModel.statementArray.count
        case "GoCardless":
            if tableView == self.gocardlessTable {
                return self.isAgreed ? self.selectedGocardlessStatement.count : self.selectedGocardlessManualStatement.count
            }
            else if tableView == self.accountsTable {
                return self.bankStatementArray.count
            }
            else {
                switch self.dropdownType {
                case .step1:
                    return self.bankArray.count
                case .step2:
                    return self.bankAccountArray.count
                case .bankName:
                    return self.bankArray.count
                default:
                    return 0

                }
            }
        case "Funding Offer":
            return self.fundingOfferArray.count
        default:
            return 0
        }
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == detailsTable {
            if self.selectedIndexText == "Funding" {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "leadsDetailsCell", for: indexPath) as? LeadsDetailsCell else {
                    return UITableViewCell()
                }
                var array = self.loanKVArray
                    cell.titleLabel.text = array.value(atSafe: indexPath.row)?.title
                    cell.valueLabel.text = array.value(atSafe: indexPath.row)?.value

                    return cell

            }
            else if self.selectedIndexText == "Unit Profile" {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "leadsDetailsCell", for: indexPath) as? LeadsDetailsCell else {
                    return UITableViewCell()
                }
                var array = self.companyKVArray
                    cell.titleLabel.text = array.value(atSafe: indexPath.row)?.title
                    cell.valueLabel.text = array.value(atSafe: indexPath.row)?.value

                    return cell

            }
            else if self.selectedIndexText == "Contract Details" {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingPaymentsTableViewCell", for: indexPath) as? UpcomingPaymentsTableViewCell else {
                    return UITableViewCell()
                }
                guard let model = self.paymentArray.value(atSafe: indexPath.row) else {return UITableViewCell()}
                
                cell.paymentTitleLabel.text = model.title
                cell.dueDateLabel.text = model.dueDate
                cell.paymentAmountLabel.text = model.nextDue
                cell.fundingAmountLabel.text = model.fundingAmount
                cell.installmentPaidLabel.text = model.instalmentPaid.description
                cell.remainingInstallmentLabel.text = model.remainingInstalment.description
                cell.loanNumberLabel.text = "Loan Number"
                cell.loanNumberValueLabel.text = self.loanId
                cell.missedEMILabel.text = "Gocardless Missed EMIs"
                cell.missedEMIValueLabel.text = model.gocardlessMissedEmis.description
                if model.status == "Due" {
                    cell.makePaymentView.isHidden = false
                    cell.dueView.isHidden = false
                }else{
                    cell.makePaymentView.isHidden = true
                    cell.dueView.isHidden = true
                }
                cell.makePaymentBtn.addTapGestureRecognizer {
                    if UserDefaults.standard.value(forKey: "role") as? String != "FIELDAGENT" {
                        var dict5 = JSON()
                        let model = self.paymentArray.value(atSafe: indexPath.row)
                        dict5["description"] = "instant pay i missed due"
                        dict5["amount"] = model?.nextDue.replacingOccurrences(of: "£", with: "").toInt() ?? ""
                        dict5["currency"] = "GBP"
                        self.instantPay(loanId: self.loanData?.customer.loanDetails.first?.loanID ?? "",Dict: dict5)
                    }
                   
                }
                cell.totalInstallmentValueLabel.text = model.totalInstalment.description
                return cell
            }
            else if self.selectedIndexText == "Funding Offer" {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "fundingOfferCell2", for: indexPath) as? FundingOfferCell else {
                    return UITableViewCell()
                }
                guard let model = self.fundingOfferArray.value(atSafe: indexPath.row) else {return UITableViewCell()}

                cell.dateLabel.text = self.convertDateFormat(inputDate: model.offerDate,outputFormat: "yyyy-MM-dd")
                cell.offerAmountLabel.text = "£" + model.offerAmount
                cell.offerWeeksLabel.text = model.offerNumberOfWeeks.description + " Weeks"
                var title = model.offerAccepted ? "Accepted" : (model.offerRejected ? "Rejected" : "No Action")
                let attributedTitle = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: "yellow")])

                cell.statusButton.setAttributedTitle(attributedTitle, for: .normal)

                cell.expiredButton.isHidden = !model.isExpired
                if model.isExpired {
                    cell.alphaView.isHidden = false
                }else{
                    cell.alphaView.isHidden = true
                }
                return cell
            }
            else if self.selectedIndexText == "History" {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "paymentHistoryCell", for: indexPath) as? PaymentHistoryCell else {
                    return UITableViewCell()
                }
                let model = self.historyArray
                
                if cell.isExtended{
                    cell.innerTable.isHidden = false
                    cell.innerTableHidden = false
                    cell.showHideTable()
                    
                }else{
                    cell.innerTable.isHidden = true
                    cell.innerTableHidden = true
                    cell.showHideTable()
                    
                }
                cell.model = model
                cell.controllerObj = self
                cell.imageLabel.text = "Activity"
                cell.statmentModel = self.statementModel
                cell.delegate = self
                cell.imageActionView.addTapGestureRecognizer {
                    cell.innerTableHidden = !cell.innerTableHidden
//                    guard let model = self.viewModel.paymentArray.value(atSafe: indexPath.row) else {return}
                    cell.isExtended = !cell.isExtended
                    cell.showHideTable()
                    self.detailsTable.reloadData()
                }
                return cell
            }
            else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "documentTableViewCell", for: indexPath) as? DocumentTableViewCell else {
                    return UITableViewCell()
                }
                var array : DocumentModel!
                        
                        switch self.selectedIndexText {
                        case "Photo ID":
                            array = self.viewModel.documentArray.value(atSafe: indexPath.row)
                        case "Address Proof":
                            array = self.viewModel.documentArray2.value(atSafe: indexPath.row)
                        case "Other Files":
                            array = self.viewModel.otherArray.value(atSafe: indexPath.row)
                        case "Bank Statements":
                            array = self.viewModel.statementArray.value(atSafe: indexPath.row)
                        default:
                            break
                        }
                guard let model = array else {return UITableViewCell()}

                if model.isSelected{
                    cell.selectedFileView.isHidden = false
                    cell.uploadView.isHidden = true
                }else{
                    cell.selectedFileView.isHidden = true
                    cell.uploadView.isHidden = false
                }
                cell.selectedViewButton.addTapGestureRecognizer {
                    if model.fileURL != "" {
                        var vc = WebViewController.initWithStory()
                        vc.strPageTitle = "Document"
                        vc.strWebUrl = model.fileURL ?? ""
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        self.showAlert(title: "Info", message: "Selected file document URL is invalid")
                    }
                    
                }
                cell.model = model
                cell.fileTypeLabel.text = ((self.selectedIndex == 4 && indexPath.row != 0) || (self.selectedIndex == 5 && indexPath.row != 0 ) ) ? "" : model.type
                cell.selectedFileName.text = model.fileName
                cell.selectedFileSize.text = model.fileSize
                cell.boxView.addTapGestureRecognizer {
                    self.selectedDocumentIndex = indexPath.row
                 //   self.redirectToImageChooseVC()
                }

                return cell
            }
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
            return cell
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
                self.step1ErrStack.isHidden = true
                var params = JSON()
                params["bank_name"] = self.step1TF.text
                params["institution_id"] = "SANDBOXFINANCE_SFIN0000"
                self.createRequisitionDetails(loanId:self.loanData?.id ?? "",params: params)
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
                self.confirmBankAccountDetails(loanId:self.loanData?.id ?? "",params: params)
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.detailsTable && self.selectedIndexText == "Funding Offer" {
            guard let model = self.fundingOfferArray.value(atSafe: indexPath.row) else{
                return
            }
            if !model.isExpired {
                let vc = FundingOfferAcceptRejectVC.initWithStory(offerData: model)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if self.selectedIndex == 2 {
//           return 100
//        }
        if tableView == self.gocardlessTable && self.isAgreed {
            return 135
        }
        else if tableView == self.gocardlessTable && !self.isAgreed {
            return 100
        }
        else if tableView == self.step1Table || tableView == self.step2Table  {
            return 50
        }
            return UITableView.automaticDimension
    }
}
extension ProfileDetailsVC {
    func fetchOtherFilesDetails() {
        APIService.shared.retrieveOtherFilesDetailsFromAgent(unitId: self.loanData?.customer.id ?? "") { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedOtherResponse = responseData
                        self.viewModel.otherArray.removeAll()
                        if self.selectedOtherResponse?.otherFiles.count != 0 {
                            for item in self.selectedOtherResponse?.otherFiles ?? [MultipleDocumentsDataClass]() {
                                let model = DocumentModel()
                                model.isSelected = true
                                model.type =  "Other Files"
                                model.apiKey = "other_files"
                                model.fileName = URL(fileURLWithPath: item.file ?? "").deletingPathExtension().lastPathComponent
                                model.fileURL = item.file ?? ""
                                self.viewModel.otherArray.append(model)
                            }
                        }
                    }
                    catch {
                        
                    }
                    self.detailsTable.reloadData()
                }
                else {
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func fetchBankStatementDetails() {
        APIService.shared.retrieveBankStatementDetailsFromAgent(unitId: self.loanData?.customer.id ?? "") { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedBankStatementResponse = responseData
                        self.viewModel.statementArray.removeAll()
                        if self.selectedBankStatementResponse?.businessAccountStatement.count != 0 {
                            for item in self.selectedBankStatementResponse?.businessAccountStatement ?? [MultipleDocumentsDataClass]() {
                                let model = DocumentModel()
                                model.isSelected = true
                                model.type =  "Bank Statement"
                                model.apiKey = "business_account_statements"
                                model.fileName = URL(fileURLWithPath: item.file ?? "").deletingPathExtension().lastPathComponent
                                model.fileURL = item.file ?? ""
                                self.viewModel.statementArray.append(model)
                            }
                        }
                    }
                    catch {
                        
                    }
                    self.detailsTable.reloadData()
                }
                else {
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchPhotoIDDetails() {
        APIService.shared.retrievePhotoIDDetailsFromAgent(unitId: self.loanData?.customer.id ?? "") { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedPhotoIdResponse = responseData
                        //self.deletePhotoIDDetails()
                        self.viewModel.documentArray.removeAll()
                        if self.selectedPhotoIdResponse?.photo != "" && self.selectedPhotoIdResponse?.photo != nil {
                            let model = DocumentModel()
                            model.isSelected = true
                            model.type = "Photo"
                            model.apiKey = "photo"
                            model.fileName = URL(fileURLWithPath: self.selectedPhotoIdResponse?.photo ?? "").deletingPathExtension().lastPathComponent
                            model.fileURL = self.selectedPhotoIdResponse?.photo ?? ""
                            self.viewModel.documentArray.append(model)
                        }
//                        else{
//                            let model = DocumentModel()
//                            model.isSelected = false
//                            model.type = "Photo"
//                            model.apiKey = "photo"
//                            self.viewModel.documentArray.append(model)
//                        }
                        if self.selectedPhotoIdResponse?.passport != "" && self.selectedPhotoIdResponse?.passport != nil {
                            let model = DocumentModel()
                            model.isSelected = true
                            model.type = "Passport"
                            model.apiKey = "passport"
                            model.fileName = URL(fileURLWithPath: self.selectedPhotoIdResponse?.passport ?? "").deletingPathExtension().lastPathComponent
                            model.fileURL = self.selectedPhotoIdResponse?.passport ?? ""

                            self.viewModel.documentArray.append(model)
                        }
                        if self.selectedPhotoIdResponse?.drivingLicense != "" && self.selectedPhotoIdResponse?.drivingLicense != nil {
                            let model = DocumentModel()
                            model.isSelected = true
                            model.type = "Driving License"
                            model.apiKey = "driving_license"
                            model.fileName = URL(fileURLWithPath: self.selectedPhotoIdResponse?.drivingLicense ?? "").deletingPathExtension().lastPathComponent
                            model.fileURL = self.selectedPhotoIdResponse?.drivingLicense ?? ""
                            self.viewModel.documentArray.append(model)
                        }
//                        else{
//                            let model = DocumentModel()
//                            model.isSelected = false
//                            model.type = "Passport Or Driving License"
//                            model.apiKey = "passport_or_driving_license"
//                            self.viewModel.documentArray.append(model)
//                        }
                        self.detailsTable.reloadData()

                    }
                    catch {
                        
                    }

                }
                else {
                    //self.showAlert(title: "Info", message: data.statusMessage)
                }
            case .failure(let error):
               // self.showAlert(title: "Info", message: error.localizedDescription)
                print(error)
            }
        }
    }
    func fetchAddressProofDetails() {
        APIService.shared.retrieveAddressProofDetailsFromAgent(unitId: self.loanData?.customer.id ?? "") { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedAddressProofResponse = responseData
                        //self.deleteAddressProofDetails()
                        self.viewModel.documentArray2.removeAll()
                        if self.selectedAddressProofResponse?.councilTax != "" && self.selectedAddressProofResponse?.councilTax != nil {
                            let model = DocumentModel()
                            model.isSelected = true
                            model.type = "Council Tax"
                            model.apiKey = "council_tax"
                            model.fileName = URL(fileURLWithPath: self.selectedAddressProofResponse?.councilTax ?? "").deletingPathExtension().lastPathComponent
                            model.fileURL = self.selectedAddressProofResponse?.councilTax ?? ""
                            self.viewModel.documentArray2.append(model)
                        }
//                        else{
//                            let model = DocumentModel()
//                            model.isSelected = false
//                            model.type = "Council Tax"
//                            model.apiKey = "council_tax"
//                            self.viewModel.documentArray2.append(model)
//                        }
                        if self.selectedAddressProofResponse?.utilityBill != "" && self.selectedAddressProofResponse?.utilityBill != nil {
                            let model = DocumentModel()
                            model.isSelected = true
                            model.type = "Utility Bill"
                            model.apiKey = "utility_bill"
                            model.fileName = URL(fileURLWithPath: self.selectedAddressProofResponse?.utilityBill ?? "").deletingPathExtension().lastPathComponent
                            model.fileURL = self.selectedAddressProofResponse?.utilityBill ?? ""

                            self.viewModel.documentArray2.append(model)
                        }
//                        else{
//                            let model = DocumentModel()
//                            model.isSelected = false
//                            model.type = "Utility Bill"
//                            model.apiKey = "utility_bill"
//                            self.viewModel.documentArray2.append(model)
//                        }
                        if self.selectedAddressProofResponse?.leaseDeed != "" && self.selectedAddressProofResponse?.leaseDeed != nil {
                            let model = DocumentModel()
                            model.isSelected = true
                            model.type = "Lease Deed"
                            model.apiKey = "lease_deed"
                            model.fileName = URL(fileURLWithPath: self.selectedAddressProofResponse?.leaseDeed ?? "").deletingPathExtension().lastPathComponent
                            model.fileURL = self.selectedAddressProofResponse?.leaseDeed ?? ""

                            self.viewModel.documentArray2.append(model)
                        }
//                        else{
//                            let model = DocumentModel()
//                            model.isSelected = false
//                            model.type = "Lease Deed"
//                            model.apiKey = "lease_deed"
//                            self.viewModel.documentArray2.append(model)
//                        }
                        self.detailsTable.reloadData()

                    }
                    catch {
                        
                    }
                }
                else {
                    //self.showAlert(title: "Info", message: data.statusMessage)
                }
            case .failure(let error):
               // self.showAlert(title: "Info", message: error.localizedDescription)
                print(error)
            }
        }
    }
    func fetchCustomerDetails(url: String) {
        var page = self.currentTripPageIndex+1
        guard  self.HittedTripPageIndex != self.currentTripPageIndex + 1 else {
            return
        }
        var urlStr = APIEnums.customersList.rawValue + "?company_id=\(self.loanData?.customer.id ?? "")"
        if page != 1 {
            urlStr = urlStr + "?page=\(page)"
        }
        APIService.shared.retrieveCustomerDetails(url: urlStr) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.customerObject = data
                        self.customerModel.append(contentsOf: responseData)
                        self.searchList.append(contentsOf: responseData)
                        var next = self.getQueryItems(data.next)
                        var last = self.getQueryItems(data.last)
                        var Lastitem = last.filter({$0.key == "page"}).first?.value
                        var currentItem = next.filter({$0.key == "page"}).first?.value

                        self.totalTripPages = (Lastitem?.toInt() ?? 0)
                        self.currentTripPageIndex = (currentItem?.toInt() ?? 0) - 1
                        self.HittedTripPageIndex = (currentItem?.toInt() ?? 0) - 1

                      //  self.searchList = self.searchList.sorted(by: {$0.firstName < $1.firstName })

                        self.detailsTable.reloadData()
                    }
                    catch {
                        
                    }
                    self.oneTimeForHistory = true
                }
                else {
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchPaymentDetails() {
        APIService.shared.retrievePaymentDetails(loanId: self.loanData?.id ?? "") { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.loanId = responseData.loanID.description
                        self.paymentArray = responseData.fundingPayments
                        self.historyArray = responseData.fundingPaymentHistory
                        for data in responseData.fundingPayments.first!.gocardlessMissedEmiDates {
                            self.historyArray.append(FundingPaymentHistory(id: data.id, date: data.emiDate, amount: data.amount, description:"Payment Failed"))
                        }
                        self.detailsTable.reloadData()
                    }
                    catch {
                        
                    }
                    self.detailsTable.reloadData()
                }
                else {
                    //self.showAlert(title: "Info", message: data.statusMessage)
                }
            case .failure(let error):
               // self.showAlert(title: "Info", message: error.localizedDescription)
                print(error)
            }
        }
    }
    func fetchLoanDetails() {
        APIService.shared.retrieveLoanDetailsFromAgent(unitId: self.loanData?.customer.id ?? "") { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data
                        self.loanModel = responseData
                        globalLoanModel = self.loanModel
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
    func instantPay(loanId: String,Dict: JSON){
        var url = APIEnums.createInstantPay.rawValue
        if loanId != "" {
            url = url + "\(loanId)/" + "?request_from=web"
        }
        APIService.shared.InstantPayRequest(endpoint: url,
                                      withLoader: true,
                                      method: .post,
                                      params: Dict) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    print(data)
                    var vc = WebViewController.initWithStory()
                    vc.strPageTitle = ""
                    vc.isToRedirect = true
                    vc.strWebUrl = data.data.authorisationURL
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if data.statusCode == 401 {
                    //self.tokenRefreshApi(params: Dict)
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
//MARK: -------------------------- Observers Methods --------------------------
extension ProfileDetailsVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.detailsTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.detailTableHeight.constant = newvalue.height
        }
        if let obj = object as? UITableView, obj == self.accountsTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.accountTableHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.detailsTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.accountsTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.detailsTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        guard let tblView5 = self.accountsTable else {return}
          if let _ = tblView5.observationInfo {
              tblView5.removeObserver(self, forKeyPath: "contentSize")
          }
    }
}
extension ProfileDetailsVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cell = detailsTable.visibleCells.last as? LeadsCell
        guard ((cell?.leadsName.text) != nil),
              (self.searchList.last != nil) else {return}
        if cell?.leadsName.accessibilityHint == (self.searchList.last?.id) &&
            self.customerObject?.next != "" && self.currentTripPageIndex != self.totalTripPages && oneTimeForHistory {
            self.fetchCustomerDetails(url: self.customerObject?.next ?? "")
            self.oneTimeForHistory = !self.oneTimeForHistory
        }
    }
}
extension ProfileDetailsVC : UIDocumentPickerDelegate {
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
extension ProfileDetailsVC : UITextFieldDelegate {

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
    }
}
