//
//  DashboardVC.swift
//  Credit4Business
//
//  Created by MacMini on 06/05/24.
//

import UIKit

class DashboardVC: UIViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var gridCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var dashboardTable: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var gridCollection: UICollectionView!
    @IBOutlet weak var newItemsCollection: UICollectionView!
    //MARK: -------------------- Class Variable --------------------
    var viewModel = HomeVM()
    var leadsModel = [LeadsData]()
    var searchList = [LeadsData]()
    var leadsObject : LeadsModel?
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
    var agentNotificationData = [AgentNotificationData]()
    var kpiData = [KPIData]()

    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.manageActionMethods()
        // Do any additional setup after loading the view.
        self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        self.segmentedControl.setStyle(selectedColor: UIColor.init(named: "blue") ?? .blue, unselectedColor: UIColor.white)
        self.segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//            layout.sectionInset = UIEdgeInsets(top:0,left:0,bottom:0,right:0)
//            layout.itemSize = CGSize(width: 160, height: 70)
//            layout.minimumInteritemSpacing = 1
//            layout.minimumLineSpacing = 1
//        gridCollection.collectionViewLayout = layout
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currentTripPageIndex = 0
        self.HittedTripPageIndex = 0
        self.fetchLeadsDetails()
        self.fetchAgentNotificationsDetails()
        self.fetchKPIDetails()
    }
    func fetchAgentNotificationsDetails() {
        APIService.shared.retrieveAgentNotificationDetails() { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.agentNotificationData = responseData
                        self.agentNotificationData = self.agentNotificationData.filter({$0.isNotified == false})
                        self.dashboardTable.reloadData()
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
    func fetchKPIDetails() {
        APIService.shared.retrieveKPIDetails() { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.kpiData = responseData
                        self.gridCollectionHeight.constant = 100

                        self.gridCollection.reloadData()
                    }
                    catch {
                        
                    }
                }
                else {
                }
            case .failure(let error):
                print(error)
                self.gridCollectionHeight.constant = 0
            }
        }
    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.fetchLeadsDetails()
        }else{
            self.fetchAgentNotificationsDetails()
        }
        self.dashboardTable.reloadData()
    }
    func setDelegates() {
        self.dashboardTable.delegate = self
        self.dashboardTable.dataSource = self
        self.backBtn.isHidden = true
        self.gridCollection.delegate = self
        self.gridCollection.dataSource = self
        self.newItemsCollection.delegate = self
        self.newItemsCollection.dataSource = self
    }
    func manageActionMethods() {
        self.backBtn.addTapGestureRecognizer {
        
        }
    }
    func fetchLeadsDetails() {
        var page = self.currentTripPageIndex+1
              guard  self.HittedTripPageIndex != self.currentTripPageIndex + 1 else {
                  return
              }
              var urlStr = APIEnums.leadsList.rawValue
              if page != 1 {
                  urlStr = urlStr + "?page=\(page)"
              }
        APIService.shared.retrieveLeadsDetails(url: urlStr) { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        //self.leadsModel = responseData
                       // self.searchList = responseData
                      //  self.searchList = self.searchList.sorted(by: {$0.firstName < $1.firstName })
                        self.leadsObject = data
                        self.leadsModel.append(contentsOf: responseData)
                        self.searchList.append(contentsOf: responseData)
                        let next = self.getQueryItems(data.next)
                        let last = self.getQueryItems(data.last)
                        let Lastitem = last.filter({$0.key == "page"}).first?.value
                        let currentItem = next.filter({$0.key == "page"}).first?.value

                        self.totalTripPages = (Lastitem?.toInt() ?? 0)
                        self.currentTripPageIndex = (currentItem?.toInt() ?? 0) - 1
                        self.HittedTripPageIndex = (currentItem?.toInt() ?? 0) - 1
                        self.dashboardTable.reloadData()
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

    class func initWithStory() -> DashboardVC {
        let vc : DashboardVC = UIStoryboard.Login.instantiateViewController()
        return vc
    }
}
extension DashboardVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return self.searchList.count
        }else {
            return self.agentNotificationData.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == dashboardTable {
            if self.segmentedControl.selectedSegmentIndex == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "leadsCell2", for: indexPath) as? LeadsCell else {
                    return UITableViewCell()
                }
                var model = self.searchList.value(atSafe: indexPath.row)
                cell.leadsName.text = (self.searchList.value(atSafe: indexPath.row)?.firstName ?? "") + " " + (self.searchList.value(atSafe: indexPath.row)?.lastName ?? "")
                cell.leadsPhone.text = self.searchList.value(atSafe: indexPath.row)?.phoneNumber
                cell.leadsImage.sd_setImage(with: URL(string: model?.image ?? ""))
//                cell.loanStatusButton.setTitle(model?.loanStatus.currentStatus ?? "", for: .normal)
//                if model?.loanStatus.currentStatus != "" {
//                   // cell.loanStatusButton.isHidden = false
//                    let attributedTitle = NSMutableAttributedString(string: model?.loanStatus.currentStatus ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: "yellow")])
//
//                    cell.loanStatusButton.setAttributedTitle(attributedTitle, for: .normal)
//                }else{
//                    //cell.loanStatusButton.isHidden = true
//                }
//                
//                cell.requestedDateLabel.text = model?.loanStatus.appliedDate
                cell.leadsName.accessibilityHint = model?.id ?? ""
                return cell
            }else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as? NotificationCell else {
                    return UITableViewCell()
                }
                   var model2 = self.agentNotificationData.value(atSafe: indexPath.row)
                    cell.titleLabel.text = model2?.notificationType
                    cell.subTitleLabel.text = model2?.message
                    cell.dateLabel.text = self.convertDateFormater(date: model2?.createdOn ?? "")
               
                return cell

            }
            
        }

        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            
            guard let model = self.searchList.value(atSafe: indexPath.row) else{
                return
            }
            let vc = LoansVC.initWithStory(leadsData: model)
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            guard let model = self.agentNotificationData.value(atSafe: indexPath.row) else {
                return
            }
            var dict2 = JSON()

            dict2["id"] = model.id ?? 0
            dict2["is_notified"] = true
            self.updateAgentNotification(params: dict2)
        }
    }
    func updateAgentNotification(params: JSON) {
        APIService.shared.makeRequest(endpoint: APIEnums.retrieveAgentNotificationDetails.rawValue,
                                      withLoader: true,
                                      method: .post,
                                      params: params) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    self.fetchAgentNotificationsDetails()
                }
                else if data.statusCode == 401 {
                    self.tokenRefreshApi(params: params)
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
    func tokenRefreshApi(params: JSON) {
        var dict = JSON()
        dict["refresh"] = UserDefaults.standard.value(forKey: "refresh") as? String
        APIService.shared.refreshTokenRequest(endpoint: APIEnums.refreshToken.rawValue,
                                      withLoader: true,
                                      method: .post,
                                      params: dict) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    UserDefaults.standard.set(data.access, forKey:"access")
                    UserDefaults.standard.set(data.refresh, forKey:"refresh")

                    self.updateAgentNotification(params: params)
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
}
public extension UISegmentedControl {
    func setStyle(selectedColor: UIColor, unselectedColor: UIColor){
        let unselectedBackgroundImage = UIImage(color: unselectedColor)
        let selectedBacgroundImage = UIImage(color:selectedColor)
        
        self.setBackgroundImage(unselectedBackgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(unselectedBackgroundImage, for: .highlighted, barMetrics: .default)
        self.setBackgroundImage(selectedBacgroundImage, for: .selected, barMetrics: .default)
        
//        self.setDividerImage(selectedBacgroundImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
//
//        self.layer.borderWidth = 1
//        self.layer.borderColor = selectedColor.cgColor
        
        let segmentedControlUnselectedText = [NSAttributedString.Key.foregroundColor: selectedColor]
        let segmentedControlSelectedText = [NSAttributedString.Key.foregroundColor: unselectedColor]
        
        self.setTitleTextAttributes(segmentedControlUnselectedText, for: .normal)
        self.setTitleTextAttributes(segmentedControlSelectedText, for: .selected)
        self.layer.borderColor = UIColor.clear.cgColor
    }
}
public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
      }
}
extension DashboardVC : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.gridCollection{
            return self.kpiData.count
        }else{
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.gridCollection{
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannnerCell", for: indexPath) as? BannnerCell else {
                return UICollectionViewCell()
            }
            var model = self.kpiData.value(atSafe: indexPath.row)
            cell.titleLabel.text = model?.title
            cell.subTitleLabel.text = model?.duration
            cell.targetPercentage.text = (model?.target.description ?? "") //+ " %"
            cell.targetPercentage.isHidden = !(model?.isTrendIncreasing ?? false)
            var text = ""
            if model?.title.contains("new clients") ?? false {
                text = model?.numberOfNewClients?.description ?? ""
            }else if model?.title.contains("old clients") ?? false {
                text = model?.numberOfOldClients?.description ?? ""
            }
            else if model?.title.contains("fund disbursed") ?? false {
                text = model?.fundDisbursed?.description ?? ""
            }
            
            
            cell.percentageLabel.text = text
            cell.arrowLabel.text = (model?.percentage.description ?? "") + " %"
            cell.arrowLabel.textColor = (model?.isTrendIncreasing ?? false) ? UIColor.init(named: "green") : UIColor.init(named: "red")
            cell.arrowImage.image = (model?.isTrendIncreasing ?? false) ? UIImage.init(named: "greenArrow") : UIImage.init(named: "redArrow")
            return cell
        }else{
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newBannnerCell", for: indexPath) as? NewBannnerCell else {
                return UICollectionViewCell()
            }
            if indexPath.row == 0 {
                cell.bannerImage.image = UIImage(named: "funding")
                cell.bannerTitle.text = "Funding"
            }
            else if indexPath.row == 1 {
                cell.bannerImage.image = UIImage(named: "unit")
                cell.bannerTitle.text = "Unit"
            }else{
                cell.bannerImage.image = UIImage(named: "credit_monitor")
                cell.bannerTitle.text = "Credit Monitoring"
            }
            cell.contentView.addTapGestureRecognizer {
                if indexPath.row == 0 {
                    let vc = LoansVC.initWithStory()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if indexPath.row == 1 {
                    let vc = UnitsVC.initWithStory()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    let vc = CreditMonitorVC.initWithStory()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            return cell
        }
    }
}
extension DashboardVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            
            let cell = dashboardTable.visibleCells.last as? LeadsCell
            guard ((cell?.leadsName.text) != nil),
                  (self.searchList.last != nil) else {return}
            if cell?.leadsName.accessibilityHint ?? "" == (self.searchList.last?.id) &&
                self.leadsObject?.next != "" && self.currentTripPageIndex != self.totalTripPages && oneTimeForHistory {
                self.fetchLeadsDetails()
                self.oneTimeForHistory = !self.oneTimeForHistory
            }
        }
    }
}
