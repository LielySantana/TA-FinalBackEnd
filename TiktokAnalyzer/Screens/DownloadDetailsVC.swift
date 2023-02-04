//
//  DownloadDetailsVC.swift
//  TiktokAnalyzer
//
//  Created by krunal on 05/12/22.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import Photos
//import RevenueCat
import Foundation
import SwiftUI

class DownloadDetailsVC: UIViewController {
    
    @IBOutlet weak var pointV: PointDetailView!
    @IBOutlet weak var videoView: UIImageView!
    var player: AVPlayer!
    var videoMedia: downModel!

    var link: String!
    var cover: String!
    var vidId: String!
    var videosDict: [downModel] = []
    let userDefaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        pointV.titleLbl.text = "Download Tiktoks"
        pointV.backBtn.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        self.videoView.load(urlString : cover)
        
        print(vidId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pointV.pointLbl.text = "\(totalPoints)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        playVid()
    }
    
    @objc func backPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //Download videos
    func downVid(){
        print(videoMedia)
        
        var vidData : [String:Any] = userDefaults.object(forKey: "videoSaved") as? [String:Any] ?? [:]
        do{
            let encoder = JSONEncoder()
            let data = try encoder.encode(videoMedia)
            vidData[vidId] = data
            userDefaults.set(vidData, forKey: "videoSaved")
            print("New video downloaded")
            print(vidData.keys.count)
            print(vidData)
        }catch{
            print(error)
        }
    }
    
    
    func playVid(){
        let loader = self.loader()
        let videoUrl = URL(string: link)
        let videoData = link
        player = AVPlayer(url: videoUrl!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoView.bounds
        self.videoView.layer.addSublayer(playerLayer)
        self.stopLoader(loader: loader)
        player.play()
        print(videoData!)
    }
    
    
    
    @IBAction func downloadBtnPress(_ sender: UIButton) {
        if totalPoints < 50{
            self.tabBarController?.selectedIndex = 4
            return
        }
        
        
        
        let alertVC = UIAlertController(title:"Download Tiktok", message: "By confirming this, 50 coins are going to be substracted from your app wallet. \n Your video is going to be added to the recent's section", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            totalPoints -= 50
            self.pointV.pointLbl.text = "\(totalPoints)"
            
            
            self.player.pause()
            self.downVid()
            self.navigationController?.popViewController(animated: true)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
}


