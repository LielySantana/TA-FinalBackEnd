//
//  Login.swift
//  TikAnalyzer
//
//  Created by Christina Santana on 15/12/22.
//

import UIKit
import WebKit

class Login: UIViewController, UIWebViewDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webViewSetUp()
        tiktokLogin.addObserver(self, forKeyPath: "URL", options: .new, context: nil)

        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var tiktokLogin: WKWebView!
    
    
   
    // Observe value
    override func observeValue(forKeyPath id: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = change?[NSKeyValueChangeKey.newKey] {
            print("observeValue \(key)") // url value
        }
    }
    
    func webViewSetUp(){
        guard let Url = URL(string: "https://moonanalyticstool.com/dashinit.php?id=") else{
            return
        }
        tiktokLogin.load(URLRequest(url: Url))
        tiktokLogin.allowsBackForwardNavigationGestures = true
        
        print(Url)
        
        // Add observer
       
//        if let url = URL(string: Url.perce) {
//              let request = URLRequest(url: url as URL)
//              termWebView.loadRequest(request)
//          }
        }

    }



