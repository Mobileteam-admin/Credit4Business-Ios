//
//  ProfileVC.swift
//  Credit4Business
//
//  Created by MacMini on 17/04/24.
//

import UIKit
import Photos
import MobileCoreServices
import UniformTypeIdentifiers
import SDWebImage
import IQKeyboardManagerSwift

class ProfileVC: UIViewController, ImageChooseDelegate, ProfileChooseDelegate {
    func selectedProfile(type: SelectedProfileType) {
        switch type {
        case .ViewPhoto:
            let url = UserDefaults().profileImage
            if url != nil {
                let vc = ViewPhotoViewController.initWithStory()
                vc.strPageTitle = "Profile Picture"
                vc.strWebUrl = url
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            break
        case .UploadPhoto:
            self.redirectToUploadPhoto()
        }
    }
    
    func selectedImage(type: SelectedImageType) {
        switch type {
        case .Camera:
            self.openCamera()
        case .Gallery:
            self.requestPhotoLibraryPermission()
        }
    }
    
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var photoIDView: UIView!
    @IBOutlet weak var securityView: UIView!
    @IBOutlet weak var addressProofView: UIView!
    @IBOutlet weak var headersCollection: UICollectionView!
    @IBOutlet weak var menuTable: UITableView!

    @IBOutlet weak var documentTable: UITableView!
    @IBOutlet weak var currentPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!

    @IBOutlet weak var currentPasswordErrLabel: UILabel!
    @IBOutlet weak var currentPasswordErrStack: UIStackView!
    
    @IBOutlet weak var newPasswordErrLabel: UILabel!
    @IBOutlet weak var newPasswordErrStack: UIStackView!
    
    @IBOutlet weak var confirmPasswordErrLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrStack: UIStackView!
    
    @IBOutlet weak var changePasswordButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    var selectedDocumentIndex = 0
    
    @IBOutlet weak var profilePhotoView: UIView!
    @IBOutlet weak var personalDetailsTable: UITableView!
    @IBOutlet weak var personalDetailsView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var gocardlessButton: UIButton!
    @IBOutlet weak var signoutButton: UIButton!
    
    @IBOutlet weak var identityVerificationResentBtn: UIButton!
    @IBOutlet weak var identityVerificationView: UIView!
    @IBOutlet weak var identityVerificationSendBtn: UIButton!
    @IBOutlet weak var identityVerificationFailView: UIView!
    @IBOutlet weak var directorsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var directorsTable: UITableView!
    @IBOutlet weak var directorKycStatusLabel: UILabel!
    @IBOutlet weak var identityVerificationSuccessView: UIStackView!
    var addressArray = [MenuModel]()
    var photoIdArray = [MenuModel]()
    var insideTabNo = 1
    @IBAction func deleteButton(_ sender: Any) {
//        if self.selectedIndex == 3 {
//            self.deletePhotoIDDetails()
//        }else{
//            self.deleteAddressProofDetails()
//        }
    }
    @IBOutlet weak var applyNewFundingButton: UIButton!
    @IBOutlet weak var logoutImage: UIImageView!
    
    //MARK: -------------------- Class Variable --------------------
    var selectedPhotoIdResponse : PhotoIDDataClass?
    var paymentArray = [FundingPayment]()
    var historyArray = [FundingPaymentHistory]()
    var selectedAddressProofResponse : AddressProofDataClass?
    var selectedPersonalResponse : PersonalDataClass?
    var selectedProfileResponse : ProfileData?
    var selectedAgentProfileResponse : AgentProfileData?
    var selectedOtherResponse : OtherData?
    var selectedBankStatementResponse : BankStatementData?
    var loanModel : LoanModel?
    var personalKVArray = [MenuModel]()
    var loanKVArray = [MenuModel]()
    var changeKVArray = [MenuModel]()
    var companyKVArray = [MenuModel]()
    var isEditForDocument = false
    var viewModel = HomeVM()
    var profileMenuItems = ["Personal Details","Funding Details","Units","Identity Verification","Security","Pending Approvals"]
    var agentMenuItems = ["Personal Details","Security"]
    var selectedIndex = 0
    var currentUnitPageIndex = 1{
           didSet {
               print(currentUnitPageIndex.description)
           }
       }
       var totalUnitPages = 1{
           didSet {
               print(totalUnitPages.description)
           }
       }
       var HittedUnitPageIndex = 0
       var oneTimeForUnitHit : Bool = true
    var companyList = [CompanyList]()
    var companyObject : CompanyListModel?
    var selectedIdentityVerificationResponse: IdentityVerificationStatusModelForCustomer?
    var pendingApprovalData = [ProfileChange]()
    @IBOutlet weak var customerProfileView: UIView!
    @IBOutlet weak var unitProfileView: UIView!
    @IBOutlet weak var photoIdView: UIView!
    @IBOutlet weak var addressProofPAView: UIView!
    var tabSelected = false
    @IBOutlet weak var pendingApprovalsView: UIView!
    // MARK: - View Controller Functions
    //---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.showTable()
        self.manageActionMethods()
        self.applyNewFundingButton.isHidden = true
        self.backView.isHidden = true
        //self.personalDetailsTable.backgroundView = self.noDataFoundLabel
        self.noDataFoundLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        self.navigationController?.isNavigationBarHidden = true
        if let tabbar = self.parent?.parent as? TabBarController {
            if let navigationController = tabbar.parent as? UINavigationController {
                navigationController.isNavigationBarHidden = true
                tabbar.tabBar.isHidden = false
            }
        }
        
//        self.fetchPersonalDetails()
        if UserDefaults.standard.value(forKey: "role") as! String == "FIELDAGENT" {
            self.fetchAgentProfileDetails()
            self.gocardlessButton.isHidden = true
        }
        else {
            self.gocardlessButton.isHidden = true
            self.fetchProfileDetails()
            self.fetchLoanDetails()
            self.currentUnitPageIndex = 0
            self.HittedUnitPageIndex = 0

        }
        self.userLocationLabel.text = UserDefaults().profileAddress
        self.userNameLabel.text = UserDefaults().profileName
        self.identityVerificationView.isHidden = true
        self.identityVerificationSuccessView.isHidden = true
        self.directorKycStatusLabel.isHidden = true
    }
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    func setDelegates() {

        self.headersCollection.dataSource = self
        self.headersCollection.delegate = self
        self.menuTable.delegate = self
        self.menuTable.dataSource = self
        self.directorsTable.delegate = self
        self.directorsTable.dataSource = self
        self.documentTable.dataSource = self
        self.documentTable.delegate = self
        self.personalDetailsTable.delegate = self
        self.personalDetailsTable.dataSource = self
        self.addObserverOnHeightTbl()
        self.viewModel.paymentArray.removeAll()
        var paymentHistory = PaymentHistoryModel()
        paymentHistory.isExtended = false
        var payments = [PaymentModel]()
        for i in 0...3 {
            var obj = PaymentModel()
            obj.amount = "£100.00"
            obj.date = "Oct 22"
            if i == 2 || i == 3 {
                obj.description = "Credit card Payment"
            }
            if i == 0 {
                obj.description = "Via Payment Gateway"
            }
            if i == 1 {
                obj.description = "Through Collection Agent"
            }
            payments.append(obj)
        }
        paymentHistory.payments = payments
        self.viewModel.paymentArray.append(paymentHistory)
//        self.viewModel.documentArray.removeAll()
//        for i in 0...1 {
//            var model = DocumentModel()
//            model.isSelected = false
//            model.type = i == 0 ? "Passport" : "Driving License"
//            model.apiKey = i == 0 ? "passport" : "driving_license"
//            self.viewModel.documentArray.append(model)
//        }
        
        
        self.currentPasswordTF.delegate = self
        self.newPasswordTF.delegate = self
        self.confirmPasswordTF.delegate = self
        self.currentPasswordTF.isSecureTextEntry = true
        self.newPasswordTF.isSecureTextEntry = true
        self.confirmPasswordTF.isSecureTextEntry = true
    }
    func showTable() {
        self.pendingApprovalsView.isHidden = true
        self.menuTable.isHidden = true
        self.addressProofView.isHidden = true
        self.securityView.isHidden = true
        self.photoIDView.isHidden = true
    }
    func goNext() -> Bool {
       
        if (self.currentPasswordTF.text == nil || self.currentPasswordTF.text == "") {
            return false
        }
        if (self.newPasswordTF.text == nil || self.newPasswordTF.text == "") {
            return false
        }
        if (self.confirmPasswordTF.text == nil || self.confirmPasswordTF.text == "") {
            return false
        }
        if self.newPasswordTF.text != self.confirmPasswordTF.text {
            return false
        }
        return true
    }
    func isValidTextFields() {
        if (self.currentPasswordTF.text == nil || self.currentPasswordTF.text == "") {
            self.currentPasswordErrStack.isHidden = false
            self.currentPasswordErrLabel.text = "Please enter current Password"
        }
        if (self.newPasswordTF.text == nil || self.newPasswordTF.text == "") {
            self.newPasswordErrStack.isHidden = false
            self.newPasswordErrLabel.text = "Please enter new Password"
        }
        if (self.confirmPasswordTF.text == nil || self.confirmPasswordTF.text == "") {
            self.confirmPasswordErrStack.isHidden = false
            self.confirmPasswordErrLabel.text = "Please enter confirm Password"
        }
        if self.newPasswordTF.text != self.confirmPasswordTF.text {
            self.confirmPasswordErrStack.isHidden = false
            self.confirmPasswordErrLabel.text = "New and confirm passwords should be same"
        }
        
    }
    func manageActionMethods() {
        self.backImage.addTapGestureRecognizer {
            self.personalDetailsView.isHidden = true
            self.pendingApprovalsView.isHidden = false
        }
        self.customerProfileView.addTapGestureRecognizer {
            self.pendingApprovalsView.isHidden = true
//            self.personalDetailsView.isHidden = false
            self.fetchPendingApprovalDetails(type: "Customer Profile")
            self.insideTabNo = 1
            self.backView.isHidden = false

        }
        self.unitProfileView.addTapGestureRecognizer {
            self.pendingApprovalsView.isHidden = true
//            self.personalDetailsView.isHidden = false
            self.fetchPendingApprovalDetails(type: "Unit Profile")
            self.insideTabNo = 2
            self.backView.isHidden = false
        }
        self.photoIdView.addTapGestureRecognizer {
            self.pendingApprovalsView.isHidden = true
//            self.personalDetailsView.isHidden = false
            self.fetchPendingApprovalDetails(type: "Photo Id")
            self.insideTabNo = 4
            self.backView.isHidden = false
        }
        self.addressProofPAView.addTapGestureRecognizer {
            self.pendingApprovalsView.isHidden = true
//            self.personalDetailsView.isHidden = false
            self.fetchPendingApprovalDetails(type: "Address Proof")
            self.insideTabNo = 3
            self.backView.isHidden = false
        }
        self.gocardlessButton.addTapGestureRecognizer {
            let vc = GocartlessViewController.initWithStory(loanId: "")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.signoutButton.addTapGestureRecognizer {
            self.logoutAPIDetails()
        }
        self.applyNewFundingButton.addTapGestureRecognizer {
            self.showAlertWithAction(title: "Confirm New Funding Application", message: "Are you sure you want to proceed with applying for new funding?")
        }
        self.changePasswordButton.addTapGestureRecognizer {
                self.isValidTextFields()
                if self.goNext() {
                    var dicts = JSON()
                    dicts["new_password"] = String(format:"%@",self.newPasswordTF.text!)
                    dicts["old_password"] = String(format:"%@",self.currentPasswordTF.text!)
                    self.callChangePasswordAPI(parms: dicts)
                    print("go next")
                }
        }
        self.editButton.addTapGestureRecognizer {
            if self.selectedIndex == 0 {
                let vc = EditProfileVC.initWithStory()
                vc.delegate = self
                if self.personalKVArray.count > 0 {
                    vc.personalKVArray = self.personalKVArray
                }
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }else{
                self.isEditForDocument = true
                self.documentTable.reloadData()
            }
           
        }
        self.backButton.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        self.submitButton.addTapGestureRecognizer {
        }
        self.profilePhotoView.addTapGestureRecognizer {
            let vc = ProfilePhotoUploadPopupVC.initWithStory()
            vc.delegate = self
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true)
        }
        self.identityVerificationSendBtn.addTapGestureRecognizer {
            self.createIdentityDetails()
            self.identityVerificationSendBtn.isHidden = true
            self.identityVerificationResentBtn.isHidden = false
        }
        self.identityVerificationResentBtn.addTapGestureRecognizer {
            self.createIdentityDetails()
        }
    }
    func createModelArrayForAddressProof(selectedProfile: ProfileChange) {
        self.addressArray.removeAll()
        if selectedProfile.addressProof != nil {
            switch selectedProfile.addressProof {
            case .addressProofClass(let x):
                if x.councilTax != "" {
                    let photo = MenuModel.init(title: "Council Tax", value: x.councilTax , apiKey: "")
                    self.addressArray.append(photo)
                }
//                if x.unit != "" || x.unit == ""{
//                    let photo = MenuModel.init(title: "Unit", value: x.unit, apiKey: "")
//                    self.addressArray.append(photo)
//                }
                if x.utilityBill != "" {
                    let photo = MenuModel.init(title: "Latest Utility bill of Trading Business", value: x.utilityBill, apiKey: "")
                    self.addressArray.append(photo)
                }
                if x.leaseDeed != "" {
                    let photo = MenuModel.init(title: "Business premises lease deed", value: x.leaseDeed , apiKey: "")
                    self.addressArray.append(photo)
                }
            default:
                break
            }
            
            self.personalDetailsTable.reloadData()
        }
        
    }
    func createModelArrayForPhotoId(selectedProfile: ProfileChange) {
        self.photoIdArray.removeAll()
        if selectedProfile.photoID != nil {
            switch selectedProfile.photoID {
            case .photoID(let x):
                if x.photo != "" {
                    let photo = MenuModel.init(title: "Photo", value: x.photo , apiKey: "")
                    self.photoIdArray.append(photo)
                }
                
                if x.passport != "" {
                    let photo = MenuModel.init(title: "Passport", value: x.passport, apiKey: "")
                    self.photoIdArray.append(photo)
                }
                if x.drivingLicense != "" {
                    let photo = MenuModel.init(title: "Driving License", value: x.drivingLicense , apiKey: "")
                    self.photoIdArray.append(photo)
                }
            default:
                break
            }
            
            self.personalDetailsTable.reloadData()
        }
        
    }
    func fetchPendingApprovalDetails(type: String) {
        var typeChange = type.trim().lowercased().replacingOccurrences(of: " ", with: "_")
        APIService.shared.retrievePendingApprovalDetails(type: typeChange,customerId: self.selectedProfileResponse?.id ?? "") { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data
                        self.pendingApprovalData = responseData.data
                        self.personalDetailsView.isHidden = false
                        if self.pendingApprovalData.count == 0 {
                            self.noDataFoundLabel.isHidden = false
                        }else {
                            self.noDataFoundLabel.isHidden = true
                        }
                        self.personalDetailsTable.reloadData()
                        //self.createModelArrayForLoan()
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
    func fetchLoanDetails() {
        APIService.shared.retrieveLoanDetails() { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data
                        self.loanModel = responseData
                        globalLoanModel = self.loanModel
                        if self.loanModel?.data.count != 0 {
                            self.applyNewFundingButton.isHidden = self.selectedIndex == 1 ? false : true
                            for element in self.loanModel!.data {
                                for loan in element.customer.loanDetails {
                                    
                                    if loan.currentStatus.lowercased() != "submitted"{
                                        self.applyNewFundingButton.isHidden = true
                                    }
                                }
                            }
                        }
                        
                        //self.createModelArrayForLoan()
                        self.personalDetailsTable.reloadData()
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
    func tokenRefreshApi(paramDict: JSON,dataArray: [String: Any],isLogout : Bool) {
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

                    if isLogout {
                        self.logoutAPIDetails()
                    }else{
                       // self.createDocumentDetails(api: self.selectedIndex == 3 ? APIEnums.createPhotoId : APIEnums.createAddressProof, paramDict: paramDict, dataArray: dataArray)
                    }
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
    func callChangePasswordAPI(parms: [AnyHashable: Any]){
        self.viewModel
            .ChangePasswordApicall(parms: parms){(result) in
                switch result{
                case .success:
//                    self.sendOTPTapped()
                    self.showAlert(title: "Info", message: "Password Changed successfully")
                    self.selectedIndex = 0
                    self.showTable()
                case .failure(let error):
                    self.showAlert(title: "Info", message: error.localizedDescription)
                    break
                }
            }
    }
   
    func createModelArrayForChanges(selectedProfile: ProfileChange) {
        self.changeKVArray.removeAll()
        if selectedProfile.changes.title != "" && selectedProfile.changes.title != nil {
            let status = MenuModel.init(title: "Title", value: selectedProfile.changes.title ?? "", apiKey: "")
            self.changeKVArray.append(status)
        }
        if selectedProfile.changes.description != "" && selectedProfile.changes.description != nil {
            let status = MenuModel.init(title: "Description", value: selectedProfile.changes.description ?? "", apiKey: "")
            self.changeKVArray.append(status)
        }
        if selectedProfile.changes.dateOfBirth != "" && selectedProfile.changes.dateOfBirth != nil {
            let status = MenuModel.init(title: "Date Of Birth", value: selectedProfile.changes.dateOfBirth ?? "", apiKey: "")
            self.changeKVArray.append(status)
        }
        if selectedProfile.changes.companyName != "" && selectedProfile.changes.companyName != nil {
            let status = MenuModel.init(title: "Company Name", value: selectedProfile.changes.companyName ?? "", apiKey: "")
            self.changeKVArray.append(status)
        }
        if selectedProfile.changes.companyStatus != "" && selectedProfile.changes.companyStatus != nil {
            let status = MenuModel.init(title: "Company Status", value: selectedProfile.changes.companyStatus ?? "", apiKey: "")
            self.changeKVArray.append(status)
        }
        if selectedProfile.changes.businessType != "" && selectedProfile.changes.businessType != nil {
            let status = MenuModel.init(title: "Business Type", value: selectedProfile.changes.businessType ?? "", apiKey: "")
            self.changeKVArray.append(status)
        }
        if selectedProfile.changes.tradingStyle != "" && selectedProfile.changes.tradingStyle != nil {
            let status = MenuModel.init(title: "Business / Shop Name", value: selectedProfile.changes.tradingStyle ?? "", apiKey: "")
            self.changeKVArray.append(status)
        }
        if selectedProfile.changes.fundingPurpose != "" && selectedProfile.changes.fundingPurpose != nil {
            let status = MenuModel.init(title: "Funding Purpose", value: selectedProfile.changes.fundingPurpose ?? "", apiKey: "")
            self.changeKVArray.append(status)
        }
        if self.changeKVArray.count > 0 || self.personalKVArray.count > 0 || self.companyKVArray.count > 0 {
            self.personalDetailsTable.reloadData()
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
        self.personalKVArray.append(email)
        self.personalKVArray.append(name)
        self.personalKVArray.append(dob)
        self.personalKVArray.append(pincode)
        self.personalKVArray.append(address)
        self.personalKVArray.append(phone)
        self.personalKVArray.append(amount)
        self.personalKVArray.append(duration)
    }
    func fetchCompanyListDetails() {
        var page = self.currentUnitPageIndex+1
              guard  self.HittedUnitPageIndex != self.currentUnitPageIndex + 1 else {
                  return
              }
        
        var urlStr = APIEnums.retrieveCompanies.rawValue + "?customer_id=\(self.selectedProfileResponse?.id ?? "")"
        if page != 1 {
            urlStr = urlStr + "?page=\(page)"
        }
        APIService.shared.retrieveCompanyListDetails(url: urlStr) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.companyObject = data
                        self.companyList = responseData
                        let next = self.getQueryItems(data.next)
                        let last = self.getQueryItems(data.last)
                        let Lastitem = last.filter({$0.key == "page"}).first?.value
                        let currentItem = next.filter({$0.key == "page"}).first?.value

                        self.totalUnitPages = (Lastitem?.toInt() ?? 0)
                        self.currentUnitPageIndex = (currentItem?.toInt() ?? 0) - 1
                        self.HittedUnitPageIndex = (currentItem?.toInt() ?? 0) - 1
                        self.personalDetailsTable.reloadData()                    }
                    catch {
                        
                    }
                    self.oneTimeForUnitHit = true
                }
                else {
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func applyNewLoan() {
        APIService.shared.applyNewLoan() { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.fetchLoanDetails()
                    }
                    catch {
                        
                    }
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
    func fetchProfileDetails() {
        APIService.shared.retrieveProfileDetails() { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedProfileResponse = responseData
                        if self.selectedProfileResponse?.image != "" {
                            self.userImageView.sd_setImage(with: URL(string: self.selectedProfileResponse?.image ?? ""))
                            UserDefaults.standard.set(self.selectedProfileResponse?.image, forKey: "image")
                            if let tabbar = self.parent?.parent as? TabBarController {
                                if let navigationController = tabbar.parent as? UINavigationController {
                                    tabbar.setUserProfileImageOnTabbar()
                                }
                            }
                        }
                        if self.selectedProfileResponse?.address != "" {
                            UserDefaults.standard.set(self.selectedProfileResponse?.address ?? "", forKey:"address")
                            self.userLocationLabel.text = UserDefaults().profileAddress
                            self.userNameLabel.text = UserDefaults().profileName

                        }
                        self.userNameLabel.text = (self.selectedProfileResponse?.firstName ?? "") + " " + (self.selectedProfileResponse?.lastName ?? "")
                        UserDefaults().profileName = self.userNameLabel.text ?? ""
                        self.createModelArrayForProfile()
                        self.fetchCompanyListDetails()
                        self.personalDetailsTable.reloadData()
//                        if self.selectedProfileResponse?.gocardlessStatus ?? false {
//                            self.gocardlessButton.isUserInteractionEnabled = false
//                            self.gocardlessButton.alpha = 0.5
//                        }else{
//                            self.gocardlessButton.isUserInteractionEnabled = true
//                            self.gocardlessButton.alpha = 1
//                        }
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
    func fetchAgentProfileDetails() {
        APIService.shared.retrieveAgentProfileDetails() { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedAgentProfileResponse = responseData
                        if self.selectedAgentProfileResponse?.image != "" {
                            self.userImageView.sd_setImage(with: URL(string: self.selectedAgentProfileResponse?.image ?? ""))
                            UserDefaults.standard.set(self.selectedAgentProfileResponse?.image, forKey: "image")
                            if let tabbar = self.parent?.parent as? TabBarController {
                                if let navigationController = tabbar.parent as? UINavigationController {
                                    tabbar.setUserProfileImageOnTabbar()
                                }
                            }
                        }
                        if self.selectedAgentProfileResponse?.address != "" {
                            UserDefaults.standard.set(self.selectedAgentProfileResponse?.address ?? "", forKey:"address")
                            self.userLocationLabel.text = UserDefaults().profileAddress
                            self.userNameLabel.text = UserDefaults().profileName
                        }
                        self.userNameLabel.text = (self.selectedAgentProfileResponse?.firstName ?? "") + " " + (self.selectedAgentProfileResponse?.lastName ?? "")
                        UserDefaults().profileName = self.userNameLabel.text ?? ""
                        self.createModelArrayForProfile()
                        self.personalDetailsTable.reloadData()
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
    func createModelArrayForCompany(selectedProfile: ProfileChange) {
        self.companyKVArray.removeAll()
        let name = MenuModel.init(title: "Company Name", value: selectedProfile.company?.companyName ?? "", apiKey: "")
        let id = MenuModel.init(title: "ID", value: selectedProfile.company?.id ?? "", apiKey: "")
        let status = MenuModel.init(title: "Company Status", value: selectedProfile.company?.companyStatus ?? "", apiKey: "")
        let number = MenuModel.init(title: "Company Number", value: selectedProfile.company?.companyNumber ?? "", apiKey: "")
        let businessType = MenuModel.init(title: "Business Type", value: selectedProfile.company?.businessType ?? "", apiKey: "")
        let tradingStyle = MenuModel.init(title: "Business / Shop Name", value: selectedProfile.company?.tradingStyle ?? "", apiKey: "")
        let fundingPurpose = MenuModel.init(title: "Funding Purpose", value: selectedProfile.company?.fundingPurpose ?? "", apiKey: "")
        let otherPurpose = MenuModel.init(title: "Other Funding Purpose", value: selectedProfile.company?.otherFundingPurpose ?? "", apiKey: "")


        self.companyKVArray.append(name)
        self.companyKVArray.append(id)
        self.companyKVArray.append(status)
        self.companyKVArray.append(number)
        self.companyKVArray.append(businessType)
        self.companyKVArray.append(tradingStyle)
        self.companyKVArray.append(fundingPurpose)
        if selectedProfile.company?.otherFundingPurpose != "" {
            self.companyKVArray.append(otherPurpose)
        }
    }
    func createModelArrayForProfile() {
        self.personalKVArray.removeAll()
        if UserDefaults.standard.value(forKey: "role") as! String == "FIELDAGENT" {
            let fname = MenuModel.init(title: "First Name", value: self.selectedAgentProfileResponse?.firstName ?? "",apiKey: "first_name")
            let lname = MenuModel.init(title: "Last Name", value: self.selectedAgentProfileResponse?.lastName ?? "",apiKey: "last_name")
            let phone = MenuModel.init(title: "Phone Number", value: self.selectedAgentProfileResponse?.phoneNumber ?? "",apiKey: "phone_number")
            let email = MenuModel.init(title: "Email", value: self.selectedAgentProfileResponse?.email ?? "",apiKey: "email")
            let location = MenuModel.init(title: "Address", value: self.selectedAgentProfileResponse?.address ?? "",apiKey: "address")
            let description = MenuModel.init(title: "Description", value: self.selectedAgentProfileResponse?.description ?? "",apiKey: "description")
            let agent = MenuModel.init(title: "Assigned Manager", value: self.selectedAgentProfileResponse?.assignedManager?.description ?? "",apiKey: "assigned_manager")

            self.personalKVArray.append(fname)
            self.personalKVArray.append(lname)
            self.personalKVArray.append(phone)
            self.personalKVArray.append(email)
            self.personalKVArray.append(location)
            self.personalKVArray.append(description)
            self.personalKVArray.append(agent)
        }else{
            let fname = MenuModel.init(title: "First Name", value: self.selectedProfileResponse?.firstName ?? "",apiKey: "first_name")
            let lname = MenuModel.init(title: "Last Name", value: self.selectedProfileResponse?.lastName ?? "",apiKey: "last_name")

            let phone = MenuModel.init(title: "Phone Number", value: self.selectedProfileResponse?.phoneNumber ?? "",apiKey: "phone_number")
            let email = MenuModel.init(title: "Email", value: self.selectedProfileResponse?.email ?? "",apiKey: "email")
            let gender = MenuModel.init(title: "Gender", value: self.selectedProfileResponse?.gender ?? "",apiKey: "gender")
            let dob = MenuModel.init(title: "Date Of Birth", value: self.selectedProfileResponse?.dateOfBirth ?? "",apiKey: "date_of_birth")
            let businessName = MenuModel.init(title: "Company Name", value: self.selectedProfileResponse?.companyName ?? "",apiKey: "company_name")
            let location = MenuModel.init(title: "Location", value: self.selectedProfileResponse?.address ?? "",apiKey: "address")
            let description = MenuModel.init(title: "Description", value: self.selectedProfileResponse?.description ?? "",apiKey: "description")
            let agent = MenuModel.init(title: "Agent", value: self.selectedProfileResponse?.agent.description ?? "",apiKey: "agent")

            self.personalKVArray.append(fname)
            self.personalKVArray.append(lname)
            self.personalKVArray.append(phone)
            self.personalKVArray.append(email)
            self.personalKVArray.append(gender)
            self.personalKVArray.append(dob)
            self.personalKVArray.append(businessName)
            self.personalKVArray.append(location)
            self.personalKVArray.append(description)
           // self.personalKVArray.append(agent)
        }
        

    }
    func logoutAPIDetails() {
        APIService.shared.makeRequest(endpoint: APIEnums.logout.rawValue,
                                      withLoader: true,
                                      method: .post,
                                      params: JSON()) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
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
                else if data.statusCode == 401 {
                    self.tokenRefreshApi(paramDict: JSON(), dataArray: [String : Any](),isLogout: true)
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
        APIService.shared.makeRequest(endpoint: APIEnums.createIdentityFromCustomer.rawValue + "\(self.selectedProfileResponse?.id ?? "")/",
                                      withLoader: true,
                                      method: .post,
                                      params: JSON()) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
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
    func fetchIdentityVerificationStatus() {
        APIService.shared.retrieveIdentityVerificationStatus(customerId: self.selectedProfileResponse?.id ?? "" ) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedIdentityVerificationResponse = data
                        if self.selectedIdentityVerificationResponse?.data.kycStatus == true {
                            self.identityVerificationFailView.isHidden = true
                            self.identityVerificationSuccessView.isHidden = false
                            self.directorsTable.isHidden = false
                            self.directorKycStatusLabel.isHidden = false
                            self.directorsTable.reloadData()
                        }else{
                            self.identityVerificationFailView.isHidden = false
                            self.identityVerificationSuccessView.isHidden = true
                            self.directorsTable.isHidden = true
                            self.directorKycStatusLabel.isHidden = true
                        }
//                        if self.selectedIdentityVerificationResponse?.data.kycStatus == true {
//                            self.identityVerificationFailView.isHidden = true
//                            self.identityVerificationSuccessView.isHidden = false
//                            self.directorsTable.isHidden = false
//                            self.directorKycStatusLabel.isHidden = false
//                            self.directorsTable.reloadData()
//                        }else{
//                            self.identityVerificationFailView.isHidden = false
//                            self.identityVerificationSuccessView.isHidden = true
//                            self.directorsTable.isHidden = true
//                            self.directorKycStatusLabel.isHidden = true
//                        }
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
    func showAlertWithAction(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default,handler: { okay in
            self.applyNewLoan()
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .default,handler: { okay in
            self.dismiss(animated: true)
        }))
        self.present(alertController, animated: true)
    }
    //---------------------------------------
    // MARK: - Init With Story
    //---------------------------------------

    class func initWithStory() -> ProfileVC {
        let vc : ProfileVC = UIStoryboard.Login.instantiateViewController()
        return vc
    }
}
extension ProfileVC : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UserDefaults.standard.value(forKey: "role") as! String == "FIELDAGENT" {
            return self.agentMenuItems.count
        }else{
            return self.profileMenuItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCollectionViewCell",
                                                      for: indexPath) as! ProfileCollectionViewCell
        var model = self.profileMenuItems.value(atSafe: indexPath.row)
        if UserDefaults.standard.value(forKey: "role") as! String == "FIELDAGENT" {
            model = self.agentMenuItems.value(atSafe: indexPath.row)
        }
        cell.titleLabel.text = model
        
        cell.separatorLabel.isHidden = self.selectedIndex == indexPath.row ? false : true
        cell.addTapGestureRecognizer {
            self.selectedIndex = indexPath.row
            self.headersCollection.reloadData()
            self.pendingApprovalsView.isHidden = true

            //            switch self.selectedIndex {
            self.tabSelected = false
            if cell.titleLabel.text == "Personal Details" ||  cell.titleLabel.text == "Funding Details" || cell.titleLabel.text == "Units" {
                
                self.menuTable.isHidden = true
                self.addressProofView.isHidden = true
                self.securityView.isHidden = true
                self.photoIDView.isHidden = true
                self.personalDetailsView.isHidden = false
                self.editButton.isHidden = false
                self.identityVerificationView.isHidden = true
                self.applyNewFundingButton.isHidden = true
                self.backView.isHidden = true
                if cell.titleLabel.text == "Funding Details" {
                    self.fetchLoanDetails()
                    self.applyNewFundingButton.isHidden = false
                }
                self.personalDetailsTable.reloadData()
            }
            else if cell.titleLabel.text == "Security" {
                self.editButton.isHidden = true
                self.menuTable.isHidden = true
                self.addressProofView.isHidden = true
                self.securityView.isHidden = false
                self.photoIDView.isHidden = true
                self.personalDetailsView.isHidden = true
                self.identityVerificationView.isHidden = true

            }
            else if cell.titleLabel.text == "Identity Verification" {
                self.editButton.isHidden = true
                self.menuTable.isHidden = true
                self.addressProofView.isHidden = true
                self.securityView.isHidden = true
                self.photoIDView.isHidden = true
                self.personalDetailsView.isHidden = true
                self.identityVerificationView.isHidden = false
                self.identityVerificationSendBtn.isHidden = false
                self.identityVerificationResentBtn.isHidden = true
                self.fetchIdentityVerificationStatus()

            }
            else if cell.titleLabel.text?.contains("Approvals") ?? false {
                self.editButton.isHidden = true
                self.menuTable.isHidden = true
                self.addressProofView.isHidden = true
                self.securityView.isHidden = true
                self.photoIDView.isHidden = true
                self.personalDetailsView.isHidden = true
                self.identityVerificationView.isHidden = true
                self.pendingApprovalsView.isHidden = false

//                self.fetchPendingApprovalDetails(type: cell.titleLabel.text?.replacingOccurrences(of: "Approvals", with: "") ?? "")
            }
            
        }
        return cell
    }
    
    
}
extension ProfileVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == menuTable {
            var count = 0
            if self.paymentArray.count > 0 {
                count = count + 1
            }
            if self.historyArray.count > 0 {
                count = count + 1
            }
            return count
        }
        else {
            if tableView == personalDetailsTable && tabSelected && ((self.selectedIndex == 5 && self.insideTabNo == 1) || (self.selectedIndex == 5 && self.insideTabNo == 2)) {
                return 2
            }
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch tableView {
        case menuTable:
//            if section == 0 {
//                count = self.paymentArray.count
//            }else{
//                count = 1
//            }
            break
        case documentTable:
//            switch selectedIndex {
//            case 3:
//                count = self.viewModel.documentArray.count
//            case 4:
//                count = self.viewModel.documentArray2.count
//            case 5:
//                count = self.viewModel.otherArray.count
//            case 6:
//                count = self.viewModel.statementArray.count
//            default:
//                break
//            }
            break
        case personalDetailsTable:
            if selectedIndex == 0 {
                count = self.personalKVArray.count
            }
            else if selectedIndex == 1 {
                count = self.loanModel?.data.count ?? 0 //self.loanKVArray.count
            }
            else if selectedIndex == 2 {
                count = self.companyList.count
            }else{
                if tabSelected {
                    if selectedIndex == 5 && self.insideTabNo == 3 {
                        count = self.addressArray.count
                    }
                    else if self.selectedIndex == 5 && self.insideTabNo == 4{
                        count = self.photoIdArray.count
                    }
                    else if self.selectedIndex == 5 && self.insideTabNo == 1 {
                        count = section == 0 ? self.personalKVArray.count : self.changeKVArray.count
                    }
                    else if self.selectedIndex == 5 && self.insideTabNo == 2 {
                        count = section == 0 ? self.companyKVArray.count : self.changeKVArray.count
                    }
                }else {
                    count = self.pendingApprovalData.count
                }
            }
        case directorsTable:
            count = self.selectedIdentityVerificationResponse != nil ? 1 : 0
        default:
            count = 0
        }
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == personalDetailsTable {
                
            if self.selectedIndex == 0 {
                guard let cellnew = tableView.dequeueReusableCell(withIdentifier: "leadsDetailsCell", for: indexPath) as? LeadsDetailsCell else {
                    return UITableViewCell()
                }
                cellnew.titleLabel.text = self.personalKVArray.value(atSafe: indexPath.row)?.title
                cellnew.valueLabel.text = self.personalKVArray.value(atSafe: indexPath.row)?.value
                return cellnew
            } else if self.selectedIndex == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "leadsCell2", for: indexPath) as? LeadsCell else {
                    return UITableViewCell()
                }
//                cell.titleLabel.text = self.loanKVArray.value(atSafe: indexPath.row)?.title
//                cell.valueLabel.text = self.loanKVArray.value(atSafe: indexPath.row)?.value
                var model = self.loanModel?.data.value(atSafe: indexPath.row)
                cell.leadsName.text = model?.customer.companyName
                if model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.currentStatus != "" {
                    var color = "yellow"
                    if model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.currentStatus == "Admin_Cash_Disbursed" {
                        color = "green"
                    }else if model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.currentStatus.lowercased().contains("rejected") ?? false || model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.currentStatus.lowercased().contains("returned") ?? false {
                        color = "red"
                    }
                    // cell.loanStatusButton.isHidden = false
                    let attributedTitle = NSMutableAttributedString(string: model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.currentStatus ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: color)])
                    cell.loanStatusButton.backgroundColor = UIColor(named: color)?.withAlphaComponent(0.4)

                    cell.loanStatusButton.setAttributedTitle(attributedTitle, for: .normal)
                }else{
                    //cell.loanStatusButton.isHidden = true
                }
                
                //cell.requestedDateLabel.text = "23-08-2024"//model?.appliedDate ?? ""
                cell.dateStack.isHidden = true
                cell.leadsName.accessibilityHint = model?.id ?? ""
                return cell
            }
            else if selectedIndex == 2 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "leadsCell", for: indexPath) as? LeadsCell else {
                    return UITableViewCell()
                }

                var model = self.companyList.value(atSafe: indexPath.row)
                cell.leadsName.text = (self.companyList.value(atSafe: indexPath.row)?.companyName ?? "")
                cell.loanStatusButton.setTitle(model?.companyStatus ?? "", for: .normal)
                if model?.companyStatus != "" {
                    let attributedTitle = NSMutableAttributedString(string: model?.companyStatus ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: "yellow")])

                    cell.loanStatusButton.setAttributedTitle(attributedTitle, for: .normal)
                }
                
                cell.leadsName.accessibilityHint = model?.id ?? ""

                return cell
            }else{
                if tabSelected {
                    if self.selectedIndex == 5 && self.insideTabNo == 1 {
                            guard let cellnew = tableView.dequeueReusableCell(withIdentifier: "leadsDetailsCell", for: indexPath) as? LeadsDetailsCell else {
                                return UITableViewCell()
                            }
                        var array = indexPath.section == 0 ? self.personalKVArray : self.changeKVArray
                            cellnew.titleLabel.text = array.value(atSafe: indexPath.row)?.title
                            cellnew.valueLabel.text = array.value(atSafe: indexPath.row)?.value
                            return cellnew
                    }
                    else if self.selectedIndex == 5 && self.insideTabNo == 2 {
                            guard let cellnew = tableView.dequeueReusableCell(withIdentifier: "leadsDetailsCell", for: indexPath) as? LeadsDetailsCell else {
                                return UITableViewCell()
                            }
                        var array = indexPath.section == 0 ? self.companyKVArray : self.changeKVArray
                            cellnew.titleLabel.text = array.value(atSafe: indexPath.row)?.title
                            cellnew.valueLabel.text = array.value(atSafe: indexPath.row)?.value
                            return cellnew
                    }
                    else{
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: "documentTableViewCell", for: indexPath) as? DocumentTableViewCell else {
                            return UITableViewCell()
                        }
                        cell.selectedFileView.isHidden = false
                        cell.uploadView.isHidden = true
                        var path = ""
                        var model = self.insideTabNo == 3 ? self.addressArray.value(atSafe: indexPath.row) : self.photoIdArray.value(atSafe: indexPath.row)
                        cell.fileTypeLabel.text = model?.title
                        cell.selectedFileName.text = model?.value
                       path = model?.value ?? ""
                       if path != "" && path != nil {
                           let fileName = URL(fileURLWithPath: path ).deletingPathExtension().lastPathComponent
                           cell.selectedFileName.text = fileName
                       }
                        cell.selectedViewButton.addTapGestureRecognizer {
                            var vc = WebViewController.initWithStory()
                            vc.strPageTitle = "Document"
                            vc.strWebUrl = model?.value ?? ""
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        return cell
                    }
                   
                }else{
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "pendingRequestCell2", for: indexPath) as? LeadsCell else {
                        return UITableViewCell()
                    }

                    var model = self.pendingApprovalData.value(atSafe: indexPath.row)
    //                cell.addressProofChangesStack.isHidden = model?.addressProofChanges.count == 0
    //                cell.addressProofSeparator.isHidden = model?.addressProofChanges.count == 0
    //                cell.profileChangesStack.isHidden = model?.profileChanges.count == 0
    //                cell.profileChangesSeparator.isHidden = model?.profileChanges.count == 0
    //                cell.photoIdChangesStack.isHidden = model?.photoIDChanges.count == 0
                    cell.leadsName.text = "ID"
                    cell.leadsPhone.text = model?.id
                    let attributedTitle = NSMutableAttributedString(string: model?.isAdminApproved ?? false ? "Approved" : (model?.isAdminReject ?? false ? "Rejected" : "Pending"), attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: "blue")])

                    cell.loanStatusButton.setAttributedTitle(attributedTitle, for: .normal)
                    
    //                cell.addressProofChangeStatusLabel.text = model?.addressProofChanges.first?.isAdminApproved ?? false ? "Approved" : "Pending"
    //                cell.photoIdChangeStatusLabel.text = model?.photoIDChanges.first?.isAdminApproved ?? false ? "Approved" : "Pending"

                    return cell
                }
                
            }
            
            return UITableViewCell()
            }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "kycStatusCell", for: indexPath) as? KYCStatusCell else {
                return UITableViewCell()
            }
            var model = self.selectedIdentityVerificationResponse?.data//.value(atSafe: indexPath.row)
            cell.emailValueLabel.text = model?.customer.email
            cell.nameValueLabel.text = (model?.customer.firstName ?? "") + " " + (model?.customer.lastName ?? "")
            cell.phoneValueLabel.text = model?.customer.phoneNumber
            if model?.customer != nil {
                let attributedTitle = NSMutableAttributedString(string: model?.kycStatus == true ? "Completed" : "Inprogress", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0) ?? .boldSystemFont(ofSize: 10.0), NSAttributedString.Key.foregroundColor: UIColor(named: "green") ?? .green])

                    cell.kycStatusButton.setAttributedTitle(attributedTitle, for: .normal)
            }
           
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.noDataFoundLabel.isHidden = true

        if tableView == personalDetailsTable {
            if self.selectedIndex == 1 {
                guard let model = self.loanModel?.data.value(atSafe: indexPath.row) else{
                    return
                }
                let vc = ProfileDetailsVC.initWithStory(loanData: model,index: indexPath.row)
                self.navigationController?.pushViewController(vc, animated: true)

                
            }
            else if self.selectedIndex == 2 {
                guard let model = self.companyList.value(atSafe: indexPath.row) else{
                    return
                }
                let vc = UnitDetailsVC.initWithStory(companyDetails: model)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if self.selectedIndex == 5 && self.insideTabNo == 3 {
                tabSelected = true
                guard let model = self.pendingApprovalData.value(atSafe: indexPath.row) else {
                    return
                }
                self.createModelArrayForAddressProof(selectedProfile: model)
            }
            else if self.selectedIndex == 5 && self.insideTabNo ==  4 {
                tabSelected = true
                guard let model = self.pendingApprovalData.value(atSafe: indexPath.row) else {
                    return
                }
                self.createModelArrayForPhotoId(selectedProfile: model)
            }
            else if self.selectedIndex == 5 && self.insideTabNo == 1 {
                tabSelected = true
                guard let model = self.pendingApprovalData.value(atSafe: indexPath.row) else {
                    return
                }
                self.createModelArrayForProfile()
                self.createModelArrayForChanges(selectedProfile: model)
            }
            else if self.selectedIndex == 5 && self.insideTabNo == 2 {
                tabSelected = true
                guard let model = self.pendingApprovalData.value(atSafe: indexPath.row) else {
                    return
                }
                self.createModelArrayForCompany(selectedProfile: model)
                self.createModelArrayForChanges(selectedProfile: model)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == personalDetailsTable && self.selectedIndex == 1 {
            return 130
        }
        else if tableView == personalDetailsTable && self.selectedIndex == 2 {
            return 75
        }
        
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == personalDetailsTable && tabSelected && ((self.selectedIndex == 5 && self.insideTabNo == 1) || (self.selectedIndex == 5 && self.insideTabNo == 2)) {
            
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            
            let label = UILabel()
            label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = section == 0 ? "Old Profile" : "New Profile"
            label.font = .systemFont(ofSize: 16)
            label.textColor = .black
            
            headerView.addSubview(label)
            
            return headerView
        }
        return UIView()
        }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == personalDetailsTable && tabSelected && ((self.selectedIndex == 5 && self.insideTabNo == 1) || (self.selectedIndex == 5 && self.insideTabNo == 2)) {
            
            return 50
        }
        return 0
        }
}
//MARK: -------------------------- Observers Methods --------------------------
extension ProfileVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.menuTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            //self.menuTableHeight.constant = newvalue.height
        }
        if let obj = object as? UITableView, obj == self.directorsTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.directorsTableHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.menuTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.documentTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.directorsTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.menuTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        guard let tblView3 = self.documentTable else {return}
        if let _ = tblView3.observationInfo {
            tblView3.removeObserver(self, forKeyPath: "contentSize")
        }
        guard let tblView2 = self.directorsTable else {return}
        if let _ = tblView2.observationInfo {
            tblView2.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
extension ProfileVC: CellDelegate{
    func reload() {
        if UserDefaults.standard.value(forKey: "role") as! String == "FIELDAGENT" {
            self.fetchAgentProfileDetails()

        }else{
            self.fetchProfileDetails()
        }
        self.menuTable.reloadData()
    }
    func particularReloadOf() {
    }
}
//MARK: -------------------------- UITextField Delegate Methods --------------------------
extension ProfileVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.currentPasswordTF {
            self.currentPasswordErrStack.isHidden = true
        }
        if textField == self.newPasswordTF {
            self.newPasswordErrStack.isHidden = true
        }
        if textField == self.confirmPasswordTF {
            self.confirmPasswordErrStack.isHidden = true
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
            
        case self.currentPasswordTF:
            if (self.currentPasswordTF.text == nil || self.currentPasswordTF.text == "") {
                self.currentPasswordErrStack.isHidden = false
                self.currentPasswordErrLabel.text = "Please enter current Password"
            }else{
                self.currentPasswordErrStack.isHidden = true
            }
        case self.newPasswordTF:
            if (self.newPasswordTF.text == nil || self.newPasswordTF.text == "") {
                self.newPasswordErrStack.isHidden = false
                self.newPasswordErrLabel.text = "Please enter new Password"
            }else{
                self.newPasswordErrStack.isHidden = true
            }
        case self.confirmPasswordTF:
            if (self.confirmPasswordTF.text == nil || self.confirmPasswordTF.text == "") {
                self.confirmPasswordErrStack.isHidden = false
                self.confirmPasswordErrLabel.text = "Please enter confirm Password"
            }else{
                self.confirmPasswordErrStack.isHidden = true
            }
        default: break
        }
        
    }
}
extension ProfileVC {
    func redirectToImageChooseVC()
    {
        let types: [String] = [kUTTypePDF as String,kUTTypeJPEG as String,kUTTypePNG as String]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
        }
}
extension ProfileVC : UIDocumentPickerDelegate {
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
        
        self.dismiss(animated: true, completion: nil)
    }
    func fileChecking(url:URL){
        var sizeKB = self.sizePerKB(url: url)
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
            do {
                let fileData = try Data.init(contentsOf: url)
                let fileStream:String = fileData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
                guard let selectedModel = self.selectedIndex == 3 ? self.viewModel.documentArray.value(atSafe: self.selectedDocumentIndex) : self.viewModel.documentArray2.value(atSafe: self.selectedDocumentIndex) else {return}
                selectedModel.fileName = fileName + "." + fileType
                selectedModel.isSelected = true
                selectedModel.fileString = fileStream
                selectedModel.fileSize = sizeKB.description.toInt().description + "KB"
                selectedModel.fileData = fileData
                selectedModel.fileType = fileType
                selectedModel.mimeType = fileMIMEType
                self.documentTable.reloadData()
            }
            catch { }}
    }
}
extension ProfileVC {
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
    func redirectToUploadPhoto()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard let alertPop = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageChooseViewController") as? ImageChooseViewController else {return}
    //            let rootVC = UIApplication.shared.windows.last!.rootViewController
    //            rootVC?.addChild(alertPop)
    //            rootVC?.view.addSubview(alertPop.view)
    //            alertPop.didMove(toParent: rootVC)
                alertPop.delegate = self
            alertPop.modalPresentationStyle = .popover
               // alertPop.modalTransitionStyle = .crossDissolve
            
            self.present(alertPop, animated: true, completion: nil)
        }
        
        }
}
extension ProfileVC: UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
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
                data = image.jpegData(compressionQuality: 0.1)!
                    size = Float(Double(data.count)/1024)
                    size = Float(Double(size/1024))
                    var imageName = "Image.jpg"
                    var fileType = ""
                    var fileMIMEType = ""
                    if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                    print(url.lastPathComponent)
                    print(url.pathExtension)
                        imageName = url.lastPathComponent
                        fileType = url.pathExtension
                        fileMIMEType = self.mimeTypeForPath(fileType: fileType)
                    }
                if size >= 5 {
                    self.showAlert(title: "Info", message: "Please upload image with below 5MB")
                }else{
                    self.uploadProfileImage(image: image,imageName: imageName,imageSize: "\(size)KB",fileType: fileType,mimeType: fileMIMEType)
                }
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    func uploadProfileImage(image: UIImage,imageName: String,imageSize: String,fileType: String,mimeType : String ) {
        
        var imageStr = ""
        let imageData = image.jpegData(compressionQuality: 0.1)
        if let imageString = imageData?.base64EncodedString() {
            imageStr = imageString
        }
        var dataArray = [String: Any]()
        dataArray["image"] = UploadDocumentModel(data: imageData ?? Data(), fileName: imageName, mimeType: mimeType, fileType: fileType)
        self.createProfileImageDetails(paramDict: JSON(), dataArray: dataArray)

    }
    func createProfileImageDetails(paramDict: JSON,dataArray: [String: Any]) {
        var path = APIEnums.retrieveProfileDetails.rawValue
        if UserDefaults.standard.value(forKey: "role") as! String == "FIELDAGENT" {
            path = APIEnums.retrieveAgentProfileDetails.rawValue
        }
        
        ConnectionHandler().profileImageUpload(wsMethod: path, paramDict: paramDict, dataArray: dataArray, viewController: self, isToShowProgress: true, isToStopInteraction: true) { response in
            if response.status_code == 200 {
                print(response)
                if UserDefaults.standard.value(forKey: "role") as! String == "FIELDAGENT" {
                    self.fetchAgentProfileDetails()
                }else{
                    self.fetchProfileDetails()
                }
            }
            else if response.status_code == 401 {
                self.tokenRefreshApiforProfile(paramDict: paramDict, dataArray: dataArray)
            }
            else{
                print(response)
                self.showAlert(title: "Info", message: response.status_message)
            }
        }
    }
    func tokenRefreshApiforProfile(paramDict: JSON,dataArray: [String: Any]) {
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

                    self.createProfileImageDetails(paramDict: paramDict, dataArray: dataArray)
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

}
extension ProfileVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cell = personalDetailsTable.visibleCells.last as? LeadsCell
        guard ((cell?.leadsName.text) != nil),
              (self.companyList.last != nil), self.selectedIndex == 2 else {return}
        if cell?.leadsName.accessibilityHint == (self.companyList.last?.id) &&
            self.companyObject?.next != "" && self.currentUnitPageIndex != self.totalUnitPages && oneTimeForUnitHit {
            self.fetchCompanyListDetails()
            self.oneTimeForUnitHit = !self.oneTimeForUnitHit
        }
    }
}
