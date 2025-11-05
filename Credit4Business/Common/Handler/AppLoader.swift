//
//  AppLoader.swift


import UIKit
import Lottie

class AppLoader {
    
    //MARK: Shared Instance
    static let shared: AppLoader = AppLoader()
    
    //MARK: Class Variables
    private let viewBGLoder: UIView = UIView()
    private var loaderAnimation: LottieAnimationView = LottieAnimationView(name: "app_loader")
    
    //MARK: Class Funcation
    
    /**
     Add app loader
     */
    func addLoader() {
        
        self.removeLoader()
        DispatchQueue.main.async {
            self.viewBGLoder.frame                  = UIScreen.main.bounds
            self.viewBGLoder.tag                    = 1307966
            self.viewBGLoder.backgroundColor        = UIColor.black.withAlphaComponent(0.2)
            self.loaderAnimation.backgroundColor    = .clear
            self.loaderAnimation.loopMode           = .loop
            self.loaderAnimation.autoresizingMask   = [.flexibleHeight, .flexibleWidth]
            self.loaderAnimation.contentMode        = .scaleAspectFit
            self.loaderAnimation.frame              = CGRect(x: (ScreenSize.width/2)-25,
                                                             y: (ScreenSize.height/2)-25,
                                                             width: 50, height: 50)
            self.loaderAnimation.backgroundBehavior = .pauseAndRestore
            self.loaderAnimation.animationSpeed     = 1
            self.loaderAnimation.play()
            
            
            self.viewBGLoder.addSubview(self.loaderAnimation)
            UIApplication.shared.windows.first?.addSubview(self.viewBGLoder)
            UIApplication.shared.windows.first?.isUserInteractionEnabled = false
        }
    }
    
    /**
     Remove app loader
     */
    func removeLoader() {
        DispatchQueue.main.async {
            UIApplication.shared.windows.first?.isUserInteractionEnabled = true
            self.loaderAnimation.stop()
            self.loaderAnimation.removeFromSuperview()
            self.viewBGLoder.removeFromSuperview()
            UIApplication.shared.windows.first?.viewWithTag(1307966)?.removeFromSuperview()
        }
    }
}

//MARK:- Screen resolution
struct ScreenSize {
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    static var heightAspectRatio: CGFloat {
        return UIScreen.main.bounds.size.height / 667
    }
    
    static var widthAspectRatio: CGFloat {
        return UIScreen.main.bounds.size.width / 375
    }
    
    static var fontAspectRatio : CGFloat {
        if UIDevice().userInterfaceIdiom == .pad {
            return UIScreen.main.bounds.size.height / 667
        }
        
        let size = UIScreen.main.bounds.size
        
        if UIApplication.shared.statusBarOrientation.isPortrait {//Potrait
            return UIScreen.main.bounds.size.width / 375
            
        } else {//Landscape
            return UIScreen.main.bounds.size.height / 375
        }
    }
    
    static var cornerRadious: CGFloat {
        return 10
    }
}
