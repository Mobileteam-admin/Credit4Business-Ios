//
//  ServiceTileCVC.swift
//  GoferHandy
//
//  Created by Trioangle on 28/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit

class ServiceTileCVC: UICollectionViewCell {
    
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var serviceIV: UIImageView!
    
    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
class ItemTileCVC: UICollectionViewCell {
    
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var serviceIV: UIImageView!
    
    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
class CellClass: UITableViewCell {
    
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var documentSelectAction: UIButton!
    @IBOutlet weak var documentLabel: UILabel!
    //MARK: -------------------------- Life Cycle Method --------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
class CellClass2: UITableViewCell {
    
    @IBOutlet weak var separator1: UILabel!
    @IBOutlet weak var action1: UIButton!
    @IBOutlet weak var label1: UILabel!
    //MARK: -------------------------- Life Cycle Method --------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
class CellClass3: UITableViewCell {
    
    @IBOutlet weak var separator2: UILabel!
    @IBOutlet weak var action2: UIButton!
    @IBOutlet weak var label2: UILabel!
    //MARK: -------------------------- Life Cycle Method --------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
class CellClass4: UITableViewCell {
    
    @IBOutlet weak var separator3: UILabel!
    @IBOutlet weak var action3: UIButton!
    @IBOutlet weak var label3: UILabel!
    //MARK: -------------------------- Life Cycle Method --------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
class CellClass5: UITableViewCell {
    
    @IBOutlet weak var separator4: UILabel!
    @IBOutlet weak var action4: UIButton!
    @IBOutlet weak var label4: UILabel!
    //MARK: -------------------------- Life Cycle Method --------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
protocol CellDelegate {
    func reload()
    func particularReloadOf()
}
protocol SummaryCellDelegate {
    func summaryreload()
    func summaryparticularReloadOf()
    func selectedLoanId(id: Int)
}
protocol loanSubmitDelegate {
    func reload(loanDetails: LoanSubmitModel)
}
class AddressCell: UITableViewCell {
    
    @IBOutlet weak var addressView: UIStackView!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var addressErrStack: UIStackView!
    @IBOutlet weak var addressErrLabel: UILabel!
    
    @IBOutlet weak var cityTable: UITableView!
    
    @IBOutlet weak var cityTableHeight: NSLayoutConstraint!
    var model = PropertyAddressModel()
    var delegate : CellDelegate!
    var viewModel : HomeVM!
    var selectedCity : String?
    var cityTableHidden = true

    //MARK: -------------------------- Life Cycle Method --------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDelegates()
        self.updateUI()
    }
    func updateUI()
    {
//        self.addressView.layer.borderWidth = 0.5
//        self.addressView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
    }
    func setDelegates() {
        self.addressTF.delegate = self
        self.cityTable.delegate = self
        self.cityTable.dataSource = self
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
extension AddressCell : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == self.addressTF {
//            self.model.address = textField.text ?? ""
//            self.addressTF.text = self.model.address
//            self.delegate.reload()
//        }else{
        let cell: AddressCell = textField.superview?.superview?.superview?.superview?.superview?.superview?.superview?.superview as! AddressCell
        let table: UITableView = cell.superview as! UITableView
        propertyTextFieldIndexPath = table.indexPath(for: cell)!
        propertyCodeCell = cell

            let eTest       = NSPredicate(format:"SELF MATCHES %@", Validations.RegexType.AllowPincode.rawValue)
        let result      = eTest.evaluate(with: self.addressTF.text?.trim())

            if (self.addressTF.text == nil || self.addressTF.text == "") {
                self.addressErrStack.isHidden = false
                self.addressErrLabel.text = "Please enter Address"
                self.model.postCode = self.addressTF.text?.trim() ?? ""
                self.model.isExtended = false
                self.delegate.particularReloadOf()

            }
            else if result == false {
                self.addressErrStack.isHidden = false
                self.addressErrLabel.text = "Valid UK Postcode is required"
                self.model.postCode = self.addressTF.text?.trim() ?? ""
                self.model.isExtended = false
                self.delegate.particularReloadOf()
            }
            else{
//                self.cityTF.text = ""
//                self.selectedCity = ""
//                self.cityErrStack.isHidden = true
                self.model.postCode = self.addressTF.text ?? ""
                self.callPostcodeLookupAPI(parms: ["address": self.addressTF.text?.trim() ?? ""])
            }
//        }
    }
}

extension AddressCell: UITableViewDelegate, UITableViewDataSource {
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
            guard let model = self.viewModel.postalLookupArray.value(atSafe: indexPath.row) else{
                return cell
            }
            var modelText = model.ItemText
            var address = model.Label1 + "," + model.Label2 + "," + model.Label3 + "," + model.Label4
            cell.documentLabel.text = (modelText == "" && self.viewModel.postalLookupArray.count == 1) ? address : modelText

//            cell.documentLabel.text = self.viewModel.postalLookupArray.value(atSafe: indexPath.row)?.ItemText ?? ""
            cell.documentSelectAction.setTitle("", for: .normal)
            cell.separatorLabel.isHidden = (indexPath.row == self.viewModel.postalLookupArray.count - 1)
            cell.documentSelectAction.addTapGestureRecognizer {
                guard let model = self.viewModel.postalLookupArray.value(atSafe: indexPath.row) else{
                    return
                }
                if model.Selected == "true" && self.viewModel.postalLookupArray.count == 1{
                    self.model.address = model.Label1 + "," + model.Label2 + "," + model.Label3 + "," + model.Label4
                    self.addressTF.text = model.Label1 + "," + model.Label2 + "," + model.Label3 + "," + model.Label4
                    self.addressErrStack.isHidden = true
//                    self.pincodeTF.text = model.Label5
                    self.cityTableHidden = true
                    self.model.isExtended = false
                    self.removeTransparentView()
                    self.delegate.reload()
                    self.addressErrStack.isHidden = true
                }else{
                    self.callPostcodeLookupSidAPI(parms: ["address_sid": model.Sid ?? ""])

                }
                
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
}
extension AddressCell {
    func addTransparentView() {
//        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                    self.cityTable.isHidden = false
                    self.cityTableHeight.constant = CGFloat(self.viewModel.postalLookupArray.count * 50)
                    self.cityTable.reloadData()
                    self.layoutIfNeeded()
            }, completion: nil)
//        }
        
    }
    
    @objc func removeTransparentView() {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.cityTable.isHidden = true
                self.cityTableHeight.constant = 0
                self.cityTable.reloadData()
            self.layoutIfNeeded()

        }, completion: nil)
    }
    func callPostcodeLookupAPI(parms: [AnyHashable: Any]){
        self.viewModel
            .PostcodeLookupApicall(parms: parms){(result) in
                switch result{
                case .success(let responseDict):
                    print(responseDict)
                    self.viewModel.postalLookupArray.removeAll()
                    self.viewModel.postalLookupArray = responseDict.data.Results.Items
                    guard let model = self.viewModel.propertyArray.value(atSafe: propertyTextFieldIndexPath.row) else {return}
                    model.isExtended = true
                    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                        propertyCodeCell?.cityTable.isHidden = false
                        propertyCodeCell?.cityTableHeight.constant = CGFloat(self.viewModel.postalLookupArray.count * 50)
                        propertyCodeCell?.cityTable.reloadData()
                        propertyCodeCell?.layoutIfNeeded()
                    }, completion: nil)
                    self.delegate.particularReloadOf()
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
                    guard let model = self.viewModel.propertyArray.value(atSafe: propertyTextFieldIndexPath.row) else {return}
                    model.isExtended = true

                    self.cityTableHeight.constant = CGFloat(self.viewModel.postalLookupArray.count * 50)
                    self.cityTable.reloadData()
                    self.layoutIfNeeded()
                    self.delegate.reload()
                    break
                case .failure(let error):
                    break
                }
            }
    }
    func showHideTable() {
            if self.cityTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
    }
}
class NameCell: UITableViewCell {
    
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var imageActionView: UIView!
    
    @IBOutlet weak var outerView: UIStackView!
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var nameTableHeight: NSLayoutConstraint!
    @IBOutlet weak var nameTable: UITableView!

    var nameTableHidden = true
    var viewModel = HomeVM()
    var model = SelectedDirector()
    var delegate : CellDelegate!
    //MARK: -------------------------- Life Cycle Method --------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDelegates()
        self.updateUI()
        self.manageActionMethods()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    func setDelegates() {
        self.nameTable.delegate = self
        self.nameTable.dataSource = self
        self.addObserverOnHeightTbl()
        self.firstNameTF.delegate = self
        self.lastNameTF.delegate = self
    }
    func manageActionMethods() {
//        self.imageActionView.addTapGestureRecognizer {
//            self.nameTableHidden = !self.nameTableHidden
//            self.showHideTable()
//        }
    }
    func updateUI()
    {
//        self.imageActionView.layer.borderWidth = 0.5
//        self.imageActionView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
//        self.firstNameView.layer.borderWidth = 0.5
//        self.firstNameView.layer.borderColor = UIColor(named: "grayborder")?.cgColor
        self.outerView.layer.borderWidth = 0.5
        self.outerView.layer.borderColor = UIColor(named: "blue")?.cgColor

    }
    func showHideTable() {
            if self.nameTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
    }
}
extension NameCell {
    func addTransparentView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                    self.nameTable.isHidden = false
                    self.iconImage.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
//                    self.nameTableHeight.constant = CGFloat(self.viewModel.nameArray.count * 50)
                    self.nameTable.reloadData()
                    self.layoutIfNeeded()
            }, completion: nil)
        }
        
    }
    
    @objc func removeTransparentView() {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.nameTable.isHidden = true
                self.iconImage.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
//                self.nameTableHeight.constant = 0
                self.nameTable.reloadData()
        }, completion: nil)
    }
}
extension NameCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        count = self.viewModel.nameArray.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? CellClass2 else {
                return UITableViewCell()
            }
            cell.label1.text = self.viewModel.nameArray.value(atSafe: indexPath.row)?.description
            cell.action1.setTitle("", for: .normal)
            cell.separator1.isHidden = (indexPath.row == self.viewModel.nameArray.count - 1)
            cell.action1.addTapGestureRecognizer {
                self.imageLabel.text = "\(self.viewModel.nameArray.value(atSafe: indexPath.row)?.description ?? "")"
                self.model.isExtended = !(self.model.isExtended ?? false)
                self.model.title = "\(self.viewModel.nameArray.value(atSafe: indexPath.row)?.description ?? "")"
                self.nameTable.isHidden = true
                self.nameTableHidden = true
                self.showHideTable()
                guard let del = self.delegate else {return}
                del.reload()
                //self.nameErrStack.isHidden = true
        }
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
//MARK: -------------------------- Observers Methods --------------------------
extension NameCell {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.nameTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.nameTableHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.nameTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.nameTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
extension NameCell : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.firstNameTF {
            self.model.firstName = textField.text ?? ""
        }
        if textField == self.lastNameTF {
            self.model.lastName = textField.text ?? ""
        }
    }
}
class MenuClass: UITableViewCell {
    
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var menuLabel: UILabel!
    //MARK: -------------------------- Life Cycle Method --------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
