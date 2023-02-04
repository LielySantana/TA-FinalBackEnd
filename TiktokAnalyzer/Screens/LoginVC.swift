//
//  LoginVC.swift
//  TiktokAnalyzer
//
//  Created by krunal on 24/11/22.
//

import UIKit
import SwiftUI

class LoginVC: UIViewController, UIGestureRecognizerDelegate{
    
    var comment: StatisticsModel!
    var userData: UserModel!
    var userDataList: [UserModel]! = []
    let userDefaults = UserDefaults.standard
    var nikcname: String = ""
    var userId: String!
    var isFirst: Bool = true
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
   
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loggedView: UIView!
    @IBOutlet weak var userView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userView.isHidden = true
        loggedView.isHidden = true
        //if there is a user saved in credentials dont show the login, just open the tabbar
        imgV.layer.cornerRadius = imgV.frame.width/2
        imgV.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideKeyboardWhenTappedAround()
    }
    

    
    
    @IBAction func enter(_ sender: UIButton) {
        if userData != nil{
            self.credentials(userData: self.userData)
            let vc = storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as? MainTabVC
//            vc?.profilePicUrl = self.userData.profilePicUrl
            appDel.window?.rootViewController = vc!
            
        }
    }
    
    @IBAction func loginBtnPress(_ sender: UIButton) {
        if(self.userName.text != ""){
            self.checkText(text: userName.text!)
            let loader = self.loader()
            loader
            var group = DispatchGroup()
            group.enter()
            getId(text: userName.text!)
            group.leave()
            group.notify(queue: .main){
                self.stopLoader(loader: loader)
            }
           
        } else {
            print("Empty text")
        }
        
    }
    
    func credentials(userData: UserModel){
//        var credentialData : [String:Any] = (self.userDefaults.object(forKey: "credentials") as? [String:Any]) ?? [:]
        do{
            let encoder = JSONEncoder()
            currentUser = userData
            let data = try encoder.encode(userData)
//            credentialData[userData.nickname] = data
            userDefaults.set(data, forKey: "credentials")
            print("Credentials saved")
            
        }catch{
            print(error)
        }
    }
   
    func getId(text: String){
        isFirst = false
        let userIdVm = UserIdVM()
        userIdVm.getUserId(query: text.lowercased()){
            userId in
            if userId != nil {
                DispatchQueue.main.async {
                    print(userId)
                    self.getUserData(idText: userId!)
                    self.userView.isHidden = false
//                    self.userId = userId
                    }
                }
            }
    }
    
    func getUserData(idText: String){
        let userVm = UserListVM()
        userVm.getSearch(query: idText){
            data in
            if data != nil{
                DispatchQueue.main.async {
                    self.userDataList = []
                    self.userData = data
                    self.userDataList.append(data!)
                    self.credentials(userData: self.userData!)
                    self.imgV.load(urlString: data!.profilePicUrl)
                    self.titleLbl.text = data?.nickname
                }
            } else {
                //Here comes an alert with an error message
            }
        }
    }
    
    

    func getComments(text: String){
        var semaphore = DispatchSemaphore(value: 0)
        var data: StatisticsModel!
        let contentSearch = StatisticsVM()
        contentSearch.getStats(query: text.lowercased()){
            data in
            if data != nil {
                DispatchQueue.main.async {
                    var currentUser = self.userDataList[0]
                    currentUser.commentCount = data!.commentCount
                    self.userDataList = [currentUser]
//                    self.collectionV.reloadData()
                    print(data!)

                }
            }
            semaphore.signal()
        }

        semaphore.wait()
        if data != nil{
            return
        }
        print("First comment request failed")
    }
                


}


