//
//  DocumentUploadViewController.swift
//  Credit4Business
//
//  Created by MacMini on 14/03/24.
//

import UIKit
import StepProgressBar
import IQKeyboardManagerSwift
import Photos
import MobileCoreServices
import UniformTypeIdentifiers

class DocumentUploadViewController: UIViewController {

    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var photoFileUploadView: UIView!
    @IBOutlet weak var photoFileUploadLabel: UILabel!
    @IBOutlet weak var photoFileUploadErrLabel: UILabel!
    @IBOutlet weak var photoFileUploadErrStack: UIStackView!
    @IBOutlet weak var photoFileUploadButton: UIButton!
    
    @IBOutlet weak var selectedPhotoClose: UIView!
    @IBOutlet weak var selectedPhotoFileName: UILabel!
    @IBOutlet weak var selectedPhotoView: UIView!
    
    @IBOutlet weak var passportFileUploadView: UIView!
    @IBOutlet weak var passportFileUploadLabel: UILabel!
    @IBOutlet weak var passportFileUploadErrLabel: UILabel!
    @IBOutlet weak var passportFileUploadErrStack: UIStackView!
    @IBOutlet weak var passportFileUploadButton: UIButton!

    @IBOutlet weak var selectedPassportClose: UIView!
    @IBOutlet weak var selectedPassportFileName: UILabel!
    @IBOutlet weak var selectedPassportView: UIView!

    @IBOutlet weak var drivingLicenseFileUploadView: UIView!
    @IBOutlet weak var drivingLicenseFileUploadLabel: UILabel!
    @IBOutlet weak var drivingLicenseFileUploadErrLabel: UILabel!
    @IBOutlet weak var drivingLicenseFileUploadErrStack: UIStackView!
    @IBOutlet weak var drivingLicenseFileUploadButton: UIButton!

    @IBOutlet weak var selectedDrivingLicenseClose: UIView!
    @IBOutlet weak var selectedDrivingLicenseFileName: UILabel!
    @IBOutlet weak var selectedDrivingLicenseView: UIView!

    
    @IBOutlet weak var councilTaxFileUploadView: UIView!
    @IBOutlet weak var councilTaxFileUploadLabel: UILabel!
    @IBOutlet weak var councilTaxFileUploadErrLabel: UILabel!
    @IBOutlet weak var councilTaxFileUploadErrStack: UIStackView!
    @IBOutlet weak var councilTaxFileUploadButton: UIButton!

    @IBOutlet weak var selectedCouncilTaxClose: UIView!
    @IBOutlet weak var selectedCouncilTaxFileName: UILabel!
    @IBOutlet weak var selectedCouncilTaxView: UIView!
    
    @IBOutlet weak var billFileUploadView: UIView!
    @IBOutlet weak var billFileUploadLabel: UILabel!
    @IBOutlet weak var billFileUploadErrLabel: UILabel!
    @IBOutlet weak var billFileUploadErrStack: UIStackView!
    @IBOutlet weak var billFileUploadButton: UIButton!

    @IBOutlet weak var selectedBillClose: UIView!
    @IBOutlet weak var selectedBillFileName: UILabel!
    @IBOutlet weak var selectedBillView: UIView!

    @IBOutlet weak var premiseFileUploadView: UIView!
    @IBOutlet weak var premiseFileUploadLabel: UILabel!
    @IBOutlet weak var premiseFileUploadErrLabel: UILabel!
    @IBOutlet weak var premiseFileUploadErrStack: UIStackView!
    @IBOutlet weak var premiseFileUploadButton: UIButton!

    @IBOutlet weak var selectedPremiseClose: UIView!
    @IBOutlet weak var selectedPremiseFileName: UILabel!
    @IBOutlet weak var selectedPremiseView: UIView!

    @IBOutlet weak var accountFileUploadView: UIView!
    @IBOutlet weak var accountFileUploadLabel: UILabel!
    @IBOutlet weak var accountFileUploadErrLabel: UILabel!
    @IBOutlet weak var accountFileUploadErrStack: UIStackView!
    @IBOutlet weak var accountFileUploadButton: UIButton!

    @IBOutlet weak var selectedAccountClose: UIView!
    @IBOutlet weak var selectedAccountFileName: UILabel!
    @IBOutlet weak var selectedAccountView: UIView!

    @IBOutlet weak var otherFileUploadView: UIView!
    @IBOutlet weak var otherFileUploadLabel: UILabel!
    @IBOutlet weak var otherFileUploadErrLabel: UILabel!
    @IBOutlet weak var otherFileUploadErrStack: UIStackView!
    @IBOutlet weak var otherFileUploadButton: UIButton!

    @IBOutlet weak var selectedOtherClose: UIView!
    @IBOutlet weak var selectedOtherFileName: UILabel!
    @IBOutlet weak var selectedOtherView: UIView!

    @IBOutlet weak var agreementView: UIView!
    @IBOutlet weak var agreementImage: UIImageView!
    @IBOutlet weak var agreementErrLabel: UILabel!
    @IBOutlet weak var agreementErrStack: UIStackView!
    @IBOutlet weak var pageControl: CustomPageControl!
    
    @IBOutlet weak var otherTable: UITableView!
    @IBOutlet weak var accountsTable: UITableView!
    @IBOutlet weak var commentButton: UIImageView!
    @IBOutlet weak var accountTableHeight: NSLayoutConstraint!
    @IBOutlet weak var otherTableHeight: NSLayoutConstraint!
    var otherArray = [UploadDocumentModel]()
    var bankStatementArray = [UploadDocumentModel]()
    
    //MARK: -------------------- Class Variable --------------------
    var photoFileUploadStr = ""
    var passportFileUploadStr = ""
    var billFileUploadStr = ""
    var premiseFileUploadStr = ""
    var accountFileUploadStr = ""
    var otherFileUploadStr = ""
    var drivingLicenseFileUploadStr = ""
    var councilTaxFileUploadStr = ""

    var photoFileUploadMIME = ""
    var passportFileUploadMIME = ""
    var billFileUploadMIME = ""
    var premiseFileUploadMIME = ""
    var accountFileUploadMIME = ""
    var otherFileUploadMIME = ""
    var drivingLicenseFileUploadMIME = ""
    var councilTaxFileUploadMIME = ""

    var photoFileUploadType = ""
    var passportFileUploadType = ""
    var billFileUploadType = ""
    var premiseFileUploadType = ""
    var accountFileUploadType = ""
    var otherFileUploadType = ""
    var drivingLicenseFileUploadType = ""
    var councilTaxFileUploadType = ""

    var photoFileName = ""
    var passportFileName = ""
    var billFileName = ""
    var premiseFileName = ""
    var accountFileName = ""
    var otherFileName = ""
    var drivingLicenseFileName = ""
    var councilTaxFileName = ""

    var photoFileUploadData = Data()
    var passportFileUploadData = Data()
    var billFileUploadData = Data()
    var premiseFileUploadData = Data()
    var accountFileUploadData = Data()
    var otherFileUploadData = Data()
    var drivingLicenseFileUploadData = Data()
    var councilTaxFileUploadData = Data()

    var documentType : DocumentType = .none
    var isAgreed = false
    var selectedDocumentsResponse : DocumentsDataClass?
    var customerId = ""
    var delegate : CellDelegate?
    var isDocumentUploaded = false
    var loanId = ""
    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        self.manageActionMethods()
        self.setDelegates()
        self.addObserverOnHeightTbl()
    }
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = true
        if UserDefaults.standard.value(forKey: "role") as? String != "" && isFromIncomplete {
            self.fetchUploadedDocuments()
        }

        if self.selectedDocumentsResponse != nil {
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

    class func initWithStory(loanId: String) -> DocumentUploadViewController {
       let vc : DocumentUploadViewController = UIStoryboard.Main.instantiateViewController()
        vc.loanId = loanId
       return vc
   }
    
    //---------------------------------------
    // MARK: - Custom methods
    //---------------------------------------
    func updateUI()
    {
//        self.photoFileUploadView.layer.borderWidth = 0.5
//        self.photoFileUploadView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.passportFileUploadView.layer.borderWidth = 0.5
//        self.passportFileUploadView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.billFileUploadView.layer.borderWidth = 0.5
//        self.billFileUploadView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.premiseFileUploadView.layer.borderWidth = 0.5
//        self.premiseFileUploadView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.accountFileUploadView.layer.borderWidth = 0.5
//        self.accountFileUploadView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.otherFileUploadView.layer.borderWidth = 0.5
//        self.otherFileUploadView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
        self.pageControl.numberOfPages = 9
        self.setPagNumber(currentPage: 5)
        self.selectedPhotoView.isHidden = true
        self.selectedBillView.isHidden = true
        self.selectedPremiseView.isHidden = true
        self.accountsTable.isHidden = true
        self.otherTable.isHidden = true
        self.selectedPassportView.isHidden = true
        self.selectedDrivingLicenseView.isHidden = true
        self.selectedCouncilTaxView.isHidden = true
    }
    func setDelegates()
    {
        self.otherTable.delegate = self
        self.otherTable.dataSource = self
        self.accountsTable.delegate = self
        self.accountsTable.dataSource = self
    }
    func setPagNumber(currentPage : Int) {
        self.pageControl.currentPage = currentPage
    }
    func manageActionMethods() {
        self.commentButton.addTapGestureRecognizer {
            let vc = RemarksVC.initWithStory(loanId: self.loanId)
            vc.isRemarks = false
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        self.selectedPhotoClose.addTapGestureRecognizer {
            self.photoFileUploadStr = ""
            self.selectedPhotoView.isHidden = true
            self.selectedPhotoFileName.text = ""
        }
        self.photoFileUploadButton.addTapGestureRecognizer {
            self.documentType = .Photo
            self.redirectToImageChooseVC(isPhoto: false, isUtility: false)
        }
    self.selectedPassportClose.addTapGestureRecognizer {
        self.passportFileUploadStr = ""
        self.selectedPassportView.isHidden = true
        self.selectedPassportFileName.text = ""
    }
        self.passportFileUploadButton.addTapGestureRecognizer {
            self.documentType = .Passport
            self.redirectToImageChooseVC(isPhoto: false, isUtility: false)
        }
        self.selectedDrivingLicenseClose.addTapGestureRecognizer {
            self.drivingLicenseFileUploadStr = ""
            self.selectedDrivingLicenseView.isHidden = true
            self.selectedDrivingLicenseFileName.text = ""
        }
            self.drivingLicenseFileUploadButton.addTapGestureRecognizer {
                self.documentType = .DrivingLicense
                self.redirectToImageChooseVC(isPhoto: false, isUtility: false)
            }
        self.selectedCouncilTaxClose.addTapGestureRecognizer {
            self.councilTaxFileUploadStr = ""
            self.selectedCouncilTaxView.isHidden = true
            self.selectedCouncilTaxFileName.text = ""
        }
            self.councilTaxFileUploadButton.addTapGestureRecognizer {
                self.documentType = .CouncilTax
                self.redirectToImageChooseVC(isPhoto: false, isUtility: true)
            }
    self.selectedBillClose.addTapGestureRecognizer {
        self.billFileUploadStr = ""
        self.selectedBillView.isHidden = true
        self.selectedBillFileName.text = ""
    }
        self.billFileUploadButton.addTapGestureRecognizer {
            self.documentType = .Bill
            self.redirectToImageChooseVC(isPhoto: false, isUtility: true)
        }
        self.selectedPremiseClose.addTapGestureRecognizer {
            self.premiseFileUploadStr = ""
            self.selectedPremiseView.isHidden = true
            self.selectedPremiseFileName.text = ""
        }

        self.premiseFileUploadButton.addTapGestureRecognizer {
            self.documentType = .Premise
            self.redirectToImageChooseVC(isPhoto: false, isUtility: true)
        }
    
        self.accountFileUploadButton.addTapGestureRecognizer {
            self.documentType = .Account
            self.redirectToImageChooseVC(isPhoto: false, isUtility: false)
        }
//        self.selectedOtherClose.addTapGestureRecognizer {
//            self.otherFileUploadStr = ""
//            self.selectedOtherView.isHidden = true
//            self.selectedOtherFileName.text = ""
//        }
        self.otherFileUploadButton.addTapGestureRecognizer {
            self.documentType = .Other
            self.redirectToImageChooseVC(isPhoto: false, isUtility: false)
        }
        self.agreementView.addTapGestureRecognizer {
            self.isAgreed = !self.isAgreed
            self.agreementImage.image = self.isAgreed ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
            self.agreementErrStack.isHidden = true
        }
        self.skipButton.addTapGestureRecognizer {
            if self.delegate != nil {
                self.delegate?.reload()
                self.dismiss(animated: true)
            }else{
                var vc = GuarantorDetailsViewController.initWithStory(loanId: self.loanId)
            self.navigationController?.pushViewController(vc, animated: true)

            }
        }
        self.nextButton.addTapGestureRecognizer {
            self.checkLoanStatus(loanId: self.loanId)
            if (canEditForms && GlobalmodeOfApplication != .Representative) || self.delegate != nil {
                self.isValidTextFields()
                if self.goNext() {
                    self.updateModel()
                    print("go next")
//                    var vc = GuarantorDetailsViewController.initWithStory()
//                    self.navigationController?.pushViewController(vc, animated: true)
                }}else{
//                    self.updateModel()
                    var vc = GuarantorDetailsViewController.initWithStory(loanId: self.loanId)
                self.navigationController?.pushViewController(vc, animated: true)
                }
        }
        self.backButton.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
    }
    func showModelValues() {
        var item = self.selectedDocumentsResponse
        if item?.photo != "" {
            self.selectedPhotoView.isHidden = false
            self.selectedPhotoFileName.text = URL(fileURLWithPath: item?.photo ?? "").deletingPathExtension().lastPathComponent
            self.photoFileName = URL(fileURLWithPath: item?.photo ?? "").deletingPathExtension().lastPathComponent
            self.photoFileUploadStr = item?.photo ?? ""
        }
        if item?.passport != "" {
            self.selectedPassportView.isHidden = false
            self.selectedPassportFileName.text = URL(fileURLWithPath: item?.passport ?? "").deletingPathExtension().lastPathComponent
            self.passportFileName = URL(fileURLWithPath: item?.passport ?? "").deletingPathExtension().lastPathComponent
            self.passportFileUploadStr = item?.passport ?? ""
        }
        if item?.utilityBillOfTradingBusiness != "" {
            self.selectedBillView.isHidden = false
            self.selectedBillFileName.text = URL(fileURLWithPath: item?.utilityBillOfTradingBusiness ?? "").deletingPathExtension().lastPathComponent
            self.billFileName = URL(fileURLWithPath: item?.utilityBillOfTradingBusiness ?? "").deletingPathExtension().lastPathComponent
            self.billFileUploadStr = item?.utilityBillOfTradingBusiness ?? ""
        }
        if item?.leaseDeed != "" {
            self.selectedPremiseView.isHidden = false
            self.selectedPremiseFileName.text = URL(fileURLWithPath: item?.leaseDeed ?? "").deletingPathExtension().lastPathComponent
            self.premiseFileName = URL(fileURLWithPath: item?.leaseDeed ?? "").deletingPathExtension().lastPathComponent
            self.premiseFileUploadStr = item?.leaseDeed ?? ""
        }
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
        if item?.otherFiles?.count ?? 0 > 0 {
            self.otherTable.isHidden = false
            guard let array = item?.otherFiles else{
                return
            }
            self.otherArray.removeAll()
            for element in array {
                var filename = URL(fileURLWithPath: element.file).deletingPathExtension().lastPathComponent
                var obj = UploadDocumentModel(data: Data(), fileName: filename, mimeType: "", fileType: "")
                self.otherArray.append(obj)
            }
            self.otherTable.reloadData()
        }
        if item?.drivingLicense != "" {
            self.selectedDrivingLicenseView.isHidden = false
            self.selectedDrivingLicenseFileName.text = URL(fileURLWithPath: item?.drivingLicense ?? "").deletingPathExtension().lastPathComponent
            self.drivingLicenseFileName = URL(fileURLWithPath: item?.drivingLicense ?? "").deletingPathExtension().lastPathComponent
            self.drivingLicenseFileUploadStr = item?.drivingLicense ?? ""
        }
        if item?.councilTax != "" {
            self.selectedCouncilTaxView.isHidden = false
            self.selectedCouncilTaxFileName.text = URL(fileURLWithPath: item?.councilTax ?? "").deletingPathExtension().lastPathComponent
            self.councilTaxFileName = URL(fileURLWithPath: item?.councilTax ?? "").deletingPathExtension().lastPathComponent
            self.councilTaxFileUploadStr = item?.councilTax ?? ""
        }
        if item?.documentUploadSelfDeclaration != nil {
            self.isAgreed = item?.documentUploadSelfDeclaration ?? false

            self.agreementImage.image = self.isAgreed ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")

        }
    }
    func fetchUploadedDocuments() {
        APIService.shared.retrieveDocumentsFormDetails(loanId: self.loanId) { result in
            //AppLoader.shared.removeLoader()
            switch result {
            case .success(let data):
                //                    print(data)
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedDocumentsResponse = responseData
                        self.showModelValues()
//                            let productTypeDetails = profileMasterList.objProfileList
//                            if productTypeDetails.count > 0 {
//                                let encoder = JSONEncoder()
//                                if let encoded = try? encoder.encode(productTypeDetails) {
//                                    UserDefaults.standard.setValue(encoded, forKey: "ProductTypes")
//                                }
//                            }
                    }
                    catch {
                        
                    }
                }
                else {
                    //self.showAlert(title: "Info", message: data.statusMessage)
                }
            case .failure(let error):
                //self.showAlert(title: "Info", message: error.localizedDescription)
                print(error)
            }
        }
    }
    func updateModel() {
        let model = GlobalFundingModelObject
        var initial = DocumentsModel()
        initial.photo = self.photoFileUploadStr
        initial.passport = self.passportFileUploadStr
        initial.bill = self.billFileUploadStr
        initial.premise = self.premiseFileUploadStr
        initial.account = self.accountFileUploadStr
        initial.other = self.otherFileUploadStr
        initial.councilTax = self.councilTaxFileUploadStr
        initial.drivingLicense = self.drivingLicenseFileUploadStr
        initial.isAgreed = self.isAgreed
        model.documents = initial
        
        var dataArray = [String: Any]()
        dataArray["photo"] = UploadDocumentModel(data: self.photoFileUploadData, fileName: self.photoFileName, mimeType: self.photoFileUploadMIME, fileType: self.photoFileUploadType)
        dataArray["passport"] = UploadDocumentModel(data: self.passportFileUploadData, fileName: self.passportFileName, mimeType: self.passportFileUploadMIME, fileType: self.passportFileUploadType)
        dataArray["utility_bill"] = UploadDocumentModel(data: self.billFileUploadData, fileName: self.billFileName, mimeType: self.billFileUploadMIME, fileType: self.billFileUploadType)
        dataArray["lease_deed"] = UploadDocumentModel(data: self.premiseFileUploadData, fileName: self.premiseFileName, mimeType: self.premiseFileUploadMIME, fileType: self.premiseFileUploadType)
        dataArray["business_account_statements"] = self.bankStatementArray//UploadDocumentModel(data: self.accountFileUploadData, fileName: self.accountFileName, mimeType: self.accountFileUploadMIME, fileType: self.accountFileUploadType)
        dataArray["other_files"] = self.otherArray //UploadDocumentModel(data: self.otherFileUploadData, fileName: self.otherFileName, mimeType: self.otherFileUploadMIME, fileType: self.otherFileUploadType)
        dataArray["driving_license"] = UploadDocumentModel(data: self.drivingLicenseFileUploadData, fileName: self.drivingLicenseFileName, mimeType: self.drivingLicenseFileUploadMIME, fileType: self.drivingLicenseFileUploadType)
        dataArray["council_tax"] = UploadDocumentModel(data: self.councilTaxFileUploadData, fileName: self.councilTaxFileName, mimeType: self.councilTaxFileUploadMIME, fileType: self.councilTaxFileUploadType)

        var dict = [String:Any]()
        dict["document_upload_self_declaration"] = "True"
        dict["is_identity_verified"] = "False"
        if self.isDocumentUploaded {
            self.createDocumentDetails(paramDict: dict, dataArray: dataArray)
        }else {
//            var vc = GuarantorDetailsViewController.initWithStory(loanId: self.loanId)
//            self.navigationController?.pushViewController(vc, animated: true)
            self.createDocumentDetails(paramDict: dict, dataArray: JSON())
        }
    }
    func updateFilledForms(){
        var params = JSON()
        params["complete_documents"] = "True"
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
    func createDocumentDetails(paramDict: JSON,dataArray: [String: Any]) {
        var url = APIEnums.createDocuments.rawValue
        if customerId != "" {
            url = url + "?customer_id=\(customerId)"
        }
        if loanId != "" {
            url = url + "\(loanId)/"
        }
        ConnectionHandler().uploadDocuments(wsMethod: url, paramDict: paramDict, dataArray: dataArray, viewController: self, isToShowProgress: true, isToStopInteraction: true) { response in
            if response.status_code == 200 {
                self.updateFilledForms()
                print(response)
                if self.delegate != nil {
                    self.delegate?.reload()
                    self.dismiss(animated: true)
                }else{
                    var vc = GuarantorDetailsViewController.initWithStory(loanId: self.loanId)
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            }
            else if response.status_code == 401 {
                self.tokenRefreshApi(paramDict: paramDict, dataArray: dataArray)
            }
            else{
                print(response)
            }
        }
    }
    func tokenRefreshApi(paramDict: JSON,dataArray: [String: Any]) {
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

                    self.createDocumentDetails(paramDict: paramDict, dataArray: dataArray)
                }
                else if data.statusCode == 422 {
                    UserDefaults.standard.set("", forKey:"access")
                    UserDefaults.standard.set("", forKey:"refresh")
                    UserDefaults.standard.set("", forKey:"role")
                    UserDefaults.standard.set(0, forKey:"isLogin")
                    UserDefaults.standard.set("", forKey:"email")
                    UserDefaults.standard.set("", forKey:"name")
                    UserDefaults.standard.set("", forKey:"image")
                    UserDefaults.standard.set("", forKey:"address")

                    var navigationController = UINavigationController()
                    navigationController = UINavigationController(rootViewController: HomeViewController.initWithStory())
                    sceneDelegate.window?.rootViewController = navigationController
                    sceneDelegate.window?.makeKeyAndVisible()
                    navigationController.isNavigationBarHidden = true
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
    func redirectToImageChooseVC(isPhoto: Bool,isUtility: Bool)
    {
//        guard let alertPop = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageChooseViewController") as? ImageChooseViewController else {return}
//            let rootVC = UIApplication.shared.windows.last!.rootViewController
//            rootVC?.addChild(alertPop)
//            rootVC?.view.addSubview(alertPop.view)
//            alertPop.didMove(toParent: rootVC)
//            alertPop.delegate = self
//            alertPop.modalPresentationStyle = UIModalPresentationStyle.formSheet
//            alertPop.modalTransitionStyle = .crossDissolve
        var types: [String] = [kUTTypeJPEG as String,kUTTypePNG as String]
        if !isPhoto {
            types = [kUTTypePDF as String,kUTTypeSpreadsheet as String,kUTTypeJPEG as String,kUTTypePNG as String, kUTTypeGIF as String]
        }
        if isUtility {
            types = [kUTTypePDF as String]
        }
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
        }
    func goNext() -> Bool {
//        if (self.photoFileUploadStr == "" ) {
//            return false
//        }
//
//        if (self.billFileUploadStr == "" ) {
//            return false
//        }
//        if (self.premiseFileUploadStr == "" ) {
//            return false
//        }
//        if (self.accountFileUploadStr == "" ) {
//            return false
//        }
//        if (self.otherFileUploadStr == "" ) {
//            return false
//        }
//        if (self.councilTaxFileUploadStr == "" ) {
//            return false
//        }
//        if (self.passportFileUploadStr == "" ) && (self.drivingLicenseFileUploadStr == "" ) {
//            return false
//        }
        if (self.isAgreed == false ) {
            return false
        }
        return true
    }
    func isValidTextFields() {
//        if (self.photoFileUploadStr == "") {
//            self.photoFileUploadErrStack.isHidden = false
//            self.photoFileUploadErrLabel.text = "Please choose the file"
//        }
//
//        if (self.billFileUploadStr == "" ) {
//            self.billFileUploadErrStack.isHidden = false
//            self.billFileUploadErrLabel.text = "Please choose the file"
//        }
//        if (self.premiseFileUploadStr == "" ) && GlobalFundingModelObject.tradingAddress.premiseType != "Leasehold"  {
//            self.premiseFileUploadErrStack.isHidden = false
//            self.premiseFileUploadErrLabel.text = "Please choose the file"
//        }
//        if (self.accountFileUploadStr == "" ) {
//            self.accountFileUploadErrStack.isHidden = false
//            self.accountFileUploadErrLabel.text = "Please choose the file"
//        }
//        if (self.otherFileUploadStr == "" ) {
//            self.otherFileUploadErrStack.isHidden = false
//            self.otherFileUploadErrLabel.text = "Please choose the file"
//        }
//        if (self.councilTaxFileUploadStr == "" ) {
//            self.councilTaxFileUploadErrStack.isHidden = false
//            self.councilTaxFileUploadErrLabel.text = "Please choose the file"
//        }
//        if (self.passportFileUploadStr == "" ) && (self.drivingLicenseFileUploadStr == "" ) {
////            self.passportFileUploadErrStack.isHidden = false
////            self.passportFileUploadErrLabel.text = "Please choose the file"
//            self.drivingLicenseFileUploadErrStack.isHidden = false
//            self.drivingLicenseFileUploadErrLabel.text = "Please choose the file either Passport or Driving License"
//        }
        if (self.isAgreed == false ) {
            self.agreementErrStack.isHidden = false
            self.agreementErrLabel.text = "Please agree the terms"
        }
    }
}
extension DocumentUploadViewController {
    func showImageChoices() {
        let alert = UIAlertController(title: "Choose an Option for Document image upload", message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
                DispatchQueue.main.async {
                    self.openCamera()
                }
            }))
        }
        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            DispatchQueue.main.async {
                self.requestPhotoLibraryPermission()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            print("User click Gallery button")
        }))
        
        self.present(alert, animated: true)
    }
    
    func openCamera() {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .camera
        pickerController.allowsEditing = true
        pickerController.delegate = self
        pickerController.modalPresentationStyle = .overCurrentContext
        self.present(pickerController, animated: true)
    }
    
    func openGallery() {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        pickerController.modalPresentationStyle = .overCurrentContext
        self.present(pickerController, animated: true)
    }
}
extension DocumentUploadViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    func requestPhotoLibraryPermission() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    switch status {
                    case .denied, .restricted:
                        print("No Photos Permission")
                    case .authorized, .limited:
                        DispatchQueue.main.async {
                            self.openGallery()
                        }
                        print("Photos Permission")
                    default:
                        print("Default")
                    }
                }
            } else {
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .denied, .restricted:
                        print("No Photos Permission")
                    case .authorized, .limited:
                        DispatchQueue.main.async {
                            self.openGallery()
                        }
                        print("Photos Permission")
                    default:
                        print("Default")
                    }
                }
            }
        case .denied, .restricted:
            print("No Photos Permission")
        case .authorized, .limited:
            DispatchQueue.main.async {
                self.openGallery()
            }
            print("Photos Permission")
        default:
            print("Default")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.getImageDetails(image: image, info: info)
        }
        else if let image = info[.editedImage] as? UIImage {
            self.getImageDetails(image: image, info: info)
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    func getImageDetails(image: UIImage,info: [UIImagePickerController.InfoKey : Any]) {
        var size = Float()
        var data = Data()

        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            if mediaType  == "public.image" {
                    data = image.jpegData(compressionQuality: 1.0)!
                    size = Float(Double(data.count)/1024)
                    var imageName = "Image.jpg"
                    if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                    print(url.lastPathComponent)
                    print(url.pathExtension)
                        imageName = url.lastPathComponent
                    }
                self.uploadProfileImage(image: image,imageName: imageName,imageSize: "\(size)KB")
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    func uploadProfileImage(image: UIImage,imageName: String,imageSize: String) {
        
        var imageStr = ""
        let imageData = image.jpegData(compressionQuality: 0.3)
        if let imageString = imageData?.base64EncodedString() {
            imageStr = imageString
        }
        switch self.documentType{
        case .Photo:
            self.selectedPhotoClose.isHidden = false
            self.selectedPhotoFileName.text = imageName
            self.photoFileUploadStr = imageStr
//            self.photoFileUploadButton.isHidden = true
            self.photoFileUploadErrStack.isHidden = true
        case .Passport:
            self.selectedPassportClose.isHidden = false
            self.selectedPassportFileName.text = imageName
            self.passportFileUploadStr = imageStr
//            self.passportFileUploadButton.isHidden = true
            self.passportFileUploadErrStack.isHidden = true
        case .Bill:
            self.selectedBillClose.isHidden = false
            self.selectedBillFileName.text = imageName
            self.billFileUploadStr = imageStr
//            self.billFileUploadButton.isHidden = true
            self.billFileUploadErrStack.isHidden = true
        case .Premise:
            self.selectedPremiseClose.isHidden = false
            self.selectedPremiseFileName.text = imageName
            self.premiseFileUploadStr = imageStr
//            self.premiseFileUploadButton.isHidden = true
            self.premiseFileUploadErrStack.isHidden = true
        case .Account:
//            self.selectedAccountClose.isHidden = false
//            self.selectedAccountFileName.text = imageName
//            self.accountFileUploadStr = imageStr
////            self.accountFileUploadButton.isHidden = true
//            self.accountFileUploadErrStack.isHidden = true
            break
        case .Other:
//            self.selectedOtherClose.isHidden = false
//            self.selectedOtherFileName.text = imageName
//            self.otherFileUploadStr = imageStr
////            self.otherFileUploadButton.isHidden = true
//            self.otherFileUploadErrStack.isHidden = true
            break
        case .DrivingLicense:
            self.selectedDrivingLicenseClose.isHidden = false
            self.selectedDrivingLicenseFileName.text = imageName
            self.drivingLicenseFileUploadStr = imageStr
//            self.otherFileUploadButton.isHidden = true
            self.drivingLicenseFileUploadErrStack.isHidden = true
        case .CouncilTax:
            self.selectedCouncilTaxClose.isHidden = false
            self.selectedCouncilTaxFileName.text = imageName
            self.councilTaxFileUploadStr = imageStr
//            self.otherFileUploadButton.isHidden = true
            self.councilTaxFileUploadErrStack.isHidden = true
        default: break
        }
    }

}
extension DocumentUploadViewController : ImageChooseDelegate {
    func selectedImage(type: SelectedImageType) {
        switch type {
        case .Camera:
            self.openCamera()
        case .Gallery:
            self.requestPhotoLibraryPermission()
        }
    }
}
extension DocumentUploadViewController : UIDocumentPickerDelegate {
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
                case .Photo:
                    self.selectedPhotoView.isHidden = false
                    self.selectedPhotoFileName.text = fileName + "." + fileType
                    self.photoFileName = fileName + "." + fileType
                    //self.photoFileUploadLabel.text = fileName + "." + fileType
                    self.photoFileUploadStr = fileStream
                    self.photoFileUploadData = fileData
                    self.photoFileUploadMIME = fileMIMEType
                    self.photoFileUploadType = fileType
//                    self.photoFileUploadButton.isHidden = true
                    self.photoFileUploadErrStack.isHidden = true
                case .Passport:
                    self.selectedPassportView.isHidden = false
                    self.selectedPassportFileName.text = fileName + "." + fileType
                    self.passportFileName = fileName + "." + fileType
                   // self.passportFileUploadLabel.text = fileName + "." + fileType
                    self.passportFileUploadStr = fileStream
                    self.passportFileUploadData = fileData
                    self.passportFileUploadMIME = fileMIMEType
                    self.passportFileUploadType = fileType

//                    self.passportFileUploadButton.isHidden = true
                    self.passportFileUploadErrStack.isHidden = true
                case .DrivingLicense:
                    self.selectedDrivingLicenseView.isHidden = false
                    self.selectedDrivingLicenseFileName.text = fileName + "." + fileType
                    self.drivingLicenseFileName = fileName + "." + fileType
                   // self.passportFileUploadLabel.text = fileName + "." + fileType
                    self.drivingLicenseFileUploadStr = fileStream
                    self.drivingLicenseFileUploadData = fileData
                    self.drivingLicenseFileUploadMIME = fileMIMEType
                    self.drivingLicenseFileUploadType = fileType

//                    self.passportFileUploadButton.isHidden = true
                    self.drivingLicenseFileUploadErrStack.isHidden = true
                case .CouncilTax:
                    self.selectedCouncilTaxView.isHidden = false
                    self.selectedCouncilTaxFileName.text = fileName + "." + fileType
                    self.councilTaxFileName = fileName + "." + fileType
                   // self.passportFileUploadLabel.text = fileName + "." + fileType
                    self.councilTaxFileUploadStr = fileStream
                    self.councilTaxFileUploadData = fileData
                    self.councilTaxFileUploadMIME = fileMIMEType
                    self.councilTaxFileUploadType = fileType

//                    self.passportFileUploadButton.isHidden = true
                    self.councilTaxFileUploadErrStack.isHidden = true
                case .Bill:
                    self.selectedBillView.isHidden = false
                    self.selectedBillFileName.text = fileName + "." + fileType
                  //  self.billFileUploadLabel.text = fileName + "." + fileType
                    self.billFileName = fileName + "." + fileType
                    self.billFileUploadStr = fileStream
                    self.billFileUploadData = fileData
                    self.billFileUploadMIME = fileMIMEType
                    self.billFileUploadType = fileType

//                    self.billFileUploadButton.isHidden = true
                    self.billFileUploadErrStack.isHidden = true
                case .Premise:
                    self.selectedPremiseView.isHidden = false
                    self.selectedPremiseFileName.text = fileName + "." + fileType
                  //  self.premiseFileUploadLabel.text = fileName + "." + fileType
                    self.premiseFileName = fileName + "." + fileType
                    self.premiseFileUploadStr = fileStream
                    self.premiseFileUploadData = fileData
                    self.premiseFileUploadMIME = fileMIMEType
                    self.premiseFileUploadType = fileType

//                    self.premiseFileUploadButton.isHidden = true
                    self.premiseFileUploadErrStack.isHidden = true
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
                case .Other:
                    self.otherTable.isHidden = false
//                    self.otherFileUploadStr = fileStream
                    self.otherFileUploadData = fileData
                    self.otherFileUploadMIME = fileMIMEType
                    self.otherFileUploadType = fileType
//                    self.selectedOtherFileName.text = fileName + "." + fileType
                    self.otherFileName = fileName + "." + fileType

                    var obj = UploadDocumentModel(data: self.otherFileUploadData, fileName: self.otherFileName, mimeType: self.otherFileUploadMIME, fileType: self.otherFileUploadType)
                    self.otherArray.append(obj)
                    self.otherTable.reloadData()
                  //  self.otherFileUploadLabel.text = fileName + "." + fileType
//                    self.otherFileUploadButton.isHidden = true
                    self.otherFileUploadErrStack.isHidden = true
                default: break
                }
                //            let decodeData = Data(base64Encoded: fileStream, options: .ignoreUnknownCharacters)
                //            body.append(decodeData!)
            }
            catch { }}
    }
}
extension DocumentUploadViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.otherTable {
            return self.otherArray.count
        }else if tableView == self.accountsTable {
            return self.bankStatementArray.count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "documentUploadsCell", for: indexPath) as? DocumentUploadsCell else {
            return UITableViewCell()
        }

        if tableView == self.otherTable {
            cell.fileName.text = self.otherArray.value(atSafe: indexPath.row)?.fileName
            cell.closeView.addTapGestureRecognizer {
                self.otherArray.remove(at: indexPath.row)
                self.otherTable.reloadData()
            }
        }else{
            cell.fileName.text = self.bankStatementArray.value(atSafe: indexPath.row)?.fileName
            cell.closeView.addTapGestureRecognizer {
                self.bankStatementArray.remove(at: indexPath.row)
                self.accountsTable.reloadData()
            }
        }
        
        return cell
    }
}
//MARK: -------------------------- Observers Methods --------------------------
extension DocumentUploadViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.accountsTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.accountTableHeight.constant = newvalue.height
        }
        if let obj = object as? UITableView, obj == self.otherTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.otherTableHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.accountsTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.otherTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.accountsTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        guard let tblView = self.otherTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
