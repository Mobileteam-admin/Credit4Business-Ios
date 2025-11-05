//
//  ProfileViewController.swift
//  Credit4Business
//
//  Created by MacMini on 19/03/24.
//

import UIKit

class ProfileViewController: UIViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var menuTable: UITableView!
    
    //MARK: -------------------- Class Variable --------------------
    var viewModel = HomeVM()
    var menuItems = [MenuItemModel]()

    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.addMenuItems()
    }
   //---------------------------------------
   // MARK: - Init With Story
   //---------------------------------------

   class func initWithStory() -> ProfileViewController {
       let vc : ProfileViewController = UIStoryboard.Main.instantiateViewController()
       return vc
   }
    func setDelegates() {
        self.menuTable.dataSource = self
        self.menuTable.delegate = self
    }
    func addMenuItems() {

        let tripView = WebViewController.initWithStory()
        tripView.strPageTitle = "Document"
        let item1 = MenuItemModel(withTitle: "Referral", image: "https://credit4-b.demoserver.work/contact-us#", VC: tripView)
        let item2 = MenuItemModel(withTitle: "Apply for Renewal", image: "https://credit4-b.demoserver.work/contact-us#", VC: tripView)
        let item3 = MenuItemModel(withTitle: "Blog", image: "https://credit4-b.demoserver.work/contact-us#", VC: tripView)
        let item4 = MenuItemModel(withTitle: "Newsletter", image: "https://credit4-b.demoserver.work/contact-us#", VC: tripView)
        let item5 = MenuItemModel(withTitle: "Terms and Conditions", image: "https://credit4-b.demoserver.work/contact-us#", VC: tripView)
        let item6 = MenuItemModel(withTitle: "Privacy Policy", image: "https://credit4-b.demoserver.work/contact-us#", VC: tripView)
        let item7 = MenuItemModel(withTitle: "About Us", image: "https://credit4-b.demoserver.work/contact-us#", VC: tripView)
        let item8 = MenuItemModel(withTitle: "Contact Us", image: "https://credit4-b.demoserver.work/contact-us#", VC: tripView)
        let item9 = MenuItemModel(withTitle: "FAQ", image: "https://credit4-b.demoserver.work/contact-us#", VC: tripView)
        let item10 = MenuItemModel(withTitle: "Responsible Lending", image: "https://credit4-b.demoserver.work/contact-us#", VC: tripView)
        let item11 = MenuItemModel(withTitle: "History", image: "https://credit4-b.demoserver.work/contact-us#", VC: tripView)
        menuItems.append(item1)
        menuItems.append(item2)
        menuItems.append(item3)
        menuItems.append(item4)
        menuItems.append(item5)
        menuItems.append(item6)
        menuItems.append(item7)
        menuItems.append(item8)
        menuItems.append(item9)
        menuItems.append(item10)
        menuItems.append(item11)
    }
}
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as? MenuClass else {
                return UITableViewCell()
            }
        guard let item = self.menuItems.value(atSafe: indexPath.row) else{return cell}

        cell.menuLabel.text = item.title
        cell.separatorLabel.isHidden = indexPath.row == self.menuItems.count - 1
            return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _selectedItem = self.menuItems[indexPath.row]
//        if let vc = _selectedItem.viewController{
//            self.navigationController?.pushViewController(vc, animated: true)
//        }\
        var vc = WebViewController.initWithStory()
        vc.strPageTitle = "Document"
        vc.strWebUrl = _selectedItem.imgName ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
