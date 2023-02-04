//
//  AppDelegate.swift
//  TiktokAnalyzer
//
//  Created by krunal on 24/11/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //initial points
//        totalPoints = 100
//        return true
        
        
        if let userId = UserDefaults.standard.value(forKey: "userId") as? String {
            print("UserId is \(userId)")
        }else{
            let uId = UIDevice.current.identifierForVendor?.uuidString
            let uAd = "POTP"
            let stringC = uAd + (uId ?? "")!

            UserDefaults.standard.set(stringC, forKey: "userId")
            print("UserId ssis \(stringC)")
        }
        
        
        let userDefaults = UserDefaults.standard
        let userRawData = userDefaults.object(forKey: "credentials")
        print(userRawData)
        if(userRawData != nil){
            //is Logged in
            do {
                let userData = try JSONDecoder().decode(UserModel.self, from: userRawData as! Data)
                currentUser = userData
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MainTabVC") as? MainTabVC
                //vc?.profilePicUrl = self.userData.profilePicUrl
                appDel.window?.rootViewController = vc!
            
            } catch  {
                
            }
        }

        
  
        return true
    }
        
    }
    

    


