//
//  ImageChooseViewController.swift
//  Credit4Business
//
//  Created by MacMini on 14/03/24.
//

import UIKit
enum SelectedImageType : String {
    case Camera
    case Gallery
}
protocol ImageChooseDelegate {
    func selectedImage(type: SelectedImageType)
}
class ImageChooseViewController: UIViewController {

    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var galleryLabel: UILabel!
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var selectImageLabel: UILabel!
    
    var delegate: ImageChooseDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.viewBottomConstraint.constant = 0
        self.showAnimate()
        self.applyStyle()
        self.manageActionMethods()
        self.cameraView.isHidden = true
        self.separatorView.isHidden = true
        self.heightConstraint.constant = 170//160
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            self.cameraView.isHidden = false
            self.separatorView.isHidden = false
            self.heightConstraint.constant = 220
        }
    }
    //MARK: -------------------- Action Methods --------------------
    func manageActionMethods(){
        self.cameraView.addTapGestureRecognizer {
            self.delegate?.selectedImage(type: .Camera)
            self.dismiss(animated: true)
        }
        self.galleryView.addTapGestureRecognizer {
            self.delegate?.selectedImage(type: .Gallery)
            self.dismiss(animated: true)

        }
    }
    //MARK: -------------------- Custome Methods --------------------
    func applyStyle() {
        self.galleryLabel.font = UIFont(name: "Poppins-Medium", size: 14)
        self.cameraLabel.font = UIFont(name: "Poppins-Medium", size: 14)
        
        self.selectImageLabel
            .font = UIFont(name: "Poppins-Medium", size: 16)
    }

    func showAnimate() {
        
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeAnimate()
    }
}
