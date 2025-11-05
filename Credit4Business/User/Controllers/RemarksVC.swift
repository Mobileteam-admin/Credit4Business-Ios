//
//  RemarksVC.swift
//  Credit4Business
//
//  Created by MacMini on 14/08/24.
//

import UIKit
import IQKeyboardManagerSwift
class RemarksVC: UIViewController, CellDelegate {
    func reload() {
        self.remarksTable.reloadData()
    }
    
    func particularReloadOf() {
        
    }
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentsTF: UITextField!
    @IBOutlet weak var remarksTable: UITableView!
    @IBOutlet weak var remarksTableHeight: NSLayoutConstraint!
    @IBOutlet weak var dismissImage: UIImageView!
    
    //MARK: -------------------- Class Variable --------------------
    var delegate : CellDelegate?
    var loanId = ""
    var remarksArray = [RemarksData]()
    var isRemarks = true
    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.manageActionMethods()
        self.addObserverOnHeightTbl()
        self.fetchRemarkDetails()
        self.commentsTF.delegate = self
        self.commentsTF.placeholder = "Add a Comment"
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
        self.remarksTable.delegate = self
        self.remarksTable.dataSource = self
    }
    func manageActionMethods() {
        self.dismissImage.addTapGestureRecognizer {
            self.dismiss(animated: true)
        }
        self.sendButton.addTapGestureRecognizer {
            var dict = JSON()
            if self.isRemarks {
                dict["remarks"] = self.commentsTF.text
            }else{
                dict["comment"] = self.commentsTF.text
            }
            self.createRemarks(json: dict)
        }
    }
    class func initWithStory(loanId: String) -> RemarksVC {
        let vc : RemarksVC = UIStoryboard.Login.instantiateViewController()
        vc.loanId = loanId
        return vc
    }
    func fetchRemarkDetails() {
        APIService.shared.retrieveRemarkDetails(isRemarks: self.isRemarks,loanId: self.loanId ) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.remarksArray = data.data
                        self.remarksTable.reloadData()
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
extension RemarksVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.remarksArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == remarksTable {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "leadsCell2", for: indexPath) as? LeadsCell else {
                    return UITableViewCell()
                }
            guard let model = self.remarksArray.value(atSafe: indexPath.row) else {return UITableViewCell()}
            if model.remarks == nil {
                cell.textMessage.text = model.comments
            }else{
                cell.textMessage.text = model.remarks
            }
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
//MARK: -------------------------- Observers Methods --------------------------
extension RemarksVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.remarksTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.remarksTableHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.remarksTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.remarksTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    func createRemarks(json: JSON) {
        var url = self.isRemarks ? APIEnums.retrieveRemarks.rawValue : APIEnums.retrieveComments.rawValue
        if self.loanId != "" {
            url = url + "\(self.loanId)/"
        }
        APIService.shared.makeRequest(endpoint: url,
                                      withLoader: true,
                                      method: .post,
                                      params: json) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    self.fetchRemarkDetails()
                    self.commentsTF.text = ""
                    self.remarksTable.reloadData()
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
extension RemarksVC : UITextFieldDelegate {
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
