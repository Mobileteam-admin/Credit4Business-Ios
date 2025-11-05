//
//  EditProfileAddressCell.swift
//  Credit4Business
//
//  Created by MacMini on 31/05/24.
//

import UIKit

class EditProfileAddressCell: UITableViewCell {

    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var errStackView: UIStackView!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cityTableHeight: NSLayoutConstraint!
    @IBOutlet weak var cityTable: UITableView!
    var selectedCity : String?
    var cityTableHidden = true
    var viewModel = HomeVM()
    var model : MenuModel?
    var delegate : CellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addObserverOnHeightTbl()
        self.cityTF.delegate = self
        self.cityTable.delegate = self
        self.cityTable.dataSource = self

    }
//    func showHideTable() {
//            if self.cityTableHidden {
//                self.removeTransparentView ()
//            }else{
//                self.addTransparentView()
//            }
//
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
//MARK: -------------------------- UITextField Delegate Methods --------------------------
extension EditProfileAddressCell : UITextFieldDelegate {
    

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.cityTF {
            self.model?.isError = false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        switch textField {
        case self.cityTF:
            let eTest       = NSPredicate(format:"SELF MATCHES %@", Validations.RegexType.AllowPincode.rawValue)
            let result      = eTest.evaluate(with: self.cityTF.text?.trim())

            if (self.cityTF.text == nil || self.cityTF.text == "") {
                self.model?.isError = true
                self.model?.error = "Please enter Address"
                self.model?.pincode = ""
                self.model?.isExtended = false
                self.delegate?.reload()
            }
            else if result == false {
                self.model?.isError = true
                self.model?.error = "Valid UK Postcode is required"
                self.model?.isExtended = false
                self.model?.pincode = ""
                self.delegate?.reload()
            }
            else{
//                self.cityTF.text = ""
//                self.selectedCity = ""
//                self.cityErrStack.isHidden = true
                self.model?.isError = false
                self.model?.error = ""
                self.model?.pincode = self.cityTF.text ?? ""
                self.callPostcodeLookupAPI(parms: ["address": self.cityTF.text?.trim() ?? ""])
            }
       
        default:
            break
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
//                    self.cityTableHidden = !self.cityTableHidden
                    self.model?.isExtended = true
                    self.delegate?.reload()
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
                    self.delegate?.reload()

                    self.layoutIfNeeded()
                    break
                case .failure(let error):
                    break
                }
            }
    }
    func addTransparentView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                    self.cityTable.isHidden = false
                    self.cityTableHeight.constant = CGFloat(self.viewModel.postalLookupArray.count * 50)
                    self.cityTable.reloadData()
                    self.layoutIfNeeded()
               
            }, completion: nil)
        }
        
    }
    
    @objc func removeTransparentView() {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.cityTable.isHidden = true
                self.cityTableHeight.constant = 0
                self.cityTable.reloadData()
           
        }, completion: nil)
    }
}
extension EditProfileAddressCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView == cityTable {
            count = self.viewModel.postalLookupArray.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == cityTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? CellClass else {
                return UITableViewCell()
            }
            cell.documentLabel.text = self.viewModel.postalLookupArray.value(atSafe: indexPath.row)?.ItemText ?? ""
            cell.documentSelectAction.setTitle("", for: .normal)
            cell.separatorLabel.isHidden = (indexPath.row == self.viewModel.postalLookupArray.count - 1)
            cell.documentSelectAction.addTapGestureRecognizer {
                guard let model = self.viewModel.postalLookupArray.value(atSafe: indexPath.row) else{
                    return
                }
                if model.Selected == "true" && self.viewModel.postalLookupArray.count == 1{
                    self.selectedCity = self.viewModel.postalLookupArray.value(atSafe: indexPath.row)?.Sid ?? ""
                    self.cityTF.text = model.Label1 + "," + model.Label2 + "," + model.Label3 + "," + model.Label4
                    self.errStackView.isHidden = true
                    self.model?.value = self.cityTF.text ?? ""
//                    self.pincodeTF.text = model.Label5
                   // self.cityTableHidden = !self.cityTableHidden
                   // self.removeTransparentView()
                    self.model?.isExtended = false
                    self.delegate?.reload()
                }else{
                    self.callPostcodeLookupSidAPI(parms: ["address_sid": model.Sid ?? ""])

                }
                
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
//MARK: -------------------------- Observers Methods --------------------------
extension EditProfileAddressCell {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.cityTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.cityTableHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.cityTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.cityTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
