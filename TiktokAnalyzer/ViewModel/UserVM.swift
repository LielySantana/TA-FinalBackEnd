//
//  UserListVM.swift
//  TiktokAnalyzer
//
//  Created by Christina Santana on 6/12/22.
//

import Foundation
import UIKit
struct UserListVM{
        
    func getSearch(query: String, comp:@escaping(UserModel?)->()){
       
            let headers = [
                "X-RapidAPI-Key": "e9a9788f52msh4c925f222a786e6p1ec230jsnfad6eceba839",
                "X-RapidAPI-Host": "tokapi-mobile-version.p.rapidapi.com"
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://tokapi-mobile-version.p.rapidapi.com/v1/user/\(query)")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            print("https://tokapi-mobile-version.p.rapidapi.com/v1/user/username/\(query)")
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    do{
                        var jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        
                      
                        var userInfo = jsonData.value(forKey: "user") as? NSDictionary
                        var profilePic = userInfo!.value(forKey: "avatar_168x168") as? NSDictionary
//                        var stats = userInfo!.value(forKey: "stats") as? NSDictionary
                        var picUrl: [String] = profilePic!.value(forKey: "url_list") as! [String]
                        
                        var userId = userInfo!.value(forKey: "uid") as? String
                        var nickname = userInfo!.value(forKey: "unique_id") as? String
                        
                        
                        var followers = userInfo!.value(forKey: "follower_count") as? Int
                        var following = userInfo!.value(forKey: "following_count") as? Int
                        var likes = userInfo!.value(forKey: "total_favorited") as? Int
                        
                        var userModel: UserModel = UserModel(profilePicUrl: picUrl[0], nickname: nickname!, userId: userId!, follower: followers!, following: following!, likes: likes!, commentCount: 0)
                        
                      print(userModel)
                        print("======================USER VM===================================")
                        comp(userModel)
                    }catch{
                       comp(nil)
                    }
                }
            })
            
            dataTask.resume()
            
        }
    
        
    }
