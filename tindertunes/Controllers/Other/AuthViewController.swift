//
//  AuthViewController.swift
//  tindertunes
//
//  Created by Sydney Chiang on 3/18/21.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {

    
    //@IBOutlet weak var webView: WKWebView!
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    public var completionHandler: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)


        guard let url = AuthManager.shared.signInURL else {
            return
        }
        
        webView.load(URLRequest(url: url))
        
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds

    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        
        print(url)
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: {$0.name == "code"})?.value else{
            return
        }
        webView.isHidden = true
        print("Code: \(code)")
        AuthManager.shared.exchangeCodeForToken(code: code){ [weak self] success in
            DispatchQueue.main.async{
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)

            }
        }
        
        if AuthManager.shared.isSignedIn{
            print("inside issigned in")
            
            self.performSegue(withIdentifier: "isSignedIn", sender: self)
            
        }
    }
}
