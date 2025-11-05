//
//  GojekHomeViewController.swift
//  GoferHandy
//
//  Created by Trioangle on 28/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var rightArrowImage: UIImageView!
    @IBOutlet weak var leftArrowImage: UIImageView!
    @IBOutlet weak var statusCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var statusCollectionView: UICollectionView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var servicesCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    @IBOutlet weak var serviceTilePageControl: CustomPageControl!
    @IBOutlet weak var ourServiceTitleLbl: UILabel!
    
    @IBOutlet weak var statusViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusTable: UITableView!
    @IBOutlet weak var applyNowButton: UIButton!
    @IBOutlet weak var servicesView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    //---------------------------------------
    // MARK: - Local Variables
    //---------------------------------------
    
    var homeVM : HomeVM!
    var loanModel : LoanModel?

    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initalisations
        if UserDefaults.standard.value(forKey: "role") as? String != "" && UserDefaults.standard.value(forKey: "access") as? String != "" && UserDefaults.standard.value(forKey: "access") as? String != nil{
            self.statusView.isHidden = false
            self.statusViewHeightConstraint.constant = 70
            self.applyNowButton.isHidden = false
        }else{
            self.statusView.isHidden = true
            self.statusViewHeightConstraint.constant = 00
            self.applyNowButton.isHidden = false
        }
        self.initView()
        if let layout = self.servicesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        if let layout = self.itemCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        if let layout = self.statusCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        //        profileImageView.layer.cornerRadius = profileImageView.bounds.size.height / 2
        //        profileImageView.clipsToBounds = true
        self.setPagNumber(currentPage: 0)
        self.serviceTilePageControl.numberOfPages = 2
        self.statusView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.statusView.layer.borderWidth = 1
        self.servicesView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.servicesView.layer.borderWidth = 1
        self.addObserverOnHeightTbl()
        if UserDefaults.standard.value(forKey: "access") as? String != "" && UserDefaults.standard.value(forKey: "access") as? String != nil{
            self.profileImageView.layer.cornerRadius = 0
            self.profileImageView.image = UIImage(named: "logout")
            
//            if UserDefaults().profileImage != "" {
//                self.profileImageView.layer.cornerRadius = 12
//                self.profileImageView.sd_setImage(with: URL(string: UserDefaults().profileImage))
//                self.userNameLabel.isHidden = true
//            }else{
//                self.profileImageView.layer.cornerRadius = 12
//                self.profileImageView.backgroundColor = UIColor(named: "blue")
//                self.userNameLabel.isHidden = false
//                self.userNameLabel.text = UserDefaults().profileName.first?.description
//            }
        }else{
            self.profileImageView.layer.cornerRadius = 10
            self.profileImageView.backgroundColor = UIColor(named: "blue")
            self.userNameLabel.isHidden = false
            self.userNameLabel.text = "S"
        }
        
        self.profileImageView.addTapGestureRecognizer {
//            let vc = TabBarController()
//            self.navigationController?.pushViewController(vc, animated: true)
//            let vc = LoginVC.initWithStory()
//            self.navigationController?.pushViewController(vc, animated: true)
            if UserDefaults.standard.value(forKey: "access") as? String != "" && UserDefaults.standard.value(forKey: "access") as? String != nil {
                self.logoutAPIDetails()
            }else{
                let vc = LoginVC.initWithStory()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
//        self.statusView.addTapGestureRecognizer {
//            let vc = PersonalViewController.initWithStory(loanId: self.loanModel?.data.first?.id ?? "")
//            vc.hidesBottomBarWhenPushed = true
//            isFromIncomplete = true
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
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
                            if self.loanModel?.data.count ?? 0 > 1 {
                                self.leftArrowImage.isHidden = false
                                self.rightArrowImage.isHidden = false

                            }else{
                                self.leftArrowImage.isHidden = true
                                self.rightArrowImage.isHidden = true

                            }
                            self.applyNowButton.setTitle(text, for: .normal)
                            if text == "Apply Now" {
                                self.applyNowButton.isHidden = true
                            }
                        }else{
                            self.applyNowButton.isHidden = false

                        }
                        self.statusCollectionView.reloadData()
                    }
                    catch {
                        
                    }
                }
                else {
                    self.leftArrowImage.isHidden = true
                    self.rightArrowImage.isHidden = true

                   // self.showAlert(title: "Info", message: data.statusMessage)
                }
            case .failure(let error):
               // self.showAlert(title: "Info", message: error.localizedDescription)
                print(error)
                self.leftArrowImage.isHidden = true
                self.rightArrowImage.isHidden = true

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
        if UserDefaults.standard.value(forKey: "role") as? String != "" && UserDefaults.standard.value(forKey: "access") as? String != "" && UserDefaults.standard.value(forKey: "access") as? String != nil{
            self.statusView.isHidden = false
            self.statusViewHeightConstraint.constant = 70
            self.applyNowButton.isHidden = false
        }else{
            self.statusView.isHidden = true
            self.statusViewHeightConstraint.constant = 00
            self.applyNowButton.isHidden = false
        }
        if UserDefaults.standard.value(forKey: "access") as? String != "" && UserDefaults.standard.value(forKey: "access") as? String != nil{
            self.profileImageView.layer.cornerRadius = 0
            self.profileImageView.image = UIImage(named: "logout")
            self.profileImageView.backgroundColor = .clear
            self.userNameLabel.isHidden = true

//            if UserDefaults().profileImage != "" {
//                self.profileImageView.layer.cornerRadius = 12
//                self.profileImageView.sd_setImage(with: URL(string: UserDefaults().profileImage))
//                self.userNameLabel.isHidden = true
//            }else{
//                self.profileImageView.layer.cornerRadius = 12
//                self.profileImageView.backgroundColor = UIColor(named: "blue")
//                self.userNameLabel.isHidden = false
//                self.userNameLabel.text = UserDefaults().profileName.first?.description
//            }
        }else{
            self.profileImageView.layer.cornerRadius = 10
            self.profileImageView.backgroundColor = UIColor(named: "blue")
            self.userNameLabel.isHidden = false
            self.userNameLabel.text = "S"
        }
    }
    func initView() {
        self.servicesCollectionView.delegate = self
        self.servicesCollectionView.dataSource = self
        self.statusCollectionView.delegate = self
        self.statusCollectionView.dataSource = self
        self.itemCollectionView.delegate = self
        self.itemCollectionView.dataSource = self
        self.itemCollectionView.registerNib(forCell: ServicesCollectionViewCell.self)
        self.applyNowButton.layer.cornerRadius = self.applyNowButton.frame.height / 2
        self.leftArrowImage.isHidden = true
        self.rightArrowImage.isHidden = true

        self.leftArrowImage.addTapGestureRecognizer {
            let visibleItems: NSArray = self.statusCollectionView.indexPathsForVisibleItems as NSArray
                let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
                let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
            if nextItem.row < self.loanModel?.data.count ?? 0 && nextItem.row >= 0{
                    self.statusCollectionView.scrollToItem(at: nextItem, at: .right, animated: true)

                }
        }
        self.rightArrowImage.addTapGestureRecognizer {
            let visibleItems: NSArray = self.statusCollectionView.indexPathsForVisibleItems as NSArray
               let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
               let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
            if nextItem.row < self.loanModel?.data.count ?? 0 {
                   self.statusCollectionView.scrollToItem(at: nextItem, at: .left, animated: true)

               }
        }
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
    
    class func initWithStory() -> HomeViewController {
        let vc : HomeViewController = UIStoryboard.Main.instantiateViewController()
        vc.homeVM = HomeVM()
        return vc
    }
    // Button Action
    
    @IBAction func applyNowAction(_ sender: Any) {
        if applyNowButton.titleLabel?.text?.lowercased() == "apply now" {
            if self.loanModel?.data.count == 0 {
                let vc = PersonalViewController.initWithStory(loanId: "")
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = PersonalViewController.initWithStory(loanId: self.loanModel?.data.first?.id ?? "")
                vc.hidesBottomBarWhenPushed = true
                isFromIncomplete = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else{
            self.showAlertWithAction(title: "Confirm New Funding Application", message: "Are you sure you want to proceed with applying for new funding?")

        }
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
}
    //---------------------------------------
// MARK: - Services Banner Datasource
//---------------------------------------

extension HomeViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
           UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
           cell.transform = .identity
          }, completion: nil)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.itemCollectionView:
            return 9
        case self.servicesCollectionView:
            return 2
        case self.statusCollectionView:
            return self.loanModel?.data.count ?? 0
        default:
            return 0
        }
//        return collectionView == self.itemCollectionView ? 9 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == servicesCollectionView {
            let cell : ServiceTileCVC = collectionView.dequeueReusableCell(for: indexPath)
            cell.serviceIV.image = indexPath.row == 0 ? UIImage.init(named: "banner1") : UIImage.init(named: "banner2")
            return cell
        }
        else if collectionView == statusCollectionView {
            let cell : StatusCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            var model = self.loanModel?.data.value(atSafe: indexPath.row)
            var color = "yellow"
            if model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.currentStatus == "Admin_Cash_Disbursed" {
                color = "green"
            }else if model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.currentStatus.lowercased().contains("rejected") ?? false || model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.currentStatus.lowercased().contains("returned") ?? false {
                color = "red"
            }
            cell.loanStatusButton.backgroundColor = UIColor(named: color)?.withAlphaComponent(0.4)
            if model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.currentStatus != "" {
                let attributedTitle = NSMutableAttributedString(string: model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.currentStatus ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 9.0), NSAttributedString.Key.foregroundColor: UIColor(named: color)])

                cell.loanStatusButton.setAttributedTitle(attributedTitle, for: .normal)
                cell.expectedCompletionDate.text = model?.expectedCompletionDate
                cell.companyNameLabel.text = model?.customer.companyName
            }
            
            return cell
        }
        else{
            let cell : ServicesCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            switch indexPath.row {
            case 0:
                cell.nameLabel.text = "Working Capital"
            case 1:
                cell.nameLabel.text = "HMRC Payments"
            case 2:
                cell.nameLabel.text = "Unexpected Bills"
            case 3:
                cell.nameLabel.text = "Rent/Rates"
            case 4:
                cell.nameLabel.text = "Wages/Salaries"
            case 5:
                cell.nameLabel.text = "Stock"
            case 6:
                cell.nameLabel.text = "Expansion"
            case 7:
                cell.nameLabel.text = "Cashflow Buffer"
            case 8:
                cell.nameLabel.text = "Refurbishment"
            default:
                break
            }
//            switch indexPath.row {
//            case 0,1,2,3,4,5:
//                cell.iconImageView.image = UIImage.init(named: "item\(indexPath.row + 1)")
//            case 6,7,8:
//                cell.iconImageView.image = UIImage.init(named: "item\(indexPath.row - 2)")
//            default:
//                break
//            }
            cell.iconImageView.image = UIImage.init(named: "item\(indexPath.row + 1)")

            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.statusCollectionView {
            var model = self.loanModel?.data.value(atSafe: indexPath.row)
            if model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.currentStatus != "" {
                let vc = PersonalViewController.initWithStory(loanId: model?.customer.loanDetails.filter({$0.loanID == model?.id}).first?.loanID ?? "")
                vc.hidesBottomBarWhenPushed = true
                isFromIncomplete = true
                self.navigationController?.pushViewController(vc, animated: true)

            }


        }
        
    }
}


//---------------------------------------
// MARK: - Banner Scroll Delegate
//---------------------------------------

extension HomeViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.x / view.frame.width
        self.setPagNumber(currentPage: Int(scrollPos) )
    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView == self.itemCollectionView ? CGSize(width: self.view.frame.width / 3 - 45, height: 100) : (collectionView == self.statusCollectionView ? CGSize(width: collectionView.frame.width, height: collectionView.frame.height) : CGSize(width: self.view.frame.width, height: 200))
    }
}


//MARK: -------------------------- Observers Methods --------------------------
extension HomeViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if let obj = object as? UICollectionView, obj == self.itemCollectionView, (keyPath == "contentSize"), let newvalue = change?[.newKey] as? CGSize {
            self.servicesCollectionViewHeight.constant = newvalue.height
//            self.ServiceOuterViewHeight.constant = newvalue.height + 50
        }
    }
    
    func addObserverOnHeightTbl() {
        self.itemCollectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.statusCollectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

    }
    
    func removeObserverOnHeightTbl() {
       
        guard let tblView = self.itemCollectionView else {return}
        if let _ = tblView.observationInfo {
            tblView.removeObserver(self, forKeyPath: "contentSize")
        }
        guard let tblView2 = self.statusCollectionView else {return}
        if let _ = tblView2.observationInfo {
            tblView2.removeObserver(self, forKeyPath: "contentSize")
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
                else if data.statusCode == 401 {
                    self.tokenRefreshApi(paramDict: JSON(), dataArray: [String : Any](),isLogout: true)
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
    func tokenRefreshApi(paramDict: JSON,dataArray: [String: Any],isLogout : Bool) {
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

                    if isLogout {
                        self.logoutAPIDetails()
                    }else{
                       
                    }
                }
                else if data.statusCode == 422 {
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
}

class CustomPageControl: UIPageControl {

    @IBInspectable var selectedImage: UIImage = UIImage.init(named: "pageControlSelected")!

    @IBInspectable var normalImage: UIImage  = UIImage.init(named: "pageControlNormal")!

    override var numberOfPages: Int {
        didSet {
            updateDots()
        }
    }

    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 14.0, *) {
            defaultConfigurationForiOS14AndAbove()
        } else {
            pageIndicatorTintColor = .clear
            currentPageIndicatorTintColor = .clear
            clipsToBounds = false
        }
    }

    private func defaultConfigurationForiOS14AndAbove() {
        if #available(iOS 14.0, *) {
            for index in 0..<numberOfPages {
                let image = index == currentPage ? selectedImage : normalImage
                setIndicatorImage(image, forPage: index)
            }

            // give the same color as "otherPagesImage" color.
//            pageIndicatorTintColor = .gray
            
            // give the same color as "currentPageImage" color.
//            currentPageIndicatorTintColor = .red
            /*
             Note: If Tint color set to default, Indicator image is not showing. So, give the same tint color based on your Custome Image.
            */
        }
    }

    private func updateDots() {
        if #available(iOS 14.0, *) {
            defaultConfigurationForiOS14AndAbove()
        } else {
            for (index, subview) in subviews.enumerated() {
                let imageView: UIImageView
                if let existingImageview = getImageView(forSubview: subview) {
                    imageView = existingImageview
                } else {
                    imageView = UIImageView(image: normalImage)
                    
                    imageView.center = subview.center
                    subview.addSubview(imageView)
                    subview.clipsToBounds = false
                }
                imageView.image = currentPage == index ? selectedImage : normalImage
            }
        }
    }

    private func getImageView(forSubview view: UIView) -> UIImageView? {
        if let imageView = view as? UIImageView {
            return imageView
        } else {
            let view = view.subviews.first { (view) -> Bool in
                return view is UIImageView
            } as? UIImageView

            return view
        }
    }
}
