//
//  DownloadVM.swift
//  TikAnalyzer
//
//  Created by Christina Santana on 13/12/22.
//

import Foundation
import UIKit
struct DownloadVM{
    
    func getSearch(query: String, comp:@escaping(downModel?)->()){
        
        let headers = [
            "X-RapidAPI-Key": "e9a9788f52msh4c925f222a786e6p1ec230jsnfad6eceba839",
            "X-RapidAPI-Host": "tiktok-downloader-download-tiktok-videos-without-watermark.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://tiktok-downloader-download-tiktok-videos-without-watermark.p.rapidapi.com/vid/index?url=\(query)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in

            if (error != nil) {
                comp(nil)
                return
            } else {

                do{
                    var jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    var video = jsonData.value(forKey: "video") as? [String]
                    var videoId = jsonData.value(forKey: "videoid") as? [String]
                    var cover = jsonData.value(forKey: "cover") as? [String]
                    var userName = jsonData.value(forKey: "author") as? [String]
                    var profilePic = jsonData.value(forKey: "avatar_thumb") as? [String]
                    
                    var modelDown: downModel = downModel(videoUrl: video![0], cover: cover![0], author: userName![0], videoId: videoId![0], avatar_thumb: profilePic![0])
//
                    comp(modelDown)
                }catch{
                    comp(nil)
                  
                }
                
            }
        })
        
        dataTask.resume()
    
        
        
    }
}
