//
//  UnitsVC.swift
//  Credit4Business
//
//  Created by MacMini on 20/08/24.
//

import UIKit

class UnitsVC: UIViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var leadsTable: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchView: UIView!

    
    //MARK: -------------------- Class Variable --------------------
    var viewModel = HomeVM()
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
    var companyList = [CompanyList]()
    var searchList = [CompanyList]()
    var companyObject : CompanyListModel?
    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setDelegates()
        self.manageActionMethods()
        // Do any additional setup after loading the view.
        self.currentTripPageIndex = 0
        self.HittedTripPageIndex = 0
        self.fetchCompanyListDetails()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if let tabbar = self.parent?.parent as? TabBarController {
            if let navigationController = tabbar.parent as? UINavigationController {
                navigationController.isNavigationBarHidden = true
            }
        }

//        self.tabBarController?.tabBar.isHidden = true
    }
    func setDelegates() {
        self.leadsTable.delegate = self
        self.leadsTable.dataSource = self
        self.searchView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.searchView.layer.borderWidth = 1

        self.searchTextField.delegate = self

    }
    func manageActionMethods() {
        self.backBtn.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
//            if let tabbar = self.parent?.parent as? TabBarController {
//                if let navigationController = tabbar.parent as? UINavigationController {
//                    tabbar.selectedIndex = 0
//                }
//            }
        }
    }
    func clearSearchText() {
        self.searchTextField.text = ""
        self.searchList = self.companyList
       // self.searchList = self.searchList.sorted(by: {$0.firstName < $1.firstName })
        self.leadsTable.reloadData()
    }
    func fetchCompanyListDetails() {
        var page = self.currentTripPageIndex+1
              guard  self.HittedTripPageIndex != self.currentTripPageIndex + 1 else {
                  return
              }
        
        var urlStr = APIEnums.retrieveCompanies.rawValue
        if page != 1 {
            urlStr = urlStr + "?page=\(page)"
        }
        APIService.shared.retrieveCompanyListDetails(url: urlStr) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.companyObject = data
                        self.companyList.append(contentsOf: responseData)
                        self.searchList.append(contentsOf: responseData)
                        let next = self.getQueryItems(data.next)
                        let last = self.getQueryItems(data.last)
                        let Lastitem = last.filter({$0.key == "page"}).first?.value
                        let currentItem = next.filter({$0.key == "page"}).first?.value

                        self.totalTripPages = (Lastitem?.toInt() ?? 0)
                        self.currentTripPageIndex = (currentItem?.toInt() ?? 0) - 1
                        self.HittedTripPageIndex = (currentItem?.toInt() ?? 0) - 1
                        self.leadsTable.reloadData()                    }
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

    class func initWithStory() -> UnitsVC {
        let vc : UnitsVC = UIStoryboard.Login.instantiateViewController()
        return vc
    }
}
extension UnitsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leadsTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "leadsCell", for: indexPath) as? LeadsCell else {
                return UITableViewCell()
            }

            var model = self.searchList.value(atSafe: indexPath.row)
            cell.leadsName.text = (self.searchList.value(atSafe: indexPath.row)?.companyName ?? "")
            cell.loanStatusButton.setTitle(model?.companyStatus ?? "", for: .normal)
            if model?.companyStatus != "" {
                let attributedTitle = NSMutableAttributedString(string: model?.companyStatus ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: "yellow")])

                cell.loanStatusButton.setAttributedTitle(attributedTitle, for: .normal)
            }
            
            cell.leadsName.accessibilityHint = model?.id ?? ""

            return cell
        }

        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = self.searchList.value(atSafe: indexPath.row) else{
            return
        }
        let vc = UnitDetailsVC.initWithStory(companyDetails: model)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
extension UnitsVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let range = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: range, with: string)
        
        switch textField {
        case self.searchTextField:
            
//            DispatchQueue.main.async {
                if newText.trim() != "" {
                    self.searchList = self.companyList.filter { $0.companyName.lowercased().contains(newText.lowercased()) }
                   // self.searchList = self.searchList.sorted(by: {$0.firstName < $1.firstName })

                    if self.searchList.count == 0 {
                        self.view.endEditing(true)
                        self.showAlert(title: "", message: "Record Not Found", options: "Okay") { option in
                            self.clearSearchText()
                        }
                    }
                }
                else {
                    self.searchList = self.companyList
                }
                self.leadsTable.reloadData()
//            }
            break
            
        default: break
        }
        
        return true
    }
}
extension UnitsVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cell = leadsTable.visibleCells.last as? LeadsCell
        guard ((cell?.leadsName.text) != nil),
              (self.searchList.last != nil) else {return}
        if cell?.leadsName.accessibilityHint == (self.searchList.last?.id) &&
            self.companyObject?.next != "" && self.currentTripPageIndex != self.totalTripPages && oneTimeForHistory {
            self.fetchCompanyListDetails()
            self.oneTimeForHistory = !self.oneTimeForHistory
        }
    }
}
