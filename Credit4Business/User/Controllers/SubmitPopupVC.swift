//
//  SubmitPopupVC.swift
//  Credit4Business
//
//  Created by MacMini on 13/09/24.
//

import UIKit
import IQKeyboardManagerSwift
class SubmitPopupVC: UIViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var dismissImage: UIImageView!
    @IBOutlet weak var remarksTF: UITextField!
    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var submitView: UIView!


    //MARK: -------------------- Class Variable --------------------
    var loanId = ""
    var delegate : loanSubmitDelegate?
    var loanSubmitModel: LoanSubmitModel?
    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.manageActionMethods()
        // Do any additional setup after loading the view.
    }
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.isEnabled = true
    }
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.isEnabled = false
    }
    func setDelegates() {
        self.remarksTF.delegate = self
    }
    func manageActionMethods() {
        self.dismissImage.addTapGestureRecognizer {
            self.dismiss(animated: true)
        }
        self.closeView.addTapGestureRecognizer {
            self.dismiss(animated: true)
        }
        self.submitView.addTapGestureRecognizer {
            if self.remarksTF.text?.fullTrim() != "" {
                self.formSubmission()
            }else {
                self.showAlert(title: "Info", message: "Please enter the Remarks to continue")
            }
        }
    }
    class func initWithStory(loanId: String) -> SubmitPopupVC {
        let vc : SubmitPopupVC = UIStoryboard.Login.instantiateViewController()
        vc.loanId = loanId
        return vc
    }
    func formSubmission() {
        var dict = JSON()
        dict["remarks"] = self.remarksTF.text ?? ""
        APIService.shared.loanSubmitRequest(endpoint: APIEnums.formSubmission.rawValue + "\(loanId)/",
                                      withLoader: true,
                                      method: .post,
                                      params: dict) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    self.loanSubmitModel = data
                    self.showAlertWithAction(title: "Funding Successfully Submitted!", message: "Your Funding Application has been successfully Submitted, We'll get back to you soon.")
                }
                else if data.statusCode == 401 {
                   // self.tokenRefreshApi()
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
        alertController.addAction(UIAlertAction(title: "Close", style: .default,handler: { okay in
            self.delegate?.reload(loanDetails: self.loanSubmitModel!)
                self.dismiss(animated: true)
        }))
        self.present(alertController, animated: true)
    }
}
extension SubmitPopupVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.remarksTF:
            if (self.remarksTF.text != nil || self.remarksTF.text != "") {
                
            }
        default:
            break
        }
        
    }
}
