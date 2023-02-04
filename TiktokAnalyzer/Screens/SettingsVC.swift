//
//  SettingsVC.swift
//  story_viewer
//
//  Created by krunal on 27/11/22.
//

import UIKit
import StoreKit

class SettingsVC: UIViewController {
    var userData: UserModel!
    var userDataList: [UserModel]! = []
    let userDefaults = UserDefaults.standard
    var nikcname: String = ""
    var userId: String!
    
    
    @IBOutlet weak var pointV: PointView!

    @IBOutlet weak var tableV: UITableView!
    let imgArr = ["rate_us","share","restore", "sign-out"]
    let titleArr = ["Rate Us","Share App","Restore Purchases", "Sign Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pointV.titleLbl.text = "Settings"

    }
    override func viewWillAppear(_ animated: Bool) {
        self.pointV.pointLbl.text = "\(totalPoints)"
    }
    
    @objc func notificationPressed(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationVC")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()

        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "appId") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)

            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
  
    func restore(){
        if (SKPaymentQueue.canMakePayments()) {
          SKPaymentQueue.default().restoreCompletedTransactions()
            print("Purchase restored!")
        }
    }
    
    func share(){
        let url = URL(string: "Link")!
        let text = "Hey!, you should try this App."
        let activity = UIActivityViewController(activityItems: [url, text], applicationActivities: nil)
        present(activity, animated: true)
    }
    
    
    func signOut(){
       //delete credentials from user defaults
        userDefaults.removeObject(forKey: "credentials")
        print("Removed")
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        appDel.window?.rootViewController = vc!
       
        
    }
    
}

extension SettingsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTVC") as! SettingsTVC
        cell.imgV.image = UIImage(named: imgArr[indexPath.row])
        cell.titleLbl.text = titleArr[indexPath.row]
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch (indexPath.row) {
        case 0:
            rateApp()
            print("Rate app")
            break
        case 1:
            share()
            print("Share app")
            break
        case 2:
           restore()
            print("Restore app")
            break
        case 3:
            self.signOut()
            print("Sing out")
        default:
            break
        }
    }
}

class SettingsTVC:UITableViewCell{
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
}
