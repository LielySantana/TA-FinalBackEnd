//
//  userIdVM.swift
//  TikAnalyzer
//
//  Created by Christina Santana on 10/1/23.
//

import Foundation
import UIKit
struct UserIdVM{
        
    func getUserId(query: String, comp:@escaping(String?)->()){
       
            let headers = [
                "X-RapidAPI-Key": "e9a9788f52msh4c925f222a786e6p1ec230jsnfad6eceba839",
                "X-RapidAPI-Host": "tokapi-mobile-version.p.rapidapi.com"
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://tokapi-mobile-version.p.rapidapi.com/v1/user/username/\(query)")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 30.0)
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
                        
                      
                        var userId = jsonData.value(forKey: "uid") as? String
                    
                        
                      print(userId)
                        print("======================USER ID VM===================================")
                        comp(userId)
                    }catch{
                       comp(nil)
                    }
                }
            })
            
            dataTask.resume()
            
        }
    
        
    }
