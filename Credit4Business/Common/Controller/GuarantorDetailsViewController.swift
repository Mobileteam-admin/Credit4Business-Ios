//
//  GuarantorDetailsViewController.swift
//  Credit4Business
//
//  Created by MacMini on 14/03/24.
//

import UIKit
import StepProgressBar
import IQKeyboardManagerSwift

class GuarantorDetailsViewController: UIViewController {

    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTableHeight: NSLayoutConstraint!
    @IBOutlet weak var nameTable: UITableView!
    @IBOutlet weak var nameTableArrowActionView: UIView!
    @IBOutlet weak var nameTableArrow: UIImageView!
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var lastNameView: UIView!

    @IBOutlet weak var cityErrLabel: UILabel! //new based on company number
    @IBOutlet weak var cityErrStack: UIStackView!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var cityTableHeight: NSLayoutConstraint!
    @IBOutlet weak var cityTable: UITableView!

    @IBOutlet weak var NameErrLabel: UILabel!
    @IBOutlet weak var NameErrStack: UIStackView!
    @IBOutlet weak var phoneErrLabel: UILabel!
    @IBOutlet weak var phoneErrStack: UIStackView!

    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pageControl: CustomPageControl!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailErrLabel: UILabel!
    @IBOutlet weak var emailErrStack: UIStackView!
    @IBOutlet weak var commentButton: UIImageView!

    @IBOutlet weak var agreementErrLabel: UILabel!
    @IBOutlet weak var agreementErrStack: UIStackView!
    @IBOutlet weak var agreementImage: UIImageView!
    @IBOutlet weak var agreementView: UIView!
    
    @IBOutlet weak var ownPropertyYesImage: UIImageView!
    @IBOutlet weak var ownPropertyYesView: UIView!
    @IBOutlet weak var ownPropertyNoImage: UIImageView!
    @IBOutlet weak var ownPropertyNoView: UIView!
    @IBOutlet weak var ownPropertyErrLabel: UILabel!
    @IBOutlet weak var ownPropertyErrStack: UIStackView!
    
    @IBOutlet weak var addressTableHeight: NSLayoutConstraint!
    @IBOutlet weak var addressTable: UITableView!
    @IBOutlet weak var addressTableErrLabel: UILabel!
    @IBOutlet weak var addressTableErrStack: UIStackView!
    @IBOutlet weak var numberOfPropertyTF: UITextField!
    @IBOutlet weak var numberOfPropertyView: UIView!
    @IBOutlet weak var numberOfPropertyStack: UIStackView!
    @IBOutlet weak var propertyTable: UITableView!
    @IBOutlet weak var propertyTableHeight: NSLayoutConstraint!
    
    var viewModel = HomeVM()
    var isAgreed = false
    var selectedName : Common?
    var nameTableHidden = true
    var selectedCity : String?
    var cityTableHidden = true
    var dropdownType : DropDownType = .none
    var selectedGuarantorResponse : GuarantorDataClass?
    var customerId = ""
    var delegate : CellDelegate?
    var loanId = ""
    var propertyTableHidden = true
    var selectedOwnProperty : Option = .none
    var numberOfProperty = 0

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
        IQKeyboardManager.shared.isEnabled = true
        if UserDefaults.standard.value(forKey: "role") as? String != "" && isFromIncomplete {
            self.fetchGuarantorDetails()
        }

        if self.selectedGuarantorResponse != nil {
            self.showModelValues()
        }
    }
    
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.isEnabled = false
    }
   //---------------------------------------
   // MARK: - Init With Story
   //---------------------------------------

    class func initWithStory(loanId: String) -> GuarantorDetailsViewController {
       let vc : GuarantorDetailsViewController = UIStoryboard.Login.instantiateViewController()
        vc.loanId = loanId
       return vc
   }
    
    //---------------------------------------
    // MARK: - Custom methods
    //---------------------------------------
    func setDelegates() {
        self.phoneTF.delegate = self
        self.cityTF.delegate = self
        self.firstNameTF.delegate = self
        self.lastNameTF.delegate = self
        self.nameTable.delegate = self
        self.nameTable.dataSource = self
        self.firstNameTF.keyboardType = .default
        self.lastNameTF.keyboardType = .default
        self.phoneTF.keyboardType = .numberPad
        self.phoneTF.maxLength  = Validations.PhoneNumber.Minimum.rawValue
        self.cityTable.delegate = self
        self.cityTable.dataSource = self
        self.emailTF.delegate = self
        self.emailTF.keyboardType = .emailAddress
        self.addressTable.delegate = self
        self.addressTable.dataSource = self
        self.propertyTable.delegate = self
        self.propertyTable.dataSource = self
        self.numberOfPropertyTF.delegate = self
    }
    func showPropertyTable() {
        self.dropdownType = .Property
        self.propertyTableHidden = false
        self.showHideTable()
    }
    func updateUI()
    {
//        self.codeView.layer.borderWidth = 0.5
//        self.codeView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.phoneView.layer.borderWidth = 0.5
//        self.phoneView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.nameView.layer.borderWidth = 0.5
//        self.nameView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.addressView.layer.borderWidth = 0.5
//        self.addressView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
        self.titleLabel.text = self.viewModel.nameArray.first?.description
        self.selectedName = self.viewModel.nameArray.first

        //self.firstNameTF.text = GlobalFundingModelObject.initial.firstName
       // self.lastNameTF.text = GlobalFundingModelObject.initial.lastName
        self.propertyTableHidden = true
        self.numberOfPropertyStack.isHidden = true
        self.showHideTable()
        self.showAddressTable()
        self.addObserverOnHeightTbl()
        self.pageControl.numberOfPages = 9
        self.setPagNumber(currentPage: 6)

    }
    func setPagNumber(currentPage : Int) {
        self.pageControl.currentPage = currentPage
    }
    func fetchGuarantorDetails() {
        APIService.shared.retrieveGuarantorFormDetails(loanId: self.loanId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.selectedGuarantorResponse = responseData
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
    func showModelValues() {
        
        var item = self.selectedGuarantorResponse
        self.titleLabel.text = item?.title ?? ""
        self.firstNameTF.text = item?.firstName ?? ""
        self.lastNameTF.text = item?.lastName ?? ""
       // self.cityTF.text = item?.address ?? ""
        self.phoneTF.text = item?.phoneNumber.description ?? ""
        self.emailTF.text = item?.email ?? ""
        if item?.guarantorAgreement != nil {
            self.isAgreed = item?.guarantorAgreement ?? false

            self.agreementImage.image = self.isAgreed ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")

        }
        var addressArray = [AddressAloneModel]()
        if item?.stay.count != 0 && item != nil {
            for element in item!.stay {
                var object = AddressAloneModel()
                object.address = element.address
                object.postCode = element.pincode
                object.houseOwnership = self.viewModel.houseOwnershipArray.filter({$0.description == element.houseOwnership}).first
                object.startDate = element.startDate
                object.endDate = element.endDate
                var startDate = convertDateFormaterForDate(date: element.startDate)
                var endDate = convertDateFormaterForDate(date: element.endDate)
                object.startDateObj = startDate
                object.endDateObj = endDate
                addressArray.append(object)

            }
            self.viewModel.addressArray = addressArray
        }
        var propertyArray = [PropertyAddressModel]()

        if item?.ownedPropertyCount != 0 && item != nil {
            for element in item!.ownedProperty {
                var obj = PropertyAddressModel()
                obj.address = element.address
                obj.postCode = element.pincode
                propertyArray.append(obj)
            }
            self.viewModel.propertyArray = propertyArray
        }
        self.selectedOwnProperty = item?.ownsOtherProperty == "Yes" ? Option.Yes : Option.No
        self.ownPropertyYesImage.image = self.selectedOwnProperty == .Yes ? UIImage(named: "radioSelected") : UIImage(named: "radioUnselected")
        self.ownPropertyNoImage.image = self.selectedOwnProperty == .No ? UIImage(named: "radioSelected") : UIImage(named: "radioUnselected")
        self.numberOfProperty = item?.ownedPropertyCount ?? 0
        if self.numberOfProperty > 0 && self.selectedOwnProperty == .Yes{
            self.showPropertyTable()
            self.numberOfPropertyStack.isHidden = false
            self.numberOfPropertyTF.text = self.numberOfProperty.description
        }else{
            self.dropdownType = .Property
            self.propertyTableHidden = true
            self.showHideTable()
            self.numberOfPropertyStack.isHidden = true
        }
        self.addressTable.reloadData()
        self.propertyTable.reloadData()

    }
    func updateModel() {
        let model = GlobalFundingModelObject
        var initial = GuarantorModel()
        initial.name = self.firstNameTF.text ?? "" + (self.lastNameTF.text ?? "")
        initial.address = self.cityTF.text ?? ""
        initial.phone = self.phoneTF.text ?? ""
        initial.email = self.emailTF.text ?? ""
        initial.isAgreed = self.isAgreed
        model.guarantor = initial
        var dict2 = JSON()

        dict2["title"] = self.titleLabel.text ?? ""
        dict2["first_name"] = self.firstNameTF.text ?? ""
        dict2["last_name"] = self.lastNameTF.text ?? ""
        dict2["phone_number"] = self.phoneTF.text ?? ""
        dict2["email"] = self.emailTF.text ?? ""
        dict2["guarantor_agreement"] = "True"
        
        var array = [Stay]()
        for element in self.viewModel.addressArray {
            var dict = [String: Any]()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"//DateTimeFormaterEnum.ddMMMyyyy.rawValue
            let start = dateFormatter.string(from: element.startDateObj ?? Date())
            let end = dateFormatter.string(from: element.endDateObj ?? Date())

            let obj = Stay(pincode: element.postCode ?? "", address: element.address, houseOwnership: element.houseOwnership?.description ?? "", startDate: start, endDate: end)
//            let obj = Director(title: element.title, firstName: element.firstName, lastName: element.lastName)
            array.append(obj)
        }
        var array1 = [Property]()
        if self.selectedOwnProperty == .Yes{
            for element in self.viewModel.propertyArray {
                let obj = Property(pincode: element.postCode ?? "", address: element.address)
                array1.append(obj)
            }
        }
        dict2["owns_other_property"] = self.selectedOwnProperty.rawValue
        dict2["stay"] = array.map { $0.dictionaryRepresentation }
        dict2["owned_property"] = array1.map { $0.dictionaryRepresentation }
        dict2["owned_property_count"] = array1.count
       // dict2["address"] = array.first?.address
      //  dict2["pincode"] = array.first?.pincode
        dict2["stay_validated"] = "False"
        self.createGuarantorDetails(params: dict2)
    }
    func updateFilledForms(){
        var params = JSON()
        params["complete_guarantors"] = "True"
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
    func createGuarantorDetails(params: JSON) {
        var url = APIEnums.createGuarantor.rawValue
        if customerId != "" {
            url = url + "?customer_id=\(customerId)"
        }
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
                    self.updateFilledForms()
                    if self.delegate != nil {
                        self.delegate?.reload()
                        self.dismiss(animated: true)
                    }else{
                        let vc = IdentityVerificationVC.initWithStory(loanId: self.loanId)
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

                    self.createGuarantorDetails(params: params)
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
    func showAlertWithAction(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default,handler: { okay in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alertController, animated: true)
    }
    func manageActionMethods() {
        self.agreementView.addTapGestureRecognizer {
            self.isAgreed = !self.isAgreed
            self.agreementImage.image = self.isAgreed ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")
            self.agreementErrStack.isHidden = true
        }
        self.commentButton.addTapGestureRecognizer {
            let vc = RemarksVC.initWithStory(loanId: self.loanId)
            vc.isRemarks = false
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        self.nameTableArrowActionView.addTapGestureRecognizer {
            self.nameTableHidden = !self.nameTableHidden
            self.showHideTable()
        }
        self.skipButton.addTapGestureRecognizer {
            if self.delegate != nil {
                self.delegate?.reload()
                self.dismiss(animated: true)
            }else{
                var vc = IdentityVerificationVC.initWithStory(loanId: self.loanId)
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
//                    self.showAlertWithAction(title: "Info", message: "Application submitted successfully")
                    
                }}
                else{
                    let vc = IdentityVerificationVC.initWithStory(loanId: self.loanId)
                    self.navigationController?.pushViewController(vc, animated: true)
//                    self.updateModel()
//                    self.showAlertWithAction(title: "Info", message: "Application submitted successfully")
                }
        }
        self.backButton.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        self.ownPropertyYesView.addTapGestureRecognizer {
            self.selectedOwnProperty = .Yes
            self.ownPropertyNoImage.image = UIImage(named: "radioUnselected")
            self.ownPropertyYesImage.image = UIImage(named: "radioSelected")
            self.ownPropertyErrStack.isHidden = true
            self.numberOfPropertyStack.isHidden = false
            self.propertyTable.isHidden = false
            self.numberOfPropertyTF.text = ""
            self.numberOfProperty = 0
            self.viewModel.propertyArray.removeAll()
            self.propertyTable.reloadData()
        }
        self.ownPropertyNoView.addTapGestureRecognizer {
            self.selectedOwnProperty = .No
            self.ownPropertyYesImage.image = UIImage(named: "radioUnselected")
            self.ownPropertyNoImage.image = UIImage(named: "radioSelected")
            self.ownPropertyErrStack.isHidden = true
            self.numberOfPropertyStack.isHidden = true
            self.propertyTable.isHidden = true
            self.numberOfPropertyTF.text = ""
            self.numberOfProperty = 0
            self.propertyTableHeight.constant = 0
            self.viewModel.propertyArray.removeAll()
            self.propertyTable.reloadData()
        }
    }
    func showHideTable() {
        if self.dropdownType == .RegPost {
            if self.cityTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        }
        else if self.dropdownType == .Property {
            if self.propertyTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        }
        else{
            if self.nameTableHidden {
                self.removeTransparentView()
            }else{
                self.addTransparentView()
            }
        }
    }
    func showAddressTable() {
        self.addressTable.isHidden = false
//        self.addressTableHeight.constant = CGFloat(self.viewModel.addressArray.count * 400)
        self.viewModel.addressArray.removeAll()
        self.viewModel.addressArray.append(AddressAloneModel())
        self.addressTable.reloadData()
        self.view.layoutIfNeeded()
    }
}
//MARK: -------------------------- UITextField Delegate Methods --------------------------
extension GuarantorDetailsViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let range = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: range, with: string)
        
        switch textField {
       
        case self.phoneTF:
            let mobileNo = self.phoneTF.text?.fullTrim()
            guard !newText.isEmpty else {
                self.phoneTF.text = ""
                self.phoneErrStack.isHidden = true
                self.updateProceedButtonUI(enabled: false)
                return false
            }
            if newText.fullTrim().count <= Validations.PhoneNumber.Minimum.rawValue {
              //  self.phoneTF.text = newText
            }
            
            //Check for the validations
            if newText.fullTrim().count < Validations.PhoneNumber.Minimum.rawValue {
                self.phoneErrStack.isHidden = false
                self.phoneErrLabel.text = "Mobile number should be at least \(Validations.PhoneNumber.Minimum.rawValue) characters"
                self.updateProceedButtonUI(enabled: false)
            }
            else if newText.fullTrim().isDummyNumber() {
                self.phoneErrStack.isHidden = false
                self.phoneErrLabel.text = "Mobile Number should begin with 6, 7, 8 or 9"
                self.updateProceedButtonUI(enabled: false)
            }
            else if newText.fullTrim().isFakeNumber() {
                self.phoneErrStack.isHidden = false
                self.phoneErrLabel.text = "Mobile Number should not contain repetitive digits"
                self.updateProceedButtonUI(enabled: false)
            }
            else if newText.fullTrim().count < Validations.PhoneNumber.Minimum.rawValue  {
                self.phoneErrStack.isHidden = false
                self.phoneErrLabel.text = "Mobile Number should contain 10 digits"
                self.updateProceedButtonUI(enabled: false)

            }
            else if !newText.fullTrim().isValidPhone() {
                if newText.fullTrim().count >= Validations.PhoneNumber.Minimum.rawValue && ((mobileNo?.isValidPhone()) != nil) {
                    self.phoneErrStack.isHidden = true
                    self.updateProceedButtonUI(enabled: true)

                }else{
                    self.phoneErrStack.isHidden = false
                    self.phoneErrLabel.text = "Invalid Mobile Number"
                    self.updateProceedButtonUI(enabled: false)

                }
            }
            else {
                self.phoneErrStack.isHidden = true
                self.updateProceedButtonUI(enabled: true)

            }

        default: break
        }
        
        return true
    }
    func updateProceedButtonUI(enabled: Bool) {
        self.nextButton.isUserInteractionEnabled = enabled
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.cityTF {
            self.cityErrStack.isHidden = true
        }
        if textField == self.firstNameTF {
            self.NameErrStack.isHidden = true
        }
        if textField == self.lastNameTF {
            self.NameErrStack.isHidden = true
        }
        if textField == self.phoneTF {
            self.phoneErrStack.isHidden = true
        }
        if textField == self.emailTF {
            self.emailErrStack.isHidden = true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        switch textField {
        case self.cityTF:
            let eTest       = NSPredicate(format:"SELF MATCHES %@", Validations.RegexType.AllowPincode.rawValue)
            let result      = eTest.evaluate(with: self.cityTF.text?.trim())

            if (self.cityTF.text == nil || self.cityTF.text == "") {
                self.cityErrStack.isHidden = false
                self.cityErrLabel.text = "Please enter Address"
                self.dropdownType = .RegPost
                self.cityTableHidden = true
                self.showHideTable()

            }
            else if result == false {
                self.cityErrStack.isHidden = false
                self.cityErrLabel.text = "Valid UK Postcode is required"
                self.dropdownType = .RegPost
                self.cityTableHidden = true
                self.showHideTable()

            }
            else{
//                self.cityTF.text = ""
//                self.selectedCity = ""
//                self.cityErrStack.isHidden = true
                self.callPostcodeLookupAPI(parms: ["address": self.cityTF.text ?? ""])
            }
        case self.firstNameTF:
            if (self.firstNameTF.text == nil || self.firstNameTF.text == "") {
                self.NameErrStack.isHidden = false
                self.NameErrLabel.text = "Please enter First Name"
            }
            
        case self.lastNameTF:
            if (self.lastNameTF.text == nil || self.lastNameTF.text == "") {
                self.NameErrStack.isHidden = false
                self.NameErrLabel.text = "Please enter Last Name"
            }
        case self.phoneTF:
            if (self.phoneTF.text == nil || self.phoneTF.text == "") {
                self.phoneErrStack.isHidden = false
                self.phoneErrLabel.text = "Please enter Phone number"
            }
            else{
//                self.loginPhoneTF.text = self.phoneTF.text
            }
        case self.emailTF:
            if (self.emailTF.text == nil || self.emailTF.text == "") {
                self.emailErrStack.isHidden = false
                self.emailErrLabel.text = "Please enter the email"
            }
            if !self.isValidEmail(testStr: emailTF.text ?? "") {
                self.emailErrStack.isHidden = false
                self.emailErrLabel.text = "Please Enter Valid Email"
            }else{
//                self.loginEmailTF.text = self.emailTF.text
            }
        case self.numberOfPropertyTF:
            guard let count = textField.text?.toInt() else{
                return
            }
            numberOfProperty = count
            if count > 0 {
                self.viewModel.createPropertyArray(count: count)
                self.showPropertyTable()
                self.ownPropertyErrStack.isHidden = true
            }
        default:
            break
        }
        //        self.updateNextButton()
    }
    
        func goNext() -> Bool {
            if (self.firstNameTF.text == nil || self.firstNameTF.text == "") {
                return false
            }
            if (self.lastNameTF.text == nil || self.lastNameTF.text == "") {
                return false
            }
            if (self.phoneTF.text == nil || self.phoneTF.text == "") {
                return false
            }
            if (self.selectedName?.description == nil || self.selectedName?.description == "") {
                return false
            }
//            if (self.cityTF.text == nil || self.cityTF.text == "") {
//                return false
//            }
            if (self.emailTF.text == nil || self.emailTF.text == "") {
                return false
            }
            if !self.isValidEmail(testStr: emailTF.text ?? "") {
                return false
            }
            if (self.isAgreed == false ) {
                return false
            }
            if (self.selectedOwnProperty == .none) {
                return false
            }
            if self.selectedOwnProperty == .Yes && (self.numberOfPropertyTF.text == "" || self.numberOfPropertyTF.text == nil) {
                return false
            }
            for element in self.viewModel.propertyArray {
                if element.address == ""  {
                    return false
                }
            }
            for element in self.viewModel.addressArray {
                if element.address == "" || element.startDate == "" || element.endDate == "" || element.houseOwnership?.description == "" || element.postCode?.description == "" {
                    return false
                }}
            return true
        }
    func addressChecking() {
        for element in self.viewModel.addressArray {
            if element.address != "" && element.startDate != "" && element.endDate != "" && element.houseOwnership?.description != "" && element.postCode?.description != "" {
                self.addressTableErrStack.isHidden = true
            }
        }
    }
    func isValidTextFields() {
        if (self.firstNameTF.text == nil || self.firstNameTF.text == "") {
            self.NameErrStack.isHidden = false
            self.NameErrLabel.text = "Please enter First Name"
        }
        if (self.lastNameTF.text == nil || self.lastNameTF.text == "") {
            self.NameErrStack.isHidden = false
            self.NameErrLabel.text = "Please enter Last Name"
        }
        if (self.phoneTF.text == nil || self.phoneTF.text == "") {
            self.phoneErrStack.isHidden = false
            self.phoneErrLabel.text = "Please enter Phone number"
        }
//        if (self.cityTF.text == nil || self.cityTF.text == "") {
//            self.cityErrStack.isHidden = false
//            self.cityErrLabel.text = "Please enter Address"
//        }
        if !self.isValidEmail(testStr: emailTF.text ?? ""){
            self.emailErrStack.isHidden = false
            self.emailErrLabel.text = "Please Enter Valid Email"
        }
        if (self.emailTF.text == nil || self.emailTF.text == "") {
            self.emailErrStack.isHidden = false
            self.emailErrLabel.text = "Please enter the email"
        }
        if (self.isAgreed == false ) {
            self.agreementErrStack.isHidden = false
            self.agreementErrLabel.text = "Please agree the terms"
        }
        if (self.selectedOwnProperty == .none) {
            self.ownPropertyErrStack.isHidden = false
            self.ownPropertyErrLabel.text = "Please choose anyone"
        }
        if self.selectedOwnProperty == .Yes && (self.numberOfPropertyTF.text == "" || self.numberOfPropertyTF.text == nil) {
            self.ownPropertyErrStack.isHidden = false
            self.ownPropertyErrLabel.text = "Please enter Number of property value"
        }
        if(self.selectedOwnProperty != .none) && (self.selectedOwnProperty == .Yes && (self.numberOfPropertyTF.text != "")){
                self.ownPropertyErrStack.isHidden = true
            }
            
            //    if (self.selectedHouseType?.description == nil || self.selectedHouseType?.description == "") {
            //        self.houseTypeErrStack.isHidden = false
            //        self.houseTypeErrLabel.text = "Please select House Ownership type"
            //    }
            self.addressTableErrStack.isHidden = true
            for element in self.viewModel.addressArray {
                if element.address == "" || element.startDate == "" || element.endDate == "" || element.houseOwnership?.description == "" || element.postCode?.description == "" {
                    self.addressTableErrStack.isHidden = false
                    self.addressTableErrLabel.text = "Please fill the address fields"
                }
            }
//            self.ownPropertyErrStack.isHidden = self.selectedOwnProperty == .none ? false : true
            
            for element in self.viewModel.propertyArray {
                if element.address == ""  {
                    self.ownPropertyErrStack.isHidden = false
                    self.ownPropertyErrLabel.text = "Please fill the details"
                }
            }
    }
    func callPostcodeLookupAPI(parms: [AnyHashable: Any]){
        self.viewModel
            .PostcodeLookupApicall(parms: parms){(result) in
                switch result{
                case .success(let responseDict):
                    print(responseDict)
                    self.viewModel.postalLookupArray.removeAll()
                    self.viewModel.postalLookupArray = responseDict.data.Results.Items
                    self.dropdownType = .RegPost
                    self.cityTableHidden = false
                    self.showHideTable()
                    break
                case .failure(let error):
                    break
                }
            }
    }
    
    func callPostcodeLookupSidAPI(parms: [AnyHashable: Any]){
        self.viewModel
            .PostcodeLookupSidApicall(parms: parms){(result) in
                switch result{
                case .success(let responseDict):
                    print(responseDict)
                    self.viewModel.postalLookupArray.removeAll()
                    self.viewModel.postalLookupArray = responseDict.data.Results.Items
                    self.cityTableHeight.constant = CGFloat(self.viewModel.postalLookupArray.count * 50)
                    self.cityTable.reloadData()
                    self.view.layoutIfNeeded()
                    break
                case .failure(let error):
                    break
                }
            }
    }
}
extension GuarantorDetailsViewController {
    func addTransparentView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                if self.dropdownType == .RegPost {
                    self.cityTable.isHidden = false
                    self.cityTableHeight.constant = CGFloat(self.viewModel.postalLookupArray.count * 50)
                    self.cityTable.reloadData()
                    self.view.layoutIfNeeded()
                }
                else if self.dropdownType == .Property {
                    self.propertyTable.isHidden = false
                   // self.propertyTableHeight.constant = CGFloat(self.numberOfProperty * 90)
                    self.propertyTable.reloadData()
                    self.view.layoutIfNeeded()
                }
                else{
                    self.nameTable.isHidden = false
                    self.nameTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                    self.nameTableHeight.constant = CGFloat(self.viewModel.nameArray.count * 50)
                    self.nameTable.reloadData()
                    self.view.layoutIfNeeded()
                }

                
               
                
            }, completion: nil)
        }
        
    }
    
    @objc func removeTransparentView() {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            if self.dropdownType == .RegPost {
                self.cityTable.isHidden = true
                self.cityTableHeight.constant = 0
                self.cityTable.reloadData()
            }
            else if self.dropdownType == .Property {
                self.propertyTable.isHidden = true
               // self.propertyTableHeight.constant = 0
                self.propertyTable.reloadData()
            }
            else{
                self.nameTable.isHidden = true
                self.nameTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                self.nameTableHeight.constant = 0
                self.nameTable.reloadData()
            }
            
        }, completion: nil)
    }
}
extension GuarantorDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView == cityTable {
            count = self.viewModel.postalLookupArray.count
        }
        else if tableView == addressTable {
            count = self.viewModel.addressArray.count
        }
        else{
            switch self.dropdownType {
            case .Name:
                count = self.viewModel.nameArray.count
            case .Property:
                count = self.numberOfProperty
            default:
                break
                
            }
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == cityTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? CellClass else {
                return UITableViewCell()
            }
            guard let model = self.viewModel.postalLookupArray.value(atSafe: indexPath.row) else{
                return cell
            }
            var modelText = model.ItemText
            var address = model.Label1 + "," + model.Label2 + "," + model.Label3 + "," + model.Label4
            cell.documentLabel.text = (modelText == "" && self.viewModel.postalLookupArray.count == 1) ? address : modelText
            cell.documentSelectAction.setTitle("", for: .normal)
            cell.separatorLabel.isHidden = (indexPath.row == self.viewModel.postalLookupArray.count - 1)
            cell.documentSelectAction.addTapGestureRecognizer {
                guard let model = self.viewModel.postalLookupArray.value(atSafe: indexPath.row) else{
                    return
                }
                if model.Selected == "true" && self.viewModel.postalLookupArray.count == 1{
                    self.selectedCity = self.viewModel.postalLookupArray.value(atSafe: indexPath.row)?.Sid ?? ""
                    self.cityTF.text = model.Label1 + "," + model.Label2 + "," + model.Label3 + "," + model.Label4
                    self.cityErrStack.isHidden = true
//                    self.pincodeTF.text = model.Label5
                    self.cityTableHidden = !self.cityTableHidden
                    self.dropdownType = .RegPost
                    self.removeTransparentView()
                    self.cityErrStack.isHidden = true
                }else{
                    self.callPostcodeLookupSidAPI(parms: ["address_sid": model.Sid ?? ""])

                }
                
            }
            return cell
        }
        else if tableView == addressTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addressTableViewCell", for: indexPath) as? AddressTableViewCell else {
                return UITableViewCell()
            }
            guard let model = self.viewModel.addressArray.value(atSafe: indexPath.row) else {return UITableViewCell()}
            if model.isHouseExtended{
                cell.houseTable.isHidden = false
                cell.houseTypeTableHidden = false
                cell.dropdownType = .House
                cell.showHideTable()
            }else{
                cell.houseTable.isHidden = true
                cell.houseTypeTableHidden = true
                cell.dropdownType = .House
                cell.showHideTable()
            }
            if model.isPostcodeExtended{
                if cell.postcodeTable.isHidden == true {
                    
                    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                        
                        cell.postcodeTable.isHidden = false
                        cell.postcodeTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                        cell.postcodeTable.reloadData()
                        cell.layoutIfNeeded()
                    }, completion: nil)
                }

            }else{
                cell.postcodeTable.isHidden = true
                //cell.postcodeTable.reloadData()
                if cell.postcodeTable.isHidden == false {
                    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                        cell.postcodeTable.isHidden = true
                        cell.postcodeTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
            //                self.postcodeTableHeight.constant = 0
                        cell.postcodeTable.reloadData()
                        }, completion: nil)
                }


            }
            cell.model = model
            cell.addressDetailsTF.text = self.viewModel.addressArray.value(atSafe: indexPath.row)?.address
            cell.postcodeTypeTF.text = self.viewModel.addressArray.value(atSafe: indexPath.row)?.postCode?.description
            cell.startDateTF.text = model.startDate != nil ? model.startDate?.description : "startdate"
            cell.endDateTF.text = model.endDate != nil ? model.endDate?.description : "enddate"
            cell.houseTypeTF.text = self.viewModel.addressArray.value(atSafe: indexPath.row)?.houseOwnership?.description
            cell.viewModel = self.viewModel
            cell.delegate = self
//            cell.postcodeTableArrowActionView.addTapGestureRecognizer {
//                cell.dropdownType = .RegPost
//                cell.postcodeTableHidden = !cell.postcodeTableHidden
//                guard let model = self.viewModel.addressArray.value(atSafe: indexPath.row) else {return}
//                model.isPostcodeExtended = !model.isPostcodeExtended
//                cell.showHideTable()
//                self.addressTable.reloadData()
//            }
//            cell.postcodeTypeTF.addTapGestureRecognizer {
//                cell.dropdownType = .RegPost
//                cell.postcodeTableHidden = !cell.postcodeTableHidden
//                guard let model = self.viewModel.addressArray.value(atSafe: indexPath.row) else {return}
//                model.isPostcodeExtended = !model.isPostcodeExtended
//                cell.showHideTable()
//                self.addressTable.reloadData()
//            }
//            cell.houseTableArrowActionView.addTapGestureRecognizer {
//                cell.dropdownType = .House
//                cell.houseTypeTableHidden = !cell.houseTypeTableHidden
//                guard let model = self.viewModel.addressArray.value(atSafe: indexPath.row) else {return}
//                model.isHouseExtended = !model.isHouseExtended
//                cell.showHideTable()
//                self.addressTable.reloadData()
//            }
            cell.houseTypeTF.addTapGestureRecognizer {
                cell.dropdownType = .House
                cell.houseTypeTableHidden = !cell.houseTypeTableHidden
                guard let model = self.viewModel.addressArray.value(atSafe: indexPath.row) else {return}
                model.isHouseExtended = !model.isHouseExtended
                cell.showHideTable()
                self.addressTable.reloadData()
            }
            cell.startDateTF.addTapGestureRecognizer {
                let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
                     popup.modalPresentationStyle = .overFullScreen
                     popup.isReadableFormat = true
                     self.present(popup, animated: true, completion: nil)
                     popup.dateSelectionHandler = { [weak self] fromDate, DateObj in
    //                     self?.dateSelectionHandler?(fromDate, toDate, "\(fromDate) - \(toDate ?? "")")
    //                     self?.removeAnimate()
                         if cell.model.endDateObj != nil {
                             if DateObj.compare(cell.model.endDateObj ?? Date()) == .orderedAscending {
                             }else if DateObj.compare(cell.model.endDateObj ?? Date()) == .orderedSame {
                             }else{
                                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                     self?.showAlert(title: "Info", message: "Start date should be earlier than End Date")
                                 }
                                 self?.dismiss(animated: true)
                                 return
                             }
                         }
                         print(fromDate)
                         cell.startDateTF.text = fromDate
                         selectedStartDate = DateObj
                         cell.model.startDate = fromDate
                         cell.model.startDateObj = DateObj
                         cell.validatingDates()
                         self?.dismiss(animated: true)
                     }
                }
            cell.endDateTF.addTapGestureRecognizer {
                let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
                     popup.modalPresentationStyle = .overFullScreen
                     popup.isReadableFormat = true
                     self.present(popup, animated: true, completion: nil)
                     popup.dateSelectionHandler = { [weak self] fromDate, DateObj in
    //                     self?.dateSelectionHandler?(fromDate, toDate, "\(fromDate) - \(toDate ?? "")")
    //                     self?.removeAnimate()
                         print(fromDate)
                         if cell.model.startDateObj?.compare(DateObj ?? Date()) == .orderedAscending {
                         }else if cell.model.startDateObj?.compare(DateObj ?? Date()) == .orderedSame {
                         }else{
                             DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                 self?.showAlert(title: "Info", message: "Start date should be earlier than End Date")
                             }
                             self?.dismiss(animated: true)
                             return
                         }
                         cell.endDateTF.text = fromDate
                         selectedEndDate = DateObj
                         cell.model.endDateObj = DateObj
                         cell.model.endDate = fromDate
                         cell.validatingDates()
                         self?.dismiss(animated: true)
                     }
                }
            return cell
        }
        else if self.dropdownType == .Property && tableView == propertyTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell2", for: indexPath) as? AddressCell else {
                return UITableViewCell()
            }
            guard let model = self.viewModel.propertyArray.value(atSafe: indexPath.row) else {return UITableViewCell()}
            
            cell.model = model
            cell.viewModel = self.viewModel
            cell.addressTF.text = model.address
            cell.delegate = self
            if model.isExtended {
                cell.cityTable.isHidden = false
                cell.cityTableHidden = false
                cell.showHideTable()
            }else{
                cell.cityTable.isHidden = true
                cell.cityTableHidden = true
                cell.showHideTable()
            }
            return cell
        }
        else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? CellClass2 else {
                return UITableViewCell()
            }
            cell.label1.text = self.viewModel.nameArray.value(atSafe: indexPath.row)?.description
            cell.action1.setTitle("", for: .normal)
            cell.separator1.isHidden = (indexPath.row == self.viewModel.nameArray.count - 1)
            cell.action1.addTapGestureRecognizer {
                self.titleLabel.text = "\(self.viewModel.nameArray.value(atSafe: indexPath.row)?.description ?? "")"
                self.selectedName = self.viewModel.nameArray.value(atSafe: indexPath.row)
                self.nameTableHidden = !self.nameTableHidden
                self.removeTransparentView()
                self.NameErrStack.isHidden = true
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == addressTable {
            return UITableView.automaticDimension
        } else if tableView == propertyTable {
            return UITableView.automaticDimension
        }else{
            return 50
        }
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
extension GuarantorDetailsViewController: CellDelegate{
    func reload() {
        
            self.propertyTable.reloadData()
    }
    func particularReloadOf()
    {
        self.propertyTable.reloadData() //reloadRows(at: [propertyTextFieldIndexPath], with: .none)
    }
}
extension GuarantorDetailsViewController: AddressCellDelegate {
    func addressReload() {
        self.addressChecking()
        self.addressTable.reloadData()
    }
    func increaseAddressField() {
        self.viewModel.addressArray.append(AddressAloneModel())
        self.addressChecking()
        self.addressTable.reloadData()
    }
    func particularReload(){
        self.addressChecking()
        if textFieldIndexPath.count != 0 {
            self.addressTable.reloadRows(at: [textFieldIndexPath], with: .none)
        }else{
            self.addressTable.reloadData()
        }
    }
    func showAlertForCell(title: String) {
        self.showAlert(title: "Info", message: title)
    }
}
//MARK: -------------------------- Observers Methods --------------------------
extension GuarantorDetailsViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.addressTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.addressTableHeight.constant = newvalue.height
        }
        if let obj = object as? UITableView, obj == self.propertyTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.propertyTableHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.addressTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.propertyTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.addressTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        guard let tblView = self.propertyTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
