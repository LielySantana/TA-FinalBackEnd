//
//  Utility.swift
//  FollowTok
//
//  Created by krunal on 3/28/20.
//  Copyright © 2020 krunal. All rights reserved.
//

import Foundation
import UIKit

var totalPoints = 0
let appDel = UIApplication.shared.delegate as! AppDelegate
var username = ""
var currentUser:UserModel!

let primaryColor = UIColor(named: "PrimaryColor")

func showAlert(title:String,msg:String,vc:UIViewController){
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
    }
    alert.addAction(okAction)
    vc.present(alert, animated: true, completion: nil)
}

func setNavigationBar(vc:UIViewController,isGreen:Bool){
    var img = UIBarButtonItem(customView: UIImageView(image: UIImage(named: "green_navigation_img")))
    if !isGreen{
        img = UIBarButtonItem(customView: UIImageView(image: UIImage(named: "red_navigation_img")))
    }
    
    let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    space.width = 15
    
    vc.navigationItem.leftBarButtonItems = [space,img]
    
    let v = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
    if isGreen{
        v.backgroundColor = UIColor(named: "primary")!
    }else{
        v.backgroundColor = UIColor(named: "secondary")!
    }
    v.layer.cornerRadius = 5.0
    
    let dollImg = UIImageView(frame: CGRect(x: 10, y: 7, width: 16, height: 16))
    dollImg.image =  UIImage(named: "doll_white")
    dollImg.tintColor = UIColor.white
    v.addSubview(dollImg)
    
    let lbl = UILabel(frame: CGRect(x: 32, y: 3, width: 40, height: 24))
    lbl.textColor = UIColor.white
    lbl.text = "\(totalPoints)"
    lbl.font = UIFont.systemFont(ofSize: 13)
    v.addSubview(lbl)
    
    let barItem = UIBarButtonItem(customView: v)
    vc.navigationItem.rightBarButtonItem = barItem
    
}

func setNavigationBarDetail(vc:UIViewController,isGreen:Bool){
    var img = UIImageView(image: UIImage(named: "split_photo_title"))
    if !isGreen{
        img = UIImageView(image: UIImage(named: "wallpaper_maker_title"))
    }
    
    vc.navigationItem.backButtonTitle = " "
    
    vc.navigationItem.titleView = img
    
    let v = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
    if isGreen{
        v.backgroundColor = UIColor(named: "primary")!
    }else{
        v.backgroundColor = UIColor(named: "secondary")!
    }
    v.layer.cornerRadius = 5.0
    
    let dollImg = UIImageView(frame: CGRect(x: 10, y: 7, width: 16, height: 16))
    dollImg.image =  UIImage(named: "doll_white")
    dollImg.tintColor = UIColor.white
    v.addSubview(dollImg)
    
    let lbl = UILabel(frame: CGRect(x: 32, y: 3, width: 40, height: 24))
    lbl.textColor = UIColor.white
    lbl.text = "\(totalPoints)"
    lbl.font = UIFont.systemFont(ofSize: 13)
    v.addSubview(lbl)
    
    let barItem = UIBarButtonItem(customView: v)
    vc.navigationItem.rightBarButtonItem = barItem
    
}


func setPoints(vc:UIViewController){
    
    vc.navigationController?.navigationBar.shadowImage = UIImage()
    
    let pointDisplayLbl = UIBarButtonItem(title: "Points", style: .plain, target: nil, action: nil)
    vc.navigationItem.leftBarButtonItem = pointDisplayLbl
    
    
    let coinImg = UIBarButtonItem(customView: UIImageView(image: UIImage(named: "doll")))
    
    let pointLbl = UIBarButtonItem(title: "\(totalPoints)", style: .plain, target: vc, action: nil)
    
    let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    space.width = 0
    
    vc.navigationItem.rightBarButtonItems = [coinImg,space,pointLbl]
    
}

func setRightPointsOnly(vc:UIViewController){
    
    let coinImg = UIBarButtonItem(customView: UIImageView(image: UIImage(named: "doll")))
    
    let pointLbl = UIBarButtonItem(title: "\(totalPoints)", style: .plain, target: vc, action: nil)
    
    let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    space.width = 0
    
    vc.navigationItem.rightBarButtonItems = [coinImg,space,pointLbl]
    
}

func updatePoints(pts:Int){
    let userId = UserDefaults.standard.value(forKey: "userId") as! String
    
    let request = NSMutableURLRequest(url: NSURL(string: "https://instads.xyz/pb_setpuntos.php?id=\(userId)&amt=\(pts)")! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error)
        } else {
            //            let str = String(decoding: data!, as: UTF8.self)
            //            print("Response \(str)")
        }
    })
    
    dataTask.resume()
}


func getPoints(){
    let userId = UserDefaults.standard.value(forKey: "userId") as! String
    
    let request = NSMutableURLRequest(url: NSURL(string: "https://instads.xyz/ptsb_puntos.php?id=\(userId)")! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error)
        } else {
            let str = String(decoding: data!, as: UTF8.self)
            print("Get Points Response \(str)")
            totalPoints = Int(str)!
            UserDefaults.standard.set(totalPoints, forKey: "points")
        }
    })
    
    dataTask.resume()
}

extension Notification.Name {
    static  let pointsUpdate = NSNotification.Name("pointsUpdate")
}
