//
//  BaseViewController.swift
//  GoferHandy
//
//  Created by trioangle1 on 20/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    fileprivate var onExit : (()->())? = nil
    
    var stopSwipeExitFromThisScreen : Bool? {
        return nil
    }
    //MARK:- life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.isMovingFromParent{
            self.willExitFromScreen()
        }
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK:- UDF
    func exitScreen(animated : Bool,_ completion : (()->())? = nil){
        self.onExit = completion
        if self.isPresented(){
            self.dismiss(animated: animated) {
                completion?()
            }
        }else{
            self.navigationController?.popViewController(animated: true)
            completion?()
        }
    }
    ///called when screen will pop back
    func willExitFromScreen(){
        
    }
    func isPresented() -> Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }

}

extension BaseViewController : UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let nav = self.navigationController else {return true}
        if self.stopSwipeExitFromThisScreen ?? false{return false }
        return nav.viewControllers.count > 1
    }
    // This is necessary because without it, subviews of your top controller can
    // cancel out your gesture recognizer on the edge.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
}
