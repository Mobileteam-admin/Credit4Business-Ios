//
//  AddressTableViewCell.swift
//  Credit4Business
//
//  Created by MacMini on 26/03/24.
//

import UIKit
protocol AddressCellDelegate {
    func addressReload()
    func increaseAddressField()
    func particularReload()
    func showAlertForCell(title: String)
}
class AddressTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var addressView: UIStackView!
//    @IBOutlet weak var addressTitleLabel: UILabel!
//    @IBOutlet weak var addressTF: UITextField!
//    @IBOutlet weak var addressErrStack: UIStackView!
//    @IBOutlet weak var addressErrLabel: UILabel!
    
    @IBOutlet weak var postcodeTypeView: UIStackView!
    @IBOutlet weak var postcodeTypeTF: UITextField!
    @IBOutlet weak var postcodeTableHeight: NSLayoutConstraint!
    @IBOutlet weak var postcodeTable: UITableView!
    @IBOutlet weak var postcodeTableArrowActionView: UIView!
    @IBOutlet weak var postcodeTableArrow: UIImageView!
    @IBOutlet weak var postcodeTypeErrLabel: UILabel!
    @IBOutlet weak var postcodeTypeErrStack: UIStackView!
    
    @IBOutlet weak var houseTypeView: UIStackView!
    @IBOutlet weak var houseTypeTF: UITextField!
    @IBOutlet weak var houseTableHeight: NSLayoutConstraint!
    @IBOutlet weak var houseTable: UITableView!
    @IBOutlet weak var houseTableArrowActionView: UIView!
    @IBOutlet weak var houseTableArrow: UIImageView!
    @IBOutlet weak var houseTypeErrLabel: UILabel!
    @IBOutlet weak var houseTypeErrStack: UIStackView!

    @IBOutlet weak var addressDetailsView: UIView!
    @IBOutlet weak var addressDetailsTF: UITextField!
    @IBOutlet weak var addressDetailsErrLabel: UILabel!
    @IBOutlet weak var addressDetailsErrStack: UIStackView!

    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var startDateTF: UITextField!
    @IBOutlet weak var DateErrLabel: UILabel!
    @IBOutlet weak var DateErrStack: UIStackView!
    @IBOutlet weak var endDateView: UIView!
    @IBOutlet weak var endDateTF: UITextField!
    @IBOutlet weak var startDateArrowActionView: UIView!
    @IBOutlet weak var startDateTableArrow: UIImageView!
    @IBOutlet weak var endDateArrowActionView: UIView!
    @IBOutlet weak var endDateTableArrow: UIImageView!

    var model = AddressAloneModel()
    var postcodeTableHidden = true
    var houseTypeTableHidden = true
    var selectedHouseType : Common?
    var selectedPostcode : String?
    var dropdownType : DropDownType = .none
    var delegate : AddressCellDelegate!
    var viewModel : HomeVM!
//    var startDate : Date?
//    var endDate : Date?

    //MARK: -------------------------- Life Cycle Method --------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDelegates()
        self.addObserverOnHeightTbl()
    }
    func setDelegates() {
//        self.addressTF.delegate = self
        
        self.postcodeTable.delegate = self
        self.postcodeTable.dataSource = self
        self.houseTable.delegate = self
        self.houseTable.dataSource = self
        self.addressDetailsTF.delegate = self
        self.startDateTF.delegate = self
        self.endDateTF.delegate = self
        self.startDateTF.keyboardType = .numberPad
        self.endDateTF.keyboardType = .numberPad
        self.postcodeTypeTF.delegate = self
    }
    func validatingDates() {
        if self.model.startDateObj != nil && self.model.endDateObj != nil {
//            var edit = false
//            if self.model.yearsOfStay != 0 || self.model.monthsOfStay != 0 {
//                edit = true
//            }
            var (month,year) = self.DaysComparison(start: self.model.startDateObj!, end: self.model.endDateObj!)
            print(month)
            print(year)
            self.model.yearsOfStay = year
            self.model.monthsOfStay = month
//            self.model.dateRange = (self.startDate ?? Date())...(self.endDate ?? Date())
            self.updateYearsValue(edit: false)
        }
    }
    func DaysComparison(start: Date, end: Date) -> (Int,Int) {
        let calendar = Calendar.current
        guard let year = calendar.dateComponents([.year,.month], from: start, to: end).year else {
              
              return (0,0)
            }
        guard var month = calendar.dateComponents([.month], from: start, to: end).month else {
              
              return (0,0)
            }
        if month >= 12 {
            month = month % 12
        }
        return(month,year)
    }
    func showHideTable() {
        switch self.dropdownType {
        case .RegPost:
            if self.postcodeTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        case .House:
            if self.houseTypeTableHidden {
                self.removeTransparentView ()
            }else{
                self.addTransparentView()
            }
        default:
            break
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
//extension AddressTableViewCell : UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == self.addressTF {
//            self.model.address = textField.text ?? ""
//            self.addressTF.text = self.model.address
//            self.delegate.reload()
//        }
//    }
//}
extension AddressTableViewCell {
    func addTransparentView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
//                switch self.dropdownType {
//                case .RegPost:
//                    if !self.postcodeTableHidden {
//                        self.postcodeTable.isHidden = false
//                        self.postcodeTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
//                        self.postcodeTable.reloadData()
//                        self.layoutIfNeeded()
//                    }
//
//                case .House:
//                    self.houseTable.isHidden = false
//                    self.houseTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
//                    self.houseTable.reloadData()
//                    self.layoutIfNeeded()
//                default:
//                    break
//
//                }
                if !self.postcodeTableHidden {
                    self.postcodeTable.isHidden = false
                    self.postcodeTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                    self.postcodeTable.reloadData()
                    self.layoutIfNeeded()
                }
                if !self.houseTypeTableHidden {
                    self.houseTable.isHidden = false
                    self.houseTableArrow.image = UIImage(systemName: "chevron.up")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
                    self.houseTable.reloadData()
                    self.layoutIfNeeded()
                }
                
            }, completion: nil)
        }
        
    }
    
    @objc func removeTransparentView() {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            switch self.dropdownType {
            case .RegPost:
                self.postcodeTable.isHidden = true
                self.postcodeTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
//                self.postcodeTableHeight.constant = 0
                self.postcodeTable.reloadData()

            case .House:
                self.houseTable.isHidden = true
                self.houseTableArrow.image = UIImage(systemName: "chevron.down")?.withTintColor(UIColor.init(named: "darkBlue") ?? .blue)
//                self.houseTableHeight.constant = 0
                self.houseTable.reloadData()

            default:
                break
                
            }
        }, completion: nil)
    }
    func updateYearsValue(edit: Bool) {
        var newArray1 = [AddressAloneModel]()
        var copycat = false
        var selectedIndex = 0
        for (index,element) in self.viewModel.addressArray.enumerated() {
//            if element.startDateObj != nil && element.endDateObj != nil {
//                var dateRange = (element.startDateObj ?? Date())...(element.endDateObj ?? Date())
//                if dateRange.contains(selectedStartDate ?? Date()) || dateRange.contains(selectedEndDate ?? Date()){
//
//                    if (self.model.yearsOfStay != element.yearsOfStay || self.model.monthsOfStay != element.monthsOfStay) {
//                        copycat = true
//
//                }
//                }
//            }
            if element.startDateObj != nil && element.endDateObj != nil {
//                var dateRange = (element.startDateObj ?? Date())...(element.endDateObj ?? Date())
                let dateRange = Date.dates(from: element.startDateObj ?? Date(), to: element.endDateObj ?? Date())
                var array = [String]()
//                for item in dateRange {
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "ddMMMyyyy"//DateTimeFormaterEnum.ddMMMyyyy.rawValue
//                    let fromDateString = dateFormatter.string(from: item ?? Date())
//                    array.append(fromDateString)
//                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "ddMMMyyyy"
                let fromDateString = dateFormatter.string(from: selectedStartDate ?? Date())
                
                let toDateString = dateFormatter.string(from: selectedEndDate ?? Date())
                
                if array.contains(fromDateString) || array.contains(toDateString){
                    
                    if (self.model.yearsOfStay != element.yearsOfStay || self.model.monthsOfStay != element.monthsOfStay) {
                        copycat = true
                    
                }
                }
            }
        }
        if copycat {
//            var element = self.viewModel.addressArray.filter({$0.startDateObj == selectedStartDate && $0.endDateObj == selectedEndDate && $0.monthsOfStay == self.model.monthsOfStay && $0.yearsOfStay == self.model.yearsOfStay})
            var element = self.viewModel.addressArray.filter({$0.startDateObj == selectedStartDate || $0.endDateObj == selectedEndDate})

            element.last?.yearsOfStay = 0
            element.last?.monthsOfStay = 0
            element.last?.startDate = nil
            element.last?.endDate = nil
            element.last?.startDateObj = nil
            element.last?.endDateObj = nil
            self.delegate.addressReload()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.delegate.showAlertForCell(title: "Start date or End date should not be inside the range of previously selected dates")
            }
            return

        }
        var arr = self.viewModel.addressArray
        var newArray = [AddressAloneModel]()
        var count = 0
        for element in arr {
            if element.yearsOfStay != 0 || element.monthsOfStay != 0 {
                newArray.append(element)
                count = count + element.yearsOfStay * 12 + element.monthsOfStay
            }
            if count >= 36 {
//                newArray.append(element)
                self.viewModel.addressArray = newArray
                self.delegate.addressReload()
                return
            }
        }
        if count < 36 && !edit {
            self.delegate.increaseAddressField()
        }
    }
}
extension AddressTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        guard let viewModel = self.viewModel else {return 0}
        if tableView == postcodeTable {
            count = self.viewModel.postalLookupArray.count
        }
        else if tableView == houseTable {
            count = self.viewModel.houseOwnershipArray.count
        }
        else{
            count = 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if  tableView == postcodeTable {
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
//                self.postcodeTypeTF.text = "\(self.viewModel.postalLookupArray.value(atSafe: indexPath.row)?.description ?? "")"
                guard let model = self.viewModel.postalLookupArray.value(atSafe: indexPath.row) else{
                    return
                }
                if model.Selected == "true" && self.viewModel.postalLookupArray.count == 1{
                    
                     //self.viewModel.postalLookupArray.value(atSafe: indexPath.row)?.Sid ?? ""
                    self.addressDetailsTF.text = model.Label1 + "," + model.Label2 + "," + model.Label3 + "," + model.Label4
                    self.model.address = model.Label1 + "," + model.Label2 + "," + model.Label3 + "," + model.Label4
                    self.postcodeTypeErrStack.isHidden = true
                    //self.model.postCode = self.selectedPostcode
                    self.model.isPostcodeExtended = false
                    self.postcodeTable.isHidden = true
                    self.postcodeTableHidden = true
                    self.postcodeTable.reloadData()
                    guard let del = self.delegate else {return}
                    del.particularReload()
                }else{
                    self.callPostcodeLookupSidAPI(parms: ["address_sid": model.Sid ?? ""])
                }
            }
            return cell
        }
        
        else if self.dropdownType == .House && (tableView == houseTable && !self.houseTypeTableHidden) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? CellClass else {
                return UITableViewCell()
            }
            cell.documentLabel.text = self.viewModel.houseOwnershipArray.value(atSafe: indexPath.row)?.description
            cell.documentSelectAction.setTitle("", for: .normal)
            cell.separatorLabel.isHidden = (indexPath.row == self.viewModel.houseOwnershipArray.count - 1)
            cell.documentSelectAction.addTapGestureRecognizer {
                self.houseTypeTF.text = "\(self.viewModel.houseOwnershipArray.value(atSafe: indexPath.row)?.description ?? "")"
                self.selectedHouseType = self.viewModel.houseOwnershipArray.value(atSafe: indexPath.row)
                self.model.houseOwnership = self.selectedHouseType
                self.model.isHouseExtended = !self.model.isHouseExtended
                self.houseTable.isHidden = true
                self.houseTypeTableHidden = true
                self.dropdownType = .House
                self.showHideTable()
                guard let del = self.delegate else {return}
                del.particularReload()
                self.houseTypeErrStack.isHidden = true
            }
            return cell

        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


//MARK: -------------------------- UITextField Delegate Methods --------------------------
extension AddressTableViewCell : UITextFieldDelegate {
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.startDateTF {
            self.DateErrStack.isHidden = true
        }
        if textField == self.endDateTF {
            self.DateErrStack.isHidden = true
        }
//        if textField == self.addressDetailsTF {
//            self.model.address = textField.text ?? ""
//            self.addressDetailsTF.text = self.model.address
//            self.delegate.addressReload()
//            self.addressDetailsErrStack.isHidden = true
//        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
       
        case self.startDateTF:
            if (self.startDateTF.text == nil || self.startDateTF.text == "") {
                self.DateErrStack.isHidden = false
                self.DateErrLabel.text = "Please enter the Year Of Stay"
                self.model.yearsOfStay = 0
            }else{
               // self.model.yearsOfStay = textField.text?.toInt() ?? 0
            }
            if ((self.startDateTF.text?.toInt() ?? 0) != 0) {
                self.updateYearsValue(edit: false)
            }
        case self.endDateTF:
            if (self.endDateTF.text == nil || self.endDateTF.text == "") {
                self.DateErrStack.isHidden = false
                self.DateErrLabel.text = "Please enter the Month Of Stay"
                self.model.monthsOfStay = 0
            }
            else{
               // self.model.monthsOfStay = textField.text?.toInt() ?? 0
            }
//            if self.endDateTF.text?.toInt() ?? 0 < 3 && self.endDateTF.text != ""{
//                self.updateYearsValue()
//            }
        case self.addressDetailsTF:
            if (self.addressDetailsTF.text == nil || self.addressDetailsTF.text == "") {
                self.addressDetailsErrStack.isHidden = false
                self.addressDetailsErrLabel.text = "Please enter the Address"
            }
            else{
                self.model.address = textField.text ?? ""
            }
        case self.postcodeTypeTF:
            let cell: AddressTableViewCell = textField.superview?.superview?.superview?.superview?.superview?.superview?.superview?.superview as! AddressTableViewCell
            let table: UITableView = cell.superview as! UITableView
            textFieldIndexPath = table.indexPath(for: cell)!
            postCodeCell = cell
            let eTest       = NSPredicate(format:"SELF MATCHES %@", Validations.RegexType.AllowPincode.rawValue)
            let result      = eTest.evaluate(with: self.postcodeTypeTF.text?.trim())

            if (self.postcodeTypeTF.text == nil || self.postcodeTypeTF.text == "") {
                self.postcodeTypeErrStack.isHidden = false
                self.postcodeTypeErrLabel.text = "Please enter the Postcode"
                self.model.postCode = ""
                self.model.isPostcodeExtended = false
                self.delegate.particularReload()
            }
            else if result == false {
                self.postcodeTypeErrStack.isHidden = false
                self.postcodeTypeErrLabel.text = "Valid UK Postcode is required"
                self.model.postCode = ""
                self.model.isPostcodeExtended = false
                self.delegate.particularReload()
            }
            else{
                self.addressDetailsTF.text = ""
                self.postcodeTypeErrStack.isHidden = true
                self.selectedPostcode = self.postcodeTypeTF.text
                self.model.postCode = self.selectedPostcode
                self.callPostcodeLookupAPI(parms: ["address": self.postcodeTypeTF.text?.trim() ?? ""])
            }
        default:
            break
        }
        self.delegate.particularReload()
        //        self.updateNextButton()
    }
    func callPostcodeLookupAPI(parms: [AnyHashable: Any]){
        self.viewModel
            .PostcodeLookupApicall(parms: parms){(result) in
                switch result{
                case .success(let responseDict):
                    print(responseDict)
                    self.viewModel.postalLookupArray.removeAll()
                    self.viewModel.postalLookupArray = responseDict.data.Results.Items
//                    self.dropdownType = .RegPost
//                    self.postcodeTableHidden = false//!self.postcodeTableHidden
                    guard let model = self.viewModel.addressArray.value(atSafe: textFieldIndexPath.row) else {return}
                    model.isPostcodeExtended = true
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
         
                            postCodeCell?.postcodeTable.isHidden = false
                            postCodeCell?.postcodeTable.reloadData()
                            postCodeCell?.layoutIfNeeded()
                        }, completion: nil)
                    }
                    self.delegate.particularReload()
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
                  //  self.postcodeTableHeight.constant = CGFloat(self.viewModel.postalLookupArray.count * 50)

                    postCodeCell?.postcodeTable.reloadData()
                    postCodeCell?.layoutIfNeeded()
                    self.delegate.particularReload()
                    break
                case .failure(let error):
                    break
                }
            }
    }
}
//MARK: -------------------------- Observers Methods --------------------------
extension AddressTableViewCell {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.postcodeTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.postcodeTableHeight.constant = newvalue.height
        }
        if let obj = object as? UITableView, obj == self.houseTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.houseTableHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.houseTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.postcodeTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.houseTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        guard let tblView = self.postcodeTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}
