//
//  CreditMonitoringCommentsVC.swift
//  Credit4Business
//
//  Created by MacMini on 19/09/24.
//

import UIKit
import IQKeyboardManagerSwift

class CreditMonitoringCommentsVC: UIViewController, CellDelegate{
    func reload() {
        self.leadsTable.reloadData()
    }
    
    func particularReloadOf() {
        
    }
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var moveToLegalBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var leadsTable: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentsTF: UITextField!

    //MARK: -------------------- Class Variable --------------------
    var viewModel = HomeVM()
    var creditMonitoringCommentsData = [CreditMonitoringComments]()
    var delegate : CellDelegate?
    var loanId = ""
    var mandateId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.manageActionMethods()
        self.fetchCreditMonitoringListDetails()
        self.commentsTF.delegate = self
        self.commentsTF.placeholder = "Add a Comment"

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
//        self.tabBarController?.tabBar.isHidden = true
    }
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    func setDelegates() {
        self.leadsTable.delegate = self
        self.leadsTable.dataSource = self
       // self.backBtn.isHidden = true
    }
    func manageActionMethods() {
        self.backBtn.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        self.sendButton.addTapGestureRecognizer {
            var dict = JSON()
            dict["comment"] = self.commentsTF.text
            self.createRemarks(json: dict)
        }
        self.moveToLegalBtn.addTapGestureRecognizer {
            self.moveToLegalStatus()
        }
    }
    class func initWithStory() -> CreditMonitoringCommentsVC {
        let vc : CreditMonitoringCommentsVC = UIStoryboard.Login.instantiateViewController()
        return vc
    }
    func fetchCreditMonitoringListDetails() {
        APIService.shared.retrieveCreditMonitoringComments(loanId: self.loanId, mandateId: self.mandateId) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.creditMonitoringCommentsData = responseData
                        self.leadsTable.reloadData()
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

}
extension CreditMonitoringCommentsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.creditMonitoringCommentsData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leadsTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "leadsCell2", for: indexPath) as? LeadsCell else {
                return UITableViewCell()
            }
            guard let model = self.creditMonitoringCommentsData.value(atSafe: indexPath.row) else {return UITableViewCell()}
            cell.textMessage.text = model.comment
            cell.leadsPhone.text = model.createdBy.role
            cell.leadsName.text = model.createdBy.email
            cell.requestedDateLabel.text = self.convertDateFormat(inputDate: model.createdOn,outputFormat: "dd-MM-yyyy h:mm a")
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension CreditMonitoringCommentsVC {
    func createRemarks(json: JSON) {
        var url = APIEnums.retrieveCreditMonitoringComments.rawValue
        if self.loanId != "" {
            url = url + "\(self.loanId)/\(self.mandateId)/"
        }
        APIService.shared.makeRequest(endpoint: url,
                                      withLoader: true,
                                      method: .post,
                                      params: json) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 201 {
                    self.fetchCreditMonitoringListDetails()
                    self.commentsTF.text = ""
                    self.leadsTable.reloadData()
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
    func moveToLegalStatus() {
        var url = APIEnums.moveToLegal.rawValue
        if self.loanId != "" {
            url = url + "\(self.loanId)/"
        }
        APIService.shared.makeRequest(endpoint: url,
                                      withLoader: true,
                                      method: .post,
                                      params: JSON()) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    self.navigationController?.popViewController(animated: true)
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
}
extension CreditMonitoringCommentsVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.commentsTF:
            if (self.commentsTF.text != nil || self.commentsTF.text != "") {
                
            }
        default:
            break
        }
        
    }
}
