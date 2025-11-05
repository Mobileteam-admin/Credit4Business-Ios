//
//  ReferralVC.swift
//  Credit4Business
//
//  Created by MacMini on 15/05/24.
//

import UIKit
import IQKeyboardManagerSwift
class ReferralVC: UIViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var submitBtn: UIButton!

    @IBOutlet weak var dismissImage: UIImageView!
    @IBOutlet weak var businessNameTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!

    @IBOutlet weak var businessNameErrStack: UIStackView!
    @IBOutlet weak var phoneNumberErrStack: UIStackView!
    @IBOutlet weak var emailErrStack: UIStackView!
    @IBOutlet weak var nameErrStack: UIStackView!
    
    @IBOutlet weak var businessNameErrLabel: UILabel!
    @IBOutlet weak var phoneNumberErrLabel: UILabel!
    @IBOutlet weak var emailErrLabel: UILabel!
    @IBOutlet weak var nameErrLabel: UILabel!
    
    @IBOutlet weak var sortCodeTF: UITextField!
    @IBOutlet weak var accountHolderNameTF: UITextField!
    @IBOutlet weak var accountNumberTF: UITextField!
    @IBOutlet weak var bankNameTF: UITextField!
    
    @IBOutlet weak var bankNameErrStack: UIStackView!
    @IBOutlet weak var accountHolderNameErrStack: UIStackView!
    @IBOutlet weak var accountNumberErrStack: UIStackView!
    @IBOutlet weak var sortCodeErrStack: UIStackView!
    
    @IBOutlet weak var bankNameErrLabel: UILabel!
    @IBOutlet weak var accountNumberErrLabel: UILabel!
    @IBOutlet weak var accountHolderNameErrLabel: UILabel!
    @IBOutlet weak var sortCodeErrLabel: UILabel!
    //---------------------------------------

    // MARK: - View Controller Functions
    //---------------------------------------
    var referralModel = [ReferralData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.manageActionMethods()
        // Do any additional setup after loading the view.
    }
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    func setDelegates() {
        self.firstNameTF.delegate = self
        self.lastNameTF.delegate = self
        self.emailTF.delegate = self
        self.phoneNumberTF.delegate = self
        self.businessNameTF.delegate = self
        self.bankNameTF.delegate = self
        self.accountNumberTF.delegate = self
        self.accountHolderNameTF.delegate = self
        self.sortCodeTF.delegate = self
        self.accountNumberTF.keyboardType = .numberPad
        self.sortCodeTF.keyboardType = .numberPad
    }
    func manageActionMethods() {
        self.submitBtn.addTapGestureRecognizer {
            self.isValidTextFields()
            if self.goNext() {
                var Dict = JSON()
                Dict["first_name"] = self.firstNameTF.text ?? ""
                Dict["last_name"] = self.lastNameTF.text ?? ""
                Dict["email"] = self.emailTF.text ?? ""
                Dict["phone_number"] = self.phoneNumberTF.text ?? ""
                Dict["business_name"] = self.businessNameTF.text ?? ""
                var dict3 = JSON()
                dict3["bank_name"] = self.bankNameTF.text ?? ""
                dict3["account_number"] = self.accountNumberTF.text ?? ""
                dict3["account_holder_name"] = self.accountHolderNameTF.text ?? ""
                dict3["sort_code"] = self.sortCodeTF.text ?? ""
                Dict["bank_details"] = dict3
                self.createReferralDetails(Dict: Dict)
//                self.dismiss(animated: true)
            }
        }
        self.dismissImage.addTapGestureRecognizer {
            self.dismiss(animated: true)
        }
    }
    func isValidTextFields() {
        if (self.firstNameTF.text == nil || self.firstNameTF.text == "") {
            self.nameErrStack.isHidden = false
            self.nameErrLabel.text = "Please enter First Name"
        }
        if (self.emailTF.text == nil || self.emailTF.text == "") {
            self.emailErrStack.isHidden = false
            self.emailErrLabel.text = "Please enter the email"
        }
        if !self.isValidEmail(testStr: emailTF.text ?? "") {
            self.emailErrStack.isHidden = false
            self.emailErrLabel.text = "Please Enter Valid Email"
        }
       
        if (self.lastNameTF.text == nil || self.lastNameTF.text == "") {
            self.nameErrStack.isHidden = false
            self.nameErrLabel.text = "Please enter Last Name"
        }

        if (self.phoneNumberTF.text == nil || self.phoneNumberTF.text == "") {
            self.phoneNumberErrStack.isHidden = false
            self.phoneNumberErrLabel.text = "Please enter Phone Number"
        }
        if (self.businessNameTF.text == nil || self.businessNameTF.text == "") {
            self.businessNameErrStack.isHidden = false
            self.businessNameErrLabel.text = "Please enter Business Name"
        }
        if (self.bankNameTF.text == nil || self.bankNameTF.text == "") {
            self.bankNameErrStack.isHidden = false
            self.bankNameErrLabel.text = "Please enter Bank Name"
        }
        if (self.accountNumberTF.text == nil || self.accountNumberTF.text == "") {
            self.accountNumberErrStack.isHidden = false
            self.accountNumberErrLabel.text = "Please enter Account Number"
        }
        if (self.accountHolderNameTF.text == nil || self.accountHolderNameTF.text == "") {
            self.accountHolderNameErrStack.isHidden = false
            self.accountHolderNameErrLabel.text = "Please enter Account Holder Name"
        }
        if (self.sortCodeTF.text == nil || self.sortCodeTF.text == "") {
            self.sortCodeErrStack.isHidden = false
            self.sortCodeErrLabel.text = "Please enter Sort Code"
        }
    }
    func goNext() -> Bool {
        if (self.emailTF.text == nil || self.emailTF.text == "") {
            return false
        }
        if !self.isValidEmail(testStr: emailTF.text ?? "") {
            return false
        }
        if (self.firstNameTF.text == nil || self.firstNameTF.text == "") {
            return false
        }
        if (self.lastNameTF.text == nil || self.lastNameTF.text == "") {
            return false
        }
        if (self.phoneNumberTF.text == nil || self.phoneNumberTF.text == "") {
            return false
        }
        if (self.businessNameTF.text == nil || self.businessNameTF.text == "") {
            return false
        }
        if (self.bankNameTF.text == nil || self.bankNameTF.text == "") {
            return false
        }
        if (self.accountNumberTF.text == nil || self.accountNumberTF.text == "") {
            return false
        }
        if (self.accountHolderNameTF.text == nil || self.accountHolderNameTF.text == "") {
            return false
        }
        if (self.sortCodeTF.text == nil || self.sortCodeTF.text == "") {
            return false
        }
        return true
    }

    class func initWithStory() -> ReferralVC {
        let vc : ReferralVC = UIStoryboard.Login.instantiateViewController()
        return vc
    }
    func fetchReferralDetails() {
        APIService.shared.retrieveReferralDetails() { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.referralModel = responseData
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
    func createReferralDetails(Dict : JSON){
       
        APIService.shared.makeRequest(endpoint: APIEnums.createReferral.rawValue,
                                      withLoader: true,
                                      method: .post,
                                      params: Dict) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    self.fetchReferralDetails()
                    self.showAlert(title: "Info", message: data.statusMessage)
                    self.dismiss(animated: true)
                }
                else if data.statusCode == 401 {
                    self.tokenRefreshApi(params: Dict)
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

                    self.createReferralDetails(Dict: params)
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
//MARK: -------------------------- UITextField Delegate Methods --------------------------
extension ReferralVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let range = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: range, with: string)
        
        switch textField {
        case self.phoneNumberTF:
            let mobileNo = self.phoneNumberTF.text?.fullTrim()
            guard !newText.isEmpty else {
                self.phoneNumberTF.text = ""
                self.phoneNumberErrStack.isHidden = true
                self.updateProceedButtonUI(enabled: false)
                return false
            }
            if newText.fullTrim().count <= Validations.PhoneNumber.Minimum.rawValue {
                //  self.phoneTF.text = newText
            }
            
            //Check for the validations
            if newText.fullTrim().count < Validations.PhoneNumber.Minimum.rawValue {
                self.phoneNumberErrStack.isHidden = false
                self.phoneNumberErrLabel.text = "Mobile number should be at least \(Validations.PhoneNumber.Minimum.rawValue) characters"
                self.updateProceedButtonUI(enabled: false)
            }
            else if newText.fullTrim().isDummyNumber() {
                self.phoneNumberErrStack.isHidden = false
                self.phoneNumberErrLabel.text = "Mobile Number should begin with 6, 7, 8 or 9"
                self.updateProceedButtonUI(enabled: false)
            }
            else if newText.fullTrim().isFakeNumber() {
                self.phoneNumberErrStack.isHidden = false
                self.phoneNumberErrLabel.text = "Mobile Number should not contain repetitive digits"
                self.updateProceedButtonUI(enabled: false)
            }
            else if newText.fullTrim().count < Validations.PhoneNumber.Minimum.rawValue  {
                self.phoneNumberErrStack.isHidden = false
                self.phoneNumberErrLabel.text = "Mobile Number should contain 10 digits"
                self.updateProceedButtonUI(enabled: false)
            }
            else if !newText.fullTrim().isValidPhone() {
                if newText.fullTrim().count >= Validations.PhoneNumber.Minimum.rawValue && ((mobileNo?.isValidPhone()) != nil) {
                    self.phoneNumberErrStack.isHidden = true
                    self.updateProceedButtonUI(enabled: true)
                }else{
                    self.phoneNumberErrStack.isHidden = false
                    self.phoneNumberErrLabel.text = "Invalid Mobile Number"
                    self.updateProceedButtonUI(enabled: false)
                }
            }
            else {
                self.phoneNumberErrStack.isHidden = true
                self.updateProceedButtonUI(enabled: true)
            }
            
        default: break
        }
        
        return true
    }
    
    func updateProceedButtonUI(enabled: Bool) {
        self.submitBtn.isUserInteractionEnabled = enabled
        //        self.nextButton.backgroundColor = enabled ? UIColor.init(named: "blue") :  UIColor.init(named: "grayborder")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //        if textField == self.cityTF {
        //            self.cityErrStack.isHidden = true
        //        }
        if textField == self.emailTF {
            self.emailErrStack.isHidden = true
        }
        if textField == self.businessNameTF {
            self.businessNameErrStack.isHidden = true
        }
        if textField == self.firstNameTF {
            self.nameErrStack.isHidden = true
        }
        if textField == self.lastNameTF {
            self.nameErrStack.isHidden = true
        }
        if textField == self.phoneNumberTF {
            self.phoneNumberErrStack.isHidden = true
        }
        if textField == self.bankNameTF {
            self.bankNameErrStack.isHidden = true
        }
        if textField == self.accountNumberTF {
            self.accountNumberErrStack.isHidden = true
        }
        if textField == self.accountHolderNameTF {
            self.accountHolderNameErrStack.isHidden = true
        }
        if textField == self.sortCodeTF {
            self.sortCodeErrStack.isHidden = true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
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
        case self.firstNameTF:
            if (self.firstNameTF.text == nil || self.firstNameTF.text == "") {
                self.nameErrStack.isHidden = false
                self.nameErrLabel.text = "Please enter First Name"
            }
            
        case self.lastNameTF:
            if (self.lastNameTF.text == nil || self.lastNameTF.text == "") {
                self.nameErrStack.isHidden = false
                self.nameErrLabel.text = "Please enter Last Name"
            }
        case self.phoneNumberTF:
            if (self.phoneNumberTF.text == nil || self.phoneNumberTF.text == "") {
                self.phoneNumberErrStack.isHidden = false
                self.phoneNumberErrLabel.text = "Please enter Phone number"
            }
            else{
                //                self.loginPhoneTF.text = self.phoneTF.text
            }
        case self.businessNameTF:
            if (self.businessNameTF.text == nil || self.businessNameTF.text == "") {
                self.businessNameErrStack.isHidden = false
                self.businessNameErrLabel.text = "Please enter Business Name"
            }
        case self.bankNameTF:
            if (self.bankNameTF.text == nil || self.bankNameTF.text == "") {
                self.bankNameErrStack.isHidden = false
                self.bankNameErrLabel.text = "Please enter Bank Name"
            }
        case self.accountNumberTF:
            if (self.accountNumberTF.text == nil || self.accountNumberTF.text == "") {
                self.accountNumberErrStack.isHidden = false
                self.accountNumberErrLabel.text = "Please enter Account Number"
            }
        case self.accountHolderNameTF:
            if (self.accountHolderNameTF.text == nil || self.accountHolderNameTF.text == "") {
                self.accountHolderNameErrStack.isHidden = false
                self.accountHolderNameErrLabel.text = "Please enter Account Holder Name"
            }
        case self.sortCodeTF:
            if (self.sortCodeTF.text == nil || self.sortCodeTF.text == "") {
                self.sortCodeErrStack.isHidden = false
                self.sortCodeErrLabel.text = "Please enter Sort Code"
            }
        default:
            break
        }
        //        self.updateNextButton()
    }
}
