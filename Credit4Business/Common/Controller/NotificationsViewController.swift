//
//  NotificationsViewController.swift
//  Credit4Business
//
//  Created by MacMini on 20/03/24.
//

import UIKit

class NotificationsViewController: UIViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    
    //MARK: -------------------- Class Variable --------------------

    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   //---------------------------------------
   // MARK: - Init With Story
   //---------------------------------------

   class func initWithStory() -> NotificationsViewController {
       let vc : NotificationsViewController = UIStoryboard.Main.instantiateViewController()
       return vc
   }
  
}
