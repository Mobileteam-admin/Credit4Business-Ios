//
//  UserDashboardVC.swift
//  Credit4Business
//
//  Created by MacMini on 14/05/24.
//

import UIKit

class UserDashboardVC: UIViewController {
    
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var paymentCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var paymentTableHeight: NSLayoutConstraint!
    @IBOutlet weak var servicesCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    @IBOutlet weak var serviceTilePageControl: CustomPageControl!
    @IBOutlet weak var ourServiceTitleLbl: UILabel!
    @IBOutlet weak var referralView: UIView!
    @IBOutlet weak var servicesView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusTable: UITableView!
    @IBOutlet weak var paymentsCollectionView: UICollectionView!
    @IBOutlet weak var paymentsTable: UITableView!
    @IBOutlet weak var applyNowButton: UIButton!
    //---------------------------------------
    // MARK: - Local Variables
    //---------------------------------------
    
    var homeVM : HomeVM!
    var loanModel : LoanModel?
    var paymentArray = [FundingPayment]()
    var allPaymentArray = [AllPaymentsData]()

    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initalisations
        self.initView()
        if let layout = self.servicesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        if let layout = self.paymentsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        //        profileImageView.layer.cornerRadius = profileImageView.bounds.size.height / 2
        //        profileImageView.clipsToBounds = true
        self.setPagNumber(currentPage: 0)
        self.serviceTilePageControl.numberOfPages = 2
        self.servicesView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.servicesView.layer.borderWidth = 1
        self.referralView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.referralView.layer.borderWidth = 1
        self.statusView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.statusView.layer.borderWidth = 1

        self.referralView.addTapGestureRecognizer {
            let vc = ReferralVC.initWithStory()
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        self.profileImageView.addTapGestureRecognizer {
//            let vc = TabBarController()
//            self.navigationController?.pushViewController(vc, animated: true)
//            let vc = LoginVC.initWithStory()
//            self.navigationController?.pushViewController(vc, animated: true)
            
//            self.tabBarController?.selectedIndex = 2
            self.logoutAPIDetails()
//            let vc = PersonalViewController.initWithStory()
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.statusView.addTapGestureRecognizer {
            let vc = PersonalViewController.initWithStory(loanId: self.loanModel?.data.last?.id ?? "")
            vc.hidesBottomBarWhenPushed = true
            isFromIncomplete = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
//        self.companyView.addTapGestureRecognizer {
//            let vc = CompanySelectVC.initWithStory()
//            vc.modalPresentationStyle = .overFullScreen
//            self.present(vc, animated: true)
//        }
        self.leftArrow.addTapGestureRecognizer {
            let visibleItems: NSArray = self.paymentsCollectionView.indexPathsForVisibleItems as NSArray
                let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
                let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
            if nextItem.row < self.allPaymentArray.count && nextItem.row >= 0{
                    self.paymentsCollectionView.scrollToItem(at: nextItem, at: .right, animated: true)

                }
        }
        self.rightArrow.addTapGestureRecognizer {
            let visibleItems: NSArray = self.paymentsCollectionView.indexPathsForVisibleItems as NSArray
               let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
               let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
            if nextItem.row < self.allPaymentArray.count {
                   self.paymentsCollectionView.scrollToItem(at: nextItem, at: .left, animated: true)

               }
        }
        self.applyNowButton.addTapGestureRecognizer {
            if self.applyNowButton.titleLabel?.text?.lowercased() == "apply now" {
                
                if self.loanModel?.data.count == 0 {
                    let vc = PersonalViewController.initWithStory(loanId: "")
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = PersonalViewController.initWithStory(loanId: self.loanModel?.data.last?.id ?? "")
                    vc.hidesBottomBarWhenPushed = true
                    isFromIncomplete = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else{
                self.showAlertWithAction(title: "Confirm New Funding Application", message: "Are you sure you want to proceed with applying for new funding?")

            }
        }
        self.addObserverOnHeightTbl()

    }
    func showAlertWithAction(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default,handler: { okay in
            self.applyNewLoan()
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .default,handler: { okay in
            self.dismiss(animated: true)
        }))
        self.present(alertController, animated: true)
    }
    func applyNewLoan() {
        APIService.shared.applyNewLoan() { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        var loanId = responseData.id
                        let vc = PersonalViewController.initWithStory(loanId: loanId ?? "")
                        vc.hidesBottomBarWhenPushed = true
                        isFromIncomplete = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    catch {
                        
                    }
                }
                else {
                    self.showAlert(title: "Info", message: data.statusMessage)
                }
            case .failure(let error):
                print(error)
                self.showAlert(title: "Info", message: "Failed to apply new loan")
            }
        }
    }
    func fetchPaymentDetails() {
        APIService.shared.retrieveAllPaymentDetails() { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
//                        for i in 0...9 {
//                            self.allPaymentArray.append(contentsOf: data.data)
//                        }
                        self.allPaymentArray = data.data.filter({$0.loan.loanStatus.currentStatus == "Admin_Cash_Disbursed"})
//                        if responseData.count != 0 {
//                            self.paymentArray.append(responseData.first!.fundingPayments)
//                        }
                        if self.allPaymentArray.count > 1 {
                          //  self.paymentCollectionViewHeight.constant = 390.0
                            self.leftArrow.isHidden = false
                            self.rightArrow.isHidden = false

                        }else{
                            self.paymentCollectionViewHeight.constant = 0.0
                            self.leftArrow.isHidden = true
                            self.rightArrow.isHidden = true

                        }
                        self.paymentsCollectionView.reloadData()
                    }
                    catch {
                        
                    }
                }
                else {
                    //self.showAlert(title: "Info", message: data.statusMessage)
                }
            case .failure(let error):
               // self.showAlert(title: "Info", message: error.localizedDescription)
                print(error)
                self.paymentCollectionViewHeight.constant = 0.0
                self.leftArrow.isHidden = true
                self.rightArrow.isHidden = true
            }
        }
    }
    func logoutAPIDetails() {
        APIService.shared.makeRequest(endpoint: APIEnums.logout.rawValue,
                                      withLoader: true,
                                      method: .post,
                                      params: JSON()) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    UserDefaults.standard.set("", forKey:"access")
                    UserDefaults.standard.set("", forKey:"refresh")
                    UserDefaults.standard.set("", forKey:"role")
                    UserDefaults.standard.set(0, forKey:"isLogin")
                    UserDefaults.standard.set("", forKey:"email")
                    UserDefaults.standard.set("", forKey:"name")
                    UserDefaults.standard.set("", forKey:"image")
                    UserDefaults.standard.set("", forKey:"address")

                    var navigationController = UINavigationController()
                    navigationController = UINavigationController(rootViewController: HomeViewController.initWithStory())
                    sceneDelegate.window?.rootViewController = navigationController
                    sceneDelegate.window?.makeKeyAndVisible()
                    navigationController.isNavigationBarHidden = true
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
    func instantPay(loanId: String,Dict: JSON){
        var url = APIEnums.createInstantPay.rawValue
        if loanId != "" {
            url = url + "\(loanId)/" + "?request_from=web"
        }
        APIService.shared.InstantPayRequest(endpoint: url,
                                      withLoader: true,
                                      method: .post,
                                      params: Dict) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    print(data)
                    var vc = WebViewController.initWithStory()
                    vc.strPageTitle = ""
                    vc.isToRedirect = true
                    vc.strWebUrl = data.data.authorisationURL
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if data.statusCode == 401 {
                    //self.tokenRefreshApi(params: Dict)
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
    func fetchLoanDetails() {
        APIService.shared.retrieveLoanDetails() { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data
                        self.loanModel = responseData
                        globalLoanModel = self.loanModel
                        if self.loanModel?.data.count != 0 {
                            var text = "Apply New Funding"
                            for element in self.loanModel!.data {
                                for loan in element.customer.loanDetails {
                                    if loan.currentStatus.lowercased() != "submitted"{
                                        text = "Apply Now"
                                    }
                                }
                            }
                            self.applyNowButton.setTitle(text, for: .normal)
                        }
                        self.statusTable.reloadData()
                    }
                    catch {
                        
                    }
                }
                else {
                   // self.showAlert(title: "Info", message: data.statusMessage)
                }
            case .failure(let error):
               // self.showAlert(title: "Info", message: error.localizedDescription)
                print(error)
            }
        }
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
        self.fetchLoanDetails()
        self.fetchPaymentDetails()
    }
    func initView() {
        self.servicesCollectionView.delegate = self
        self.servicesCollectionView.dataSource = self
        self.paymentsCollectionView.delegate = self
        self.paymentsCollectionView.dataSource = self
        self.statusTable.delegate = self
        self.statusTable.dataSource = self
//        self.paymentsTable.delegate = self
//        self.paymentsTable.dataSource = self
        self.applyNowButton.layer.cornerRadius = self.applyNowButton.frame.height / 2

    }
    //---------------------------------------
    // MARK: - Local Functions
    //---------------------------------------
    
    func setPagNumber(currentPage : Int) {
        self.serviceTilePageControl.currentPage = currentPage
    }
    //---------------------------------------
    // MARK: - Init With Story
    //---------------------------------------
    
    class func initWithStory() -> UserDashboardVC {
        let vc : UserDashboardVC = UIStoryboard.Login.instantiateViewController()
        vc.homeVM = HomeVM()
        return vc
    }
}
//---------------------------------------
// MARK: - Services Banner Datasource
//---------------------------------------

extension UserDashboardVC : UICollectionViewDataSource {

func collectionView(_ collectionView: UICollectionView,
                    willDisplay cell: UICollectionViewCell,
                    forItemAt indexPath: IndexPath) {
    cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
       UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
       cell.transform = .identity
      }, completion: nil)

}

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == self.servicesCollectionView {
        return 2
    }else{
        return self.allPaymentArray.count
    }
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == servicesCollectionView {
        let cell : ServiceTileCVC = collectionView.dequeueReusableCell(for: indexPath)
        cell.serviceIV.image = indexPath.row == 0 ? UIImage.init(named: "banner1") : UIImage.init(named: "banner2")
        return cell
    }
    else {
        let cell : DashboardCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let model = self.allPaymentArray.value(atSafe: indexPath.row)
               let fundingModel = model?.fundingPayments
               cell.paymentTitleLabel.text = fundingModel?.title
               cell.dueDateLabel.text = fundingModel?.dueDate
               cell.paymentAmountLabel.text = fundingModel?.nextDue
               cell.fundingAmountLabel.text = fundingModel?.fundingAmount
               cell.installmentPaidLabel.text = fundingModel?.instalmentPaid.description
               cell.remainingInstallmentLabel.text = fundingModel?.remainingInstalment.description
        cell.totalInstallmentValueLabel.text = fundingModel?.totalInstalment.description
                if fundingModel?.status == "Due" {
                    cell.makePaymentView.isHidden = false
                    cell.dueView.isHidden = false
                   // collectionView.reloadItems(at: [indexPath])

                    self.paymentCollectionViewHeight.constant = 400
                    cell.layoutIfNeeded()
//                    cell.setNeedsLayout()
//                    cell.layoutIfNeeded()
                   // cell.stackHeight.constant = 80
                   // cell.viewHeight.constant = 105
                }else{
                    cell.makePaymentView.isHidden = true
                    cell.dueView.isHidden = true
                  //  cell.stackHeight.constant = 120
                   // cell.viewHeight.constant = 140
                    self.paymentCollectionViewHeight.constant = 350

                   // collectionView.reloadItems(at: [indexPath])

                }
        cell.makePaymentBtn.addTapGestureRecognizer {
            var dict5 = JSON()
            let model = self.allPaymentArray.value(atSafe: indexPath.row)
            dict5["description"] = "instant pay i missed due"
            dict5["amount"] = model?.fundingPayments.nextDue.replacingOccurrences(of: "£", with: "").toInt() ?? ""
            dict5["currency"] = "GBP"
            self.instantPay(loanId: model?.loan.id ?? "",Dict: dict5)
        }
        var color = "yellow"
        if model?.loan.loanStatus.currentStatus == "Admin_Cash_Disbursed" {
            color = "green"
        }else if model?.loan.loanStatus.currentStatus.lowercased().contains("rejected") ?? false || model?.loan.loanStatus.currentStatus.lowercased().contains("returned") ?? false {
            color = "red"
        }
        cell.loanStatusButton.backgroundColor = UIColor(named: color)?.withAlphaComponent(0.4)
               if model?.loan.loanStatus.currentStatus != "" {
                  // cell.loanStatusButton.isHidden = false
                   let attributedTitle = NSMutableAttributedString(string: model?.loan.loanStatus.currentStatus ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: color)])
       
                   cell.loanStatusButton.setAttributedTitle(attributedTitle, for: .normal)
               }
               cell.companyNameLabel.text = model?.company.companyName
        cell.dateLabel.text = self.convertDateFormat(inputDate: model?.loan.createdOn ?? "",outputFormat: "yyyy-MM-dd")
        cell.expectedCompletionDate.text = model?.loan.expectedCompletionDate ?? ""
        return cell
    }
    return UICollectionViewCell()
}
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
}

}
//---------------------------------------
// MARK: - Banner Scroll Delegate
//---------------------------------------

extension UserDashboardVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.servicesCollectionView {
            let scrollPos = scrollView.contentOffset.x / view.frame.width
            self.setPagNumber(currentPage: Int(scrollPos) )
        }
        
    }
}

extension UserDashboardVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.servicesCollectionView {
            return CGSize(width: self.view.frame.width, height: 200)
        }else{
            return CGSize(width: self.view.frame.width - 50, height: collectionView.frame.height)
        }
    }
}
extension UserDashboardVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == statusTable {
            return 1
        }else {
            return self.paymentArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == statusTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "leadsCell", for: indexPath) as? LeadsCell else {
                return UITableViewCell()
            }
            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingPaymentsTableViewCell", for: indexPath) as? UpcomingPaymentsTableViewCell else {
                return UITableViewCell()
            }
            guard let model = self.paymentArray.value(atSafe: indexPath.row) else {return UITableViewCell()}
            
            cell.paymentTitleLabel.text = model.title
            cell.dueDateLabel.text = model.dueDate
            cell.paymentAmountLabel.text = model.nextDue
            cell.fundingAmountLabel.text = model.fundingAmount
            cell.installmentPaidLabel.text = model.instalmentPaid.description
            cell.remainingInstallmentLabel.text = model.remainingInstalment.description
            return cell
        }
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == statusTable {
            return 60
        }else {
            return UITableView.automaticDimension
        }
    }
}
//MARK: -------------------------- Observers Methods --------------------------
extension UserDashboardVC {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UITableView, obj == self.paymentsTable, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
         //   self.paymentTableHeight.constant = newvalue.height
        }
        if let obj = object as? UICollectionView, obj == self.paymentsCollectionView, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
          //  self.paymentCollectionViewHeight.constant = newvalue.height
        }
    }
    
    func addObserverOnHeightTbl() {
      //  self.paymentsTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.paymentsCollectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.paymentsTable else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        guard let colView = self.paymentsCollectionView else {return}
        if let _ = colView.observationInfo {
            colView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}
