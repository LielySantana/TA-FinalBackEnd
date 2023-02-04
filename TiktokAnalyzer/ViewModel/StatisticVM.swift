//
//  StatisticVM.swift
//  TikAnalyzer
//
//  Created by Christina Santana on 8/12/22.
//

import Foundation
import UIKit
struct StatisticsVM{
    
    func getStats(query: String, comp:@escaping(StatisticsModel?)->()){

        let headers = [
            "X-RapidAPI-Key": "e9a9788f52msh4c925f222a786e6p1ec230jsnfad6eceba839",
            "X-RapidAPI-Host": "scraptik.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://scraptik.p.rapidapi.com/user-posts?user_id=\(query)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 30.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        print("https://scraptik.p.rapidapi.com/user-posts?user_id=\(query)")
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            print("===============================WEY MIRAME AQUI====================")

            if (error != nil) {
                comp(nil)
                return
                print(error)
            } else {
                do{
                    var jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary

                    var contents = jsonData.value(forKey: "aweme_list") as? [NSDictionary] ?? nil
                    var uploadsCount = 0, commentCount = 0, downloadCount = 0, playCount = 0,
                        shareCount = 0, hashtagCount = 0, challengeCount = 0
                    var minCur = jsonData.value(forKey: "max_cursor") as? Int

                    if minCur == 0 {
                        comp(nil)
                        return
                    }
                    uploadsCount = contents!.count


                    for content in contents! {
                        var stats = content.value(forKey: "statistics") as? NSDictionary
                        var textExtra = content.value(forKey: "text_extra") as? [NSDictionary]
                        var chaList = content.value(forKey: "cha_list") as? [NSDictionary]
                        commentCount = commentCount + (stats?.value(forKey: "comment_count") as! Int)
                        downloadCount = downloadCount + (stats?.value(forKey: "download_count") as! Int)
                        playCount = playCount + (stats?.value(forKey: "play_count") as! Int)
                        shareCount = shareCount + (stats?.value(forKey: "share_count") as! Int)
                        if  textExtra != nil {
                            hashtagCount = textExtra!.count
                        }
                        if chaList != nil{
                            challengeCount = chaList!.count

                        }
                    }
                    var statsModel: StatisticsModel = StatisticsModel(uploadCount: uploadsCount, commentCount: commentCount, downCount: downloadCount, playCount: playCount, shareCount: shareCount, hashtagCount: hashtagCount, challengeCount: challengeCount)
//                    print(commentCount)
                    print("======================STADISTICS===================================")
                    comp(statsModel)



                }catch{
                    comp(nil)
                }
            }
        })

        dataTask.resume()

    }
}


    
 
