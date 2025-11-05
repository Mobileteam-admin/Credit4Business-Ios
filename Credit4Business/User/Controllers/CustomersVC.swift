//
//  CustomersVC.swift
//  Credit4Business
//
//  Created by MacMini on 14/05/24.
//

import UIKit

class CustomersVC: UIViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var leadsTable: UITableView!
    @IBOutlet weak var searchTextField: UITextField!

    @IBOutlet weak var searchView: UIView!
    //MARK: -------------------- Class Variable --------------------
    var viewModel = HomeVM()
    var customerModel = [CustomerData]()
    var customerObject : CustomerModel?
    var searchList = [CustomerData]()
    var currentTripPageIndex = 1{
        didSet {
            print(currentTripPageIndex.description)
        }
    }
    var totalTripPages = 1{
        didSet {
            print(totalTripPages.description)
        }
    }
    var HittedTripPageIndex = 0
    var oneTimeForHistory : Bool = true

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
        super.viewDidAppear(animated)
        self.customerModel.removeAll()
        self.searchList.removeAll()
        self.currentTripPageIndex = 0
        self.HittedTripPageIndex = 0
        self.fetchCustomerDetails(url: APIEnums.customersList.rawValue)

    }
    func setDelegates() {
        self.leadsTable.delegate = self
        self.leadsTable.dataSource = self
        self.backBtn.isHidden = true
        self.searchView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.searchView.layer.borderWidth = 1
        self.searchTextField.delegate = self
    }
    func manageActionMethods() {
        self.backBtn.addTapGestureRecognizer {
            //self.navigationController?.popViewController(animated: true)
//            if let tabbar = self.parent?.parent as? TabBarController {
//                if let navigationController = tabbar.parent as? UINavigationController {
//                    tabbar.selectedIndex = 0
//                }
//            }
        }
    }
    func clearSearchText() {
        self.searchTextField.text = ""
        self.searchList = self.customerModel
        //self.searchList = self.searchList.sorted(by: {$0.firstName < $1.firstName })
        self.leadsTable.reloadData()
    }
   
    func fetchCustomerDetails(url: String) {
        var page = self.currentTripPageIndex+1
        guard  self.HittedTripPageIndex != self.currentTripPageIndex + 1 else {
            return
        }
        var urlStr = APIEnums.customersList.rawValue
        if page != 1 {
            urlStr = urlStr + "?page=\(page)"
        }
        APIService.shared.retrieveCustomerDetails(url: urlStr) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.customerObject = data
                        self.customerModel.append(contentsOf: responseData)
                        self.searchList.append(contentsOf: responseData)
                        var next = self.getQueryItems(data.next)
                        var last = self.getQueryItems(data.last)
                        var Lastitem = last.filter({$0.key == "page"}).first?.value
                        var currentItem = next.filter({$0.key == "page"}).first?.value

                        self.totalTripPages = (Lastitem?.toInt() ?? 0)
                        self.currentTripPageIndex = (currentItem?.toInt() ?? 0) - 1
                        self.HittedTripPageIndex = (currentItem?.toInt() ?? 0) - 1

                      //  self.searchList = self.searchList.sorted(by: {$0.firstName < $1.firstName })

                        self.leadsTable.reloadData()
                    }
                    catch {
                        
                    }
                    self.oneTimeForHistory = true
                }
                else {
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    //---------------------------------------
    // MARK: - Init With Story
    //---------------------------------------

    class func initWithStory() -> CustomersVC {
        let vc : CustomersVC = UIStoryboard.Login.instantiateViewController()
        return vc
    }
}
extension CustomersVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leadsTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "leadsCell", for: indexPath) as? LeadsCell else {
                return UITableViewCell()
            }
//            guard let model = self.viewModel.paymentArray.value(atSafe: indexPath.row) else {return UITableViewCell()}
//
//            if model.isExtended{
//                cell.innerTable.isHidden = false
//                cell.innerTableHidden = false
//                cell.showHideTable()
//
//            }else{
//                cell.innerTable.isHidden = true
//                cell.innerTableHidden = true
//                cell.showHideTable()
//
//            }
//            cell.model = model
//            cell.imageLabel.text = "Activity"
//
//            cell.delegate = self
//            cell.imageActionView.addTapGestureRecognizer {
//                cell.innerTableHidden = !cell.innerTableHidden
//                guard let model = self.viewModel.paymentArray.value(atSafe: indexPath.row) else {return}
//                model.isExtended = !model.isExtended
//                cell.showHideTable()
//                self.menuTable.reloadData()
//            }
            cell.leadsName.text = (self.searchList.value(atSafe: indexPath.row)?.firstName ?? "") + " " + (self.searchList.value(atSafe: indexPath.row)?.lastName ?? "")
            cell.leadsPhone.text = self.searchList.value(atSafe: indexPath.row)?.phoneNumber
            var model = self.searchList.value(atSafe: indexPath.row)
            cell.leadsImage.sd_setImage(with: URL(string: model?.image ?? ""))
            cell.leadsName.accessibilityHint = model?.id ?? ""
            return cell
        }

        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = self.searchList.value(atSafe: indexPath.row) else{
            return
        }
//        let vc = CustomerProfileVC.initWithStory(customerId: model.id,customerName: model.firstName,customerPhone: model.phoneNumber)
//        let vc = LoansVC.initWithStory(customerData: model)
//        self.navigationController?.pushViewController(vc, animated: true)
        let vc = CustomerProfileVC.initWithStory(customerId: model.id,customerName: model.firstName,customerPhone: model.phoneNumber)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension CustomersVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let range = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: range, with: string)
        
        switch textField {
        case self.searchTextField:
            
            DispatchQueue.main.async {
                if newText.trim() != "" {
                    self.searchList = self.customerModel.filter { $0.firstName.lowercased().contains(newText.lowercased()) }
                  //  self.searchList = self.searchList.sorted(by: {$0.firstName < $1.firstName })

                    if self.searchList.count == 0 {
                        self.view.endEditing(true)
                        self.showAlert(title: "", message: "Record Not Found", options: "Okay") { option in
                            self.clearSearchText()
                        }
                    }
                }
                else {
                    self.searchList = self.customerModel
                }
                self.leadsTable.reloadData()
            }
            break
            
        default: break
        }
        
        return true
    }
}
extension CustomersVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cell = leadsTable.visibleCells.last as? LeadsCell
        guard ((cell?.leadsName.text) != nil),
              (self.searchList.last != nil) else {return}
        if cell?.leadsName.accessibilityHint == (self.searchList.last?.id) &&
            self.customerObject?.next != "" && self.currentTripPageIndex != self.totalTripPages && oneTimeForHistory {
            self.fetchCustomerDetails(url: self.customerObject?.next ?? "")
            self.oneTimeForHistory = !self.oneTimeForHistory
        }
    }
}
