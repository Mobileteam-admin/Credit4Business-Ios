//
//  DashboardViewController.swift
//  Credit4Business
//
//  Created by MacMini on 20/03/24.
//

import UIKit

class DashboardViewController: UIViewController {
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

   class func initWithStory() -> DashboardViewController {
       let vc : DashboardViewController = UIStoryboard.Main.instantiateViewController()
       return vc
   }
  
}
