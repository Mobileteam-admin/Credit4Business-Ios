//
//  WebViewController.swift
//  Credit4Business
//
//  Created by MacMini on 19/03/24.
//

import UIKit
import WebKit
class WebViewController: UIViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet var webCommon: WKWebView?
    @IBOutlet var lblTitle: UILabel!
    
    //MARK: -------------------- Class Variable --------------------
    
    var strWebUrl = ""
    var strPageTitle = ""
    var isToRedirect = false
    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webCommon?.navigationDelegate = self
        self.webCommon?.uiDelegate = self
        self.navigationController?.isNavigationBarHidden = true
        lblTitle.text = strPageTitle
        let request = URLRequest(url: URL(string: self.strWebUrl)!)
        webCommon?.load(request)
        self.backButton.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)

        }
    }
   //---------------------------------------
   // MARK: - Init With Story
   //---------------------------------------

   class func initWithStory() -> WebViewController {
       let vc : WebViewController = UIStoryboard.Main.instantiateViewController()
       return vc
   }
   
    func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
}
extension WebViewController: WKNavigationDelegate,WKUIDelegate {

    
    // 1. Decides whether to allow or cancel a navigation.
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        
        print("*********************************************************navigationAction load:\(String(describing: navigationAction.request.url))")
        let str = String(describing: navigationAction.request.url)
//        if str.contains("https://credit.demoserver.work"){
//            if self.isToRedirect {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    self.goBack()
//                }
//            }
//
//        } else {
//            print("Error ----------------------------------")
//        }
        decisionHandler(.allow)
    }
    
    // 2. Start loading web address
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start load:\(String(describing: webView.url))")
    }
    
    // 3. Fail while loading with an error
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        print("fail with error: \(error.localizedDescription)")
    }
    
    // For Http Handling
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil) ; return }
            let exceptions = SecTrustCopyExceptions(serverTrust)
            SecTrustSetExceptions(serverTrust, exceptions)
            completionHandler(.useCredential, URLCredential(trust: serverTrust));
    }
    
    // 4. WKWebView finish loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish loading")
        webView.evaluateJavaScript("document.getElementById('data').innerHTML", completionHandler: { result, error in
//            self.goBack()
        })
        let str = String(describing: webView.url?.absoluteString)
        //if str.contains("https://staging.d2eazydwukyepn.amplifyapp.com/gocadless-success"){

        if str.contains("https://credit4-b.demoserver.work/gocadless-success"){
            if self.isToRedirect {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.goBack()
                }
            }
           
        } else {
            print("Error ----------------------------------")
        }


        print("didFinish")
    }
}
