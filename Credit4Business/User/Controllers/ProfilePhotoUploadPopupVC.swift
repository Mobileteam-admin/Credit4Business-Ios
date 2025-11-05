//
//  ProfilePhotoUploadPopupVC.swift
//  Credit4Business
//
//  Created by MacMini on 23/05/24.
//

import UIKit
enum SelectedProfileType : String {
    case ViewPhoto
    case UploadPhoto
}
protocol ProfileChooseDelegate {
    func selectedProfile(type: SelectedProfileType)
}
class ProfilePhotoUploadPopupVC: UIViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    
    @IBOutlet weak var viewPhotoImage: UIImageView!
    @IBOutlet weak var uploadPhotoView: UIStackView!
    @IBOutlet weak var viewPhotoView: UIStackView!
    var delegate: ProfileChooseDelegate?

    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.value(forKey: "image") as? String != "" {
            self.viewPhotoImage.sd_setImage(with: URL(string: UserDefaults.standard.value(forKey: "image") as? String ?? ""))
        }
        self.manageActionMethods()
        // Do any additional setup after loading the view.
    }
    func manageActionMethods() {
        self.uploadPhotoView.addTapGestureRecognizer {
            self.delegate?.selectedProfile(type: .UploadPhoto)
            self.dismiss(animated: true)
        }
        self.viewPhotoView.addTapGestureRecognizer {
            self.delegate?.selectedProfile(type: .ViewPhoto)
            self.dismiss(animated: true)
        }
        self.view.addTapGestureRecognizer {
            self.dismiss(animated: true)
        }
    }

    class func initWithStory() -> ProfilePhotoUploadPopupVC {
        let vc : ProfilePhotoUploadPopupVC = UIStoryboard.Login.instantiateViewController()
        return vc
    }

}

