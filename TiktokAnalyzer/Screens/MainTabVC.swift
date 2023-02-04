//
//  CustomTabViewController.swift
//  STTabbar_Example
//
//  Created by Shraddha Sojitra on 19/06/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class MainTabVC: UITabBarController {
    var profilePicUrl: String!
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let myTabbar = tabBar as? STTabbar {
            myTabbar.tintColor = UIColor.red
            self.imageView.load(urlString: currentUser.profilePicUrl)
            print(currentUser.profilePicUrl)
//            imageView.layer.cornerRadius = imageView.frame.width/2
//            imageView.layer.masksToBounds = true
            myTabbar.buttonImage = imageView.image
            myTabbar.centerButtonActionHandler = {
                print("Center Button Tapped")
                self.selectedIndex = 2;
            }
        }
    }
    
   
    
    
    @objc func getPoints(){
            print("Points requested===================================")
            let userId = UserDefaults.standard.value(forKey: "userId") as! String
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://viraltools.xyz/ptsb_puntos.php?id=\(userId)")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
           
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    let str = String(decoding: data!, as: UTF8.self)
                    NotificationCenter.default.post(name: .pointsUpdate, object: nil,userInfo: ["points":str])
                    print("====================Get Points Response \(str)")
                    totalPoints = Int(str)!
                    print(request)
                    print(totalPoints)
                    UserDefaults.standard.set(totalPoints, forKey: "points")
                    
                    NotificationCenter.default.post(name: .pointsUpdate, object: nil,userInfo: ["points":str])
                }
            })
            
            dataTask.resume()
    }
  
    
}
