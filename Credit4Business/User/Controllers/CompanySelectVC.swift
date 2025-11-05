//
//  CompanySelectVC.swift
//  Credit4Business
//
//  Created by MacMini on 28/08/24.
//

import UIKit
class CompanySelectVC: UIViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var remarksTable: UITableView!
    @IBOutlet weak var remarksTableHeight: NSLayoutConstraint!
    @IBOutlet weak var dismissImage: UIImageView!

    //MARK: -------------------- Class Variable --------------------
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
    var selectedCompanyId = ""
    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.manageActionMethods()
        self.addObserverOnHeightTbl()
        self.currentTripPageIndex = 0
        self.HittedTripPageIndex = 0
        self.fetchCompanyListDetails()

        // Do any additional setup after loading the view.
    }
    func setDelegates() {
        self.remarksTable.delegate = self
        self.remarksTable.dataSource = self
    }
    func manageActionMethods() {
        self.dismissImage.addTapGestureRecognizer {
            self.dismiss(animated: true)
        }
    }
    class func initWithStory() -> CompanySelectVC {
        let vc : CompanySelectVC = UIStoryboard.Login.instantiateViewController()
        return vc
    }
    func fetchCompanyListDetails() {
        let page = self.currentTripPageIndex+1
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
                        self.remarksTable.reloadData()                    }
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
}
extension CompanySelectVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == remarksTable {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "leadsCell2", for: indexPath) as? LeadsCell else {
                    return UITableViewCell()
                }
            guard let model = self.searchList.value(atSafe: indexPath.row) else {return UITableViewCell()}
            cell.leadsName.text = model.companyName
            cell.leadsName.accessibilityHint = model.id
            cell.contentView.addTapGestureRecognizer {
                self.selectedCompanyId = model.id
                self.remarksTable.reloadData()
            }
            cell.leadsImage.image = model.id == self.selectedCompanyId ? UIImage(named: "radioSelected") : UIImage(named: "radioUnselectedCompany")
            return cell
           
        }

        return UITableViewCell()
    }
}
//MARK: -------------------------- Observers Methods --------------------------
extension CompanySelectVC {
    
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
}
extension CompanySelectVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cell = remarksTable.visibleCells.last as? LeadsCell
        guard ((cell?.leadsName.text) != nil),
              (self.searchList.last != nil) else {return}
        if cell?.leadsName.accessibilityHint == (self.searchList.last?.id) &&
            self.companyObject?.next != "" && self.currentTripPageIndex != self.totalTripPages && oneTimeForHistory {
            self.fetchCompanyListDetails()
            self.oneTimeForHistory = !self.oneTimeForHistory
        }
    }
}
