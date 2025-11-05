//
//  TabBarProfileView.swift
//  Credit4Business
//
//  Created by MacMini on 30/05/24.
//

import UIKit

class TabBarProfileView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageViewPerson: UIImageView!
    // MARK: - Class Level Functions
    class func createInScreenSize() -> TabBarProfileView {
    let view: TabBarProfileView = Bundle.main.loadNibNamed("TabBarProfileView", owner: nil, options: nil)![0] as! TabBarProfileView
    view.contentView.layer.cornerRadius = view.contentView.frame.size.width / 2
    view.imageViewPerson.layer.cornerRadius = view.imageViewPerson.frame.size.width / 2
    return view
    }

}
