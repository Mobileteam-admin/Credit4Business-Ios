//
//  LoginVC.swift
//  Credit4Business
//
//  Created by MacMini on 22/04/24.
//

import UIKit
import IQKeyboardManagerSwift

class LoginVC: UIViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordErrLabel: UILabel!
    @IBOutlet weak var passwordErrStack: UIStackView!
    @IBOutlet weak var emailErrLabel: UILabel!
    @IBOutlet weak var emailErrStack: UIStackView!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var eyeIcon: UIImageView!
    @IBOutlet weak var showPasswordView: UIView!
    var viewModel = HomeVM()
    var isShowPassword = false
    let userDefaults = UserDefaults.standard
    var selectedRememberMe : Bool = false

    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var rememberMeImage: UIImageView!
    @IBOutlet weak var rememberMeView: UIView!
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
    
    class func initWithStory() -> LoginVC {
        let vc : LoginVC = UIStoryboard.Login.instantiateViewController()
        return vc
    }
    //---------------------------------------
    // MARK: - Custom methods
    //---------------------------------------
    func setDelegates() {
        self.emailTF.delegate = self
        self.passwordTF.delegate = self
        
        self.passwordTF.keyboardType = .default
        self.emailTF.keyboardType = .emailAddress
        self.eyeIcon.image = UIImage(named: "eyeclosed")
    }
    func goNext() -> Bool {
       
        if (self.emailTF.text == nil || self.emailTF.text == "") {
            return false
        }
        if !self.isValidEmail(testStr: emailTF.text ?? "") {
            return false
        }
        if (self.passwordTF.text == nil || self.passwordTF.text == "") {
            return false
        }
//        if self.passwordTF.text != "000000" && self.passwordTF.text != ""
//        {
//            return false
//        }
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
        if (self.passwordTF.text == nil || self.passwordTF.text == "") {
            self.passwordErrStack.isHidden = false
            self.passwordErrLabel.text = "Please enter Password"
        }
//        if self.passwordTF.text != "000000" && self.passwordTF.text != ""
//        {
//            self.passwordErrStack.isHidden = false
//            self.passwordErrLabel.text = "Invalid Password"
//        }
    }
    func manageActionMethods() {
        self.showPasswordView.addTapGestureRecognizer {
            self.isShowPassword = !self.isShowPassword
            self.eyeIcon.image = self.isShowPassword ? UIImage(named: "eyeopened") : UIImage(named: "eyeclosed")
            self.passwordTF.isSecureTextEntry = self.isShowPassword ? false : true
        }
        self.signInButton.addTapGestureRecognizer {
                self.isValidTextFields()
                if self.goNext() {
                    var dicts = [String: Any]()
                    dicts["password"] = String(format:"%@",self.passwordTF.text!)
                    dicts["username"] = String(format:"%@",self.emailTF.text!)
                    self.callSigninAPI(parms: dicts)
                    print("go next")
                }
        }
        self.rememberMeView.addTapGestureRecognizer {
            self.selectedRememberMe = !self.selectedRememberMe
            self.rememberMeImage.image = self.selectedRememberMe ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")

        }
        self.forgotPasswordButton.addTapGestureRecognizer {
            let vc = ForgotPasswordVC.initWithStory()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func callSigninAPI(parms: [AnyHashable: Any]){
        self.viewModel
            .SigninApicall(parms: parms){(result) in
                switch result{
                case .success(let json):
//                    self.sendOTPTapped()
                    if json.role != "FIELDAGENT" && json.role != "LEADS" && json.role != "CUSTOMER" {
                        self.showAlert(title: "Info", message: "Invalid User")
                        return
                    }
                    self.userDefaults.set(json.access, forKey:"access")
                    self.userDefaults.set(json.refresh, forKey:"refresh")
                    self.userDefaults.set(json.role, forKey:"role")
                    self.userDefaults.set(1, forKey:"isLogin")
                    UserDefaults.standard.set(json.username, forKey:"email")
                    UserDefaults.standard.set(json.fullName, forKey:"name")
                    UserDefaults.standard.set(json.image, forKey:"image")
                    UserDefaults.standard.set(json.address, forKey:"address")
                    if json.role == "LEADS" {
                        var navigationController = UINavigationController()
                        navigationController = UINavigationController(rootViewController: HomeViewController.initWithStory())
                        sceneDelegate.window?.rootViewController = navigationController
                        sceneDelegate.window?.makeKeyAndVisible()
                        navigationController.isNavigationBarHidden = true
                    }else{
                        let vc = TabBarController()
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                   
                    break
                case .failure(let error):
                    self.showAlert(title: "Info", message: error.localizedDescription)
                    break
                }
            }
    }
}
//MARK: -------------------------- UITextField Delegate Methods --------------------------
extension LoginVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.emailTF {
            self.emailErrStack.isHidden = true
        }
        if textField == self.passwordTF {
            self.passwordErrStack.isHidden = true
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
            
        case self.passwordTF:
            if (self.passwordTF.text == nil || self.passwordTF.text == "") {
                self.passwordErrStack.isHidden = false
                self.passwordErrLabel.text = "Please enter Password"
            }else{
                self.passwordErrStack.isHidden = true
            }
//            if self.passwordTF.text != "000000"
//            {
//                self.passwordErrStack.isHidden = false
//                self.passwordErrLabel.text = "Invalid Password"
//            }else{
//                self.passwordErrStack.isHidden = true
//            }
        default: break
        }
        
    }
}
