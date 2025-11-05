//
//  ViewPhotoViewController.swift
//  Credit4Business
//
//  Created by MacMini on 06/06/24.
//

import UIKit
import SDWebImage
class ViewPhotoViewController: UIViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    //MARK: -------------------- Class Variable --------------------
    
    var strWebUrl = ""
    var strPageTitle = "Document"

    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        lblTitle.text = strPageTitle
        self.imageView.sd_setImage(with: URL(string: strWebUrl))
        self.backButton.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)

        }
    }
   //---------------------------------------
   // MARK: - Init With Story
   //---------------------------------------

   class func initWithStory() -> ViewPhotoViewController {
       let vc : ViewPhotoViewController = UIStoryboard.Login.instantiateViewController()
       return vc
   }
   
    func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
}
