//
//  ConfirmPasswordVC.swift
//  Credit4Business
//
//  Created by MacMini on 09/05/24.
//

import UIKit

class ConfirmPasswordVC: UIViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var newPasswordErrLabel: UILabel!
    @IBOutlet weak var newPasswordErrStack: UIStackView!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordErrLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrStack: UIStackView!
    var token = ""
    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.manageActionMethods()
        // Do any additional setup after loading the view.
    }
    

    //---------------------------------------
    // MARK: - Init With Story
    //---------------------------------------
    
    class func initWithStory(token : String) -> ConfirmPasswordVC {
        let vc : ConfirmPasswordVC = UIStoryboard.Login.instantiateViewController()
        vc.token = token
        return vc
    }
    //---------------------------------------
    // MARK: - Custom methods
    //---------------------------------------
    func setDelegates() {
        self.newPasswordTF.delegate = self
        self.newPasswordTF.isSecureTextEntry = true
        self.confirmPasswordTF.delegate = self
        self.confirmPasswordTF.isSecureTextEntry = true

    }
    func goNext() -> Bool {
       
        if (self.newPasswordTF.text == nil || self.newPasswordTF.text == "") {
            return false
        }
        if (self.confirmPasswordTF.text == nil || self.confirmPasswordTF.text == "") {
            return false
        }
        if self.confirmPasswordTF.text != self.newPasswordTF.text {
            return false
        }
        return true
    }
    func isValidTextFields() {
        if (self.newPasswordTF.text == nil || self.newPasswordTF.text == "") {
            self.newPasswordErrStack.isHidden = false
            self.newPasswordErrLabel.text = "Please Enter New Password"
        }
        if (self.confirmPasswordTF.text == nil || self.confirmPasswordTF.text == "") {
            self.confirmPasswordErrStack.isHidden = false
            self.confirmPasswordErrLabel.text = "Please Enter Confirm Password"
        }
        if self.confirmPasswordTF.text != self.newPasswordTF.text {
            self.confirmPasswordErrStack.isHidden = false
            self.confirmPasswordErrLabel.text = "New Password and Confirm Password should be same"
        }
       
    }
    func manageActionMethods() {
        self.submitButton.addTapGestureRecognizer {
            self.isValidTextFields()
            if self.goNext() {
                var dict = JSON()
                dict["password"] = self.confirmPasswordTF.text ?? ""
                dict["token"] = self.token
                self.confirmPasswordApi(params: dict)
            }
        }
       
    }
    func confirmPasswordApi(params: JSON) {
        APIService.shared.makeRequest(endpoint: APIEnums.confirmReset.rawValue,
                                      withLoader: true,
                                      method: .post,
                                      params: params) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    let vc = LoginVC.initWithStory()
                    self.navigationController?.pushViewController(vc, animated: true)
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
extension ConfirmPasswordVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
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
            
        case self.newPasswordTF:
            if (self.newPasswordTF.text == nil || self.newPasswordTF.text == "") {
                self.newPasswordErrStack.isHidden = false
                self.newPasswordErrLabel.text = "Please enter new password"
            }else{
                self.newPasswordErrStack.isHidden = true
            }
        case self.confirmPasswordTF:
            if (self.confirmPasswordTF.text == nil || self.confirmPasswordTF.text == "") {
                self.confirmPasswordErrStack.isHidden = false
                self.confirmPasswordErrLabel.text = "Please enter confirm password"
            }else{
                self.confirmPasswordErrStack.isHidden = true
            }
            
        default: break
        }
        
    }
}
