//
//  TabBarController.swift
//  Credit4Business
//
//  Created by MacMini on 13/03/24.
//

import UIKit
import SDWebImage

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        var role = FIELDAGENT LEADS
        var role = UserDefaults.standard.value(forKey: "role") as? String
        if role == "FIELDAGENT" {
            self.setupTabs()
        }else{
            self.setupUserTabs()
        }
        self.tabBar.tintColor = UIColor(named: "blue")
        self.tabBar.unselectedItemTintColor = UIColor(named: "gray")
        self.tabBar.backgroundColor = .white
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setUserProfileImageOnTabbar()
    }
    
// MARK: - Tab Setup
    func setupUserTabs() {
        let home = self.createNav(title: "Dashboard", image: UIImage(named: "tab1")!, vc: UserDashboardVC.initWithStory())
        let second = self.createNav(title: "Notifications", image: UIImage(named: "tab3")!, vc: NotificationsVC.initWithStory())
        let fourth = self.createNav(title: "Profile", image: UIImage(named: "tab5")!, vc: ProfileVC.initWithStory())

        self.setViewControllers([home,second,fourth], animated: true)
    }
    func setupTabs() {
        let home = self.createNav(title: "Dashboard", image: UIImage(named: "tab1")!, vc: DashboardVC.initWithStory())
        let initial = self.createNav(title: "Leads", image: UIImage(named: "tab2")!, vc: LeadsVC.initWithStory())
        let second = self.createNav(title: "Notifications", image: UIImage(named: "tab3")!, vc: NotificationsVC.initWithStory())
        let third = self.createNav(title: "Customers", image: UIImage(named: "tab4")!, vc: CustomersVC.initWithStory())
        let fourth = self.createNav(title: "Profile", image: UIImage(named: "tab5")!, vc: ProfileVC.initWithStory())

        self.setViewControllers([home,initial,third,second,fourth], animated: true)
    }
    func createNav(title: String, image: UIImage, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        return nav
    }
    func setUserProfileImageOnTabbar() {
    for tabBarItem in tabBar.items! {
    //tabBarItem.title = ""
        if (tabBarItem.title?.lowercased() == "profile") {
        if let userImageUrl = UserDefaults.standard.value(forKey: "image"){
            if (userImageUrl as? String != "") {
                SDWebImageDownloader.shared.downloadImage(with: URL.init(string: userImageUrl as? String ?? "")) {
    (image, data, error, finished) in
    if (finished) {
    if let image = image {
    let finalImageUnSelected = self.getCustomImageForUserProfileImage(downloadedImage: image, borderWidth: 0).withRenderingMode(.alwaysOriginal)
    let finalImageSelected = self.getCustomImageForUserProfileImage(downloadedImage: image, borderWidth: 0).withRenderingMode(.alwaysOriginal)
    tabBarItem.image = finalImageUnSelected
    tabBarItem.selectedImage = finalImageSelected
    }
    }
    }
    }
    }
    }
    }
    }
    func getCustomImageForUserProfileImage(downloadedImage: UIImage, borderWidth: CGFloat) -> UIImage {
    var customizedPersonImage: UIImage?
    let tabBarProfileView = TabBarProfileView.createInScreenSize()
    tabBarProfileView.imageViewPerson.image = downloadedImage
    tabBarProfileView.contentView.borderWidth = borderWidth
    // Converting UIView To UIImage
    customizedPersonImage = tabBarProfileView.asImage()
    if let image = customizedPersonImage {
    return image
    } else {
    return UIImage.init(named: "ic_avatar")!
    }
    }
}
extension UIView {
func asImage() -> UIImage {
if #available(iOS 10.0, *) {
let renderer = UIGraphicsImageRenderer(bounds: bounds)
return renderer.image { rendererContext in
layer.render(in: rendererContext.cgContext)
}
} else {
UIGraphicsBeginImageContext(self.frame.size)
self.layer.render(in:UIGraphicsGetCurrentContext()!)
let image = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()
return UIImage(cgImage: image!.cgImage!)
}
}
}
