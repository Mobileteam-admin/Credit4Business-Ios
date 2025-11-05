//
//  EditProfileVC.swift
//  Credit4Business
//
//  Created by MacMini on 16/05/24.
//

import UIKit
import IQKeyboardManagerSwift

class EditProfileVC: UIViewController, CellDelegate {
    func reload() {
        self.profileTable.reloadData()
    }
    
    func particularReloadOf() {
        
    }
    
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var profileTable: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var profileTableHeight: NSLayoutConstraint!
    @IBOutlet weak var dismissImage: UIImageView!

    //MARK: -------------------- Class Variable --------------------
    var viewModel = HomeVM()
    var personalKVArray = [MenuModel]()
    var delegate : CellDelegate?
    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.manageActionMethods()
        self.addObserverOnHeightTbl()
        // Do any additional setup after loading the view.
    }
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.isEnabled = true
    }
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.isEnabled = false
    }

    func setDelegates() {
        self.profileTable.delegate = self
        self.profileTable.dataSource = self
    }
    func manageActionMethods() {
        self.dismissImage.addTapGestureRecognizer {
            self.dismiss(animated: true)
        }
        self.submitBtn.addTapGestureRecognizer {
            if self.goNext() {
                var dicts = JSON()
                for item in self.personalKVArray {
//                    if item.apiKey != "location" {
                        dicts["\(item.apiKey)"] = item.value
//                    }
                }
                if UserDefaults.standard.value(forKey: "role") as! String == "FIELDAGENT"{
                    self.updateAgentProfileDetails(json: dicts)
                }else{
                    self.updateProfileDetails(json: dicts)
                }
            }
        }
    }
    func goNext() -> Bool {
       
        for item in self.personalKVArray {
//            if item.isError {
            if item.value == "" {
                item.isError = true
                item.error = "Please enter \(item.title)"
                self.profileTable.reloadData()
                return false
            }
        }
        return true
    }
    func updateProfileDetails(json: JSON) {
        APIService.shared.updateProfileDetailsApi(endpoint: APIEnums.retrieveProfileDetails.rawValue,
                                      withLoader: true,
                                      method: .patch,
                                      params: json) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode.description.toInt() == 200 {
                    self.delegate?.reload()
                    self.dismiss(animated: true)
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
    func updateAgentProfileDetails(json: JSON) {
        APIService.shared.updateAgentProfileDetailsApi(endpoint: APIEnums.retrieveAgentProfileDetails.rawValue,
                                      withLoader: true,
                                      method: .patch,
                                      params: json) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode.description.toInt() == 200 {
                    self.delegate?.reload()
                    self.dismiss(animated: true)
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
    //---------------------------------------
    // MARK: - Init With Story
    //---------------------------------------

    class func initWithStory() -> EditProfileVC {
        let vc : EditProfileVC = UIStoryboard.Login.instantiateViewController()
        return vc
    }

}
extension EditProfileVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.personalKVArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == profileTable {
            if self.personalKVArray.value(atSafe: indexPath.row)?.title.lowercased() == "address" || self.personalKVArray.value(atSafe: indexPath.row)?.title.lowercased() == "location"  {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "editProfileAddressCell", for: indexPath) as? EditProfileAddressCell else {
                    return UITableViewCell()
                }
                cell.model = self.personalKVArray.value(atSafe: indexPath.row)
                if cell.model?.isExtended ?? false {
                    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                        
                        cell.cityTable.isHidden = false
                        cell.cityTable.reloadData()
                        cell.layoutIfNeeded()
                    }, completion: nil)
                }else{
                    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                        cell.cityTable.isHidden = true
                        cell.cityTable.reloadData()
                        }, completion: nil)
                }
                cell.delegate = self
                if cell.model?.isError ?? false {
                    cell.errStackView.isHidden = false
                    cell.errLabel.text = cell.model?.error
                }else{
                    cell.errStackView.isHidden = true
                    cell.errLabel.text = ""
                }
                cell.titleLabel.text = self.personalKVArray.value(atSafe: indexPath.row)?.title
                cell.cityTF.placeholder = self.personalKVArray.value(atSafe: indexPath.row)?.title
                cell.cityTF.text = self.personalKVArray.value(atSafe: indexPath.row)?.value
                return cell

            }else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "editProfileTableViewCell", for: indexPath) as? EditProfileTableViewCell else {
                    return UITableViewCell()
                }
                cell.titleLabel.text = self.personalKVArray.value(atSafe: indexPath.row)?.title
                cell.dobTextField.isHidden = true

                if cell.titleLabel.text == "Date Of Birth" {
                    cell.dobTextField.isHidden = false
                    cell.profileTextField.isHidden = true
                    cell.genderView.isHidden = true
                    cell.dobTextField.text = self.personalKVArray.value(atSafe: indexPath.row)?.value
                }
                else if cell.titleLabel.text?.lowercased() == "gender" {
                    cell.genderView.isHidden = false
                    cell.profileTextField.isHidden = true
                    cell.maleImage.image =  self.personalKVArray.value(atSafe: indexPath.row)?.value == "M" ? UIImage.init(named: "radioSelected") : UIImage.init(named: "radioUnselected")
                    cell.femaleImage.image = self.personalKVArray.value(atSafe: indexPath.row)?.value == "F" ? UIImage.init(named: "radioSelected") : UIImage.init(named: "radioUnselected")
                }else{
                    cell.genderView.isHidden = true
                    cell.profileTextField.isHidden = false
                    cell.profileTextField.text = self.personalKVArray.value(atSafe: indexPath.row)?.value
                    cell.profileTextField.placeholder = self.personalKVArray.value(atSafe: indexPath.row)?.title
                    cell.profileTextField.tag = indexPath.row
                }
                cell.maleView.addTapGestureRecognizer {
                    cell.maleImage.image = UIImage.init(named: "radioSelected")
                    cell.femaleImage.image = UIImage.init(named: "radioUnselected")
                    self.personalKVArray.value(atSafe: indexPath.row)?.value = "M"
                    cell.model?.isError = false
                    cell.model?.error = ""
                    self.profileTable.reloadData()
                }
                cell.femaleView.addTapGestureRecognizer {
                    cell.maleImage.image = UIImage.init(named: "radioUnselected")
                    cell.femaleImage.image = UIImage.init(named: "radioSelected")
                    self.personalKVArray.value(atSafe: indexPath.row)?.value = "F"
                    cell.model?.isError = false
                    cell.model?.error = ""
                    self.profileTable.reloadData()
                }
                cell.dobTextField.addTapGestureRecognizer {
                let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
                     popup.modalPresentationStyle = .overFullScreen
                     popup.isReadableFormat = true
                     self.present(popup, animated: true, completion: nil)
                     popup.dateSelectionHandler = { [weak self] fromDate, toDate in
                         print(fromDate)
                         let dateFormatter = DateFormatter()
                         dateFormatter.dateFormat = "yyyy-MM-dd"//DateTimeFormaterEnum.ddMMMyyyy.rawValue
                         let fromDateString = dateFormatter.string(from: toDate ?? Date())
                         self?.personalKVArray.value(atSafe: indexPath.row)?.value = fromDateString
                         cell.model?.isError = false
                         cell.model?.error = ""
                         cell.dobTextField.text = fromDateString
                         self?.profileTable.reloadData()
                         self?.dismiss(animated: true)
                     }
                }
                cell.model = self.personalKVArray.value(atSafe: indexPath.row)
                cell.delegate = self
                if cell.model?.isError ?? false {
                    cell.errStackView.isHidden = false
                    cell.errLabel.text = cell.model?.error
                }else{
                    cell.errStackView.isHidden = true
                    cell.errLabel.text = ""
                }
                return cell
            }
           
        }

        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
//MARK: -------------------------- Observers Methods --------------------------
extension EditProfileVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.profileTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.profileTableHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
        self.profileTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.profileTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

