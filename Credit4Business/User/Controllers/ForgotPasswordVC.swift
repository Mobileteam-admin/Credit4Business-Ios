//
//  ForgotPasswordVC.swift
//  Credit4Business
//
//  Created by MacMini on 09/05/24.
//

import UIKit
import IQKeyboardManagerSwift
class ForgotPasswordVC: UIViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailErrLabel: UILabel!
    @IBOutlet weak var emailErrStack: UIStackView!
    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manageActionMethods()
        self.setDelegates()
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


    //---------------------------------------
    // MARK: - Init With Story
    //---------------------------------------
    
    class func initWithStory() -> ForgotPasswordVC {
        let vc : ForgotPasswordVC = UIStoryboard.Login.instantiateViewController()
        return vc
    }
    //---------------------------------------
    // MARK: - Custom methods
    //---------------------------------------
    func setDelegates() {
        self.emailTF.delegate = self
        self.emailTF.keyboardType = .emailAddress
        self.emailTF.isSecureTextEntry = false
    }
    func goNext() -> Bool {
       
        if (self.emailTF.text == nil || self.emailTF.text == "") {
            return false
        }
        if !self.isValidEmail(testStr: emailTF.text ?? "") {
            return false
        }
        return true
    }
    func isValidTextFields() {
        if (self.emailTF.text == nil || self.emailTF.text == "") {
            self.emailErrStack.isHidden = false
            self.emailErrLabel.text = "Please enter email"
        }
        if !self.isValidEmail(testStr: emailTF.text ?? "") && self.emailTF.text != "" {
            self.emailErrStack.isHidden = false
            self.emailErrLabel.text = "Please Enter Valid Email"
        }
       
    }
    func manageActionMethods() {
        self.submitButton.addTapGestureRecognizer {
            self.isValidTextFields()
            if self.goNext() {
//                let vc = ConfirmPasswordVC.initWithStory()
//                self.navigationController?.pushViewController(vc, animated: true)
                var dict = JSON()
                dict["email"] = self.emailTF.text ?? ""
                self.forgotPasswordApi(params: dict)
            }
        }
       
    }
    func forgotPasswordApi(params: JSON) {
        APIService.shared.forgotPasswordApi(endpoint: APIEnums.forgotPassword.rawValue,
                                      withLoader: true,
                                      method: .post,
                                      params: params) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    let vc = ConfirmPasswordVC.initWithStory(token: data.token)
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
extension ForgotPasswordVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.emailTF {
            self.emailErrStack.isHidden = true
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
            
        case self.emailTF:
            if (self.emailTF.text == nil || self.emailTF.text == "") {
                self.emailErrStack.isHidden = false
                self.emailErrLabel.text = "Please enter email"
            }else{
                self.emailErrStack.isHidden = true
            }
            if !self.isValidEmail(testStr: emailTF.text ?? "") && self.emailTF.text != "" {
                self.emailErrStack.isHidden = false
                self.emailErrLabel.text = "Please Enter Valid Email"
            }else{
                self.emailErrStack.isHidden = true
            }
            
        default: break
        }
        
    }
}
