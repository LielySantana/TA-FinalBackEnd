//
//  DownloadVC.swift
//  TiktokAnalyzer
//
//  Created by krunal on 04/12/22.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import Photos
//import RevenueCat
import Foundation
import SwiftUI

class DownloadVC: UIViewController {
    
//    @IBOutlet weak var scrollV: UIScrollView!
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet var recentView: UIView!
    @IBOutlet weak var containerV: UIView!
    @IBOutlet weak var pointV: PointView!
//    @IBOutlet weak var urlTF: UITextField!
    @IBOutlet weak var getVideos: UIButton!
    @IBOutlet weak var urlTF2: UITextField!
    
    var player: AVPlayer!
    var videoData: downModel!
    var videosDict: [downModel] = []
    let userDefaults = UserDefaults.standard
    var videoDown: Bool = false
    var videoLink: String = ""
   
    //this counter decide whether to
    var displayRecentSection = false
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        super.viewDidLoad()
        pointV.titleLbl.text = "Download Tiktoks"
        recentView.backgroundColor = UIColor.clear
        
//        urlTF.layer.cornerRadius = 20
//        urlTF.clipsToBounds = true
        
        urlTF2.layer.cornerRadius = 20
        urlTF2.clipsToBounds = true
        
        print("This is the dict \(videosDict.count)")
        
        self.videoDown = loadDownloads(videoInfo: videoLink)
        
        
        
        
          
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pointV.pointLbl.text = "\(totalPoints)"
        
        self.videoDown = loadDownloads(videoInfo: self.videoLink)
        
        
        
        videosDict = []
        let savedDict: [String:Any] = userDefaults.object(forKey: "videoSaved") as? [String: Any] ?? [:]
        print(savedDict.keys.count)
        for (_, value) in savedDict{
            do{
                let videoData = try JSONDecoder().decode(downModel.self, from: value as! Data)
                videosDict.append(videoData)
                
                print(videosDict)
            } catch{
                print(error)
            }
        }
        print("Recent viewed loaded")
        collectionV.reloadData()
        
        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if displayRecentSection{
//            scrollV.isHidden = true
//            recentView.frame = CGRect(x: 0, y: 0, width: containerV.frame.size.width, height: containerV.frame.size.height)
//            containerV.addSubview(recentView)
//        }
//
        
    }

    

    func loadDownloads(videoInfo:String)->Bool{
        var recentDict: [String:Any] = userDefaults.object(forKey: "videoSaved") as? [String:Any] ?? [:]
        var exist = recentDict[videoInfo]
        if(exist == nil){
            return false
        }
        return true
    }
    
    
    @IBAction func generateVid(_ sender: UIButton) {
        if(self.urlTF2.text != ""){
//            self.checkText(text: urlTF.text!)
            self.videoMedia(text: urlTF2.text!)
            
           
           
        } else {
            print("Empty text")
        }
        
        
    }

    
    func videoMedia(text: String){
        var data: downModel!
        let contentSearch = DownloadVM()
        contentSearch.getSearch(query: text){
            data in
            if data != nil {
                    
                DispatchQueue.main.async {
                    
                    self.videoData = data!
                    print(data!.videoUrl)
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "DownloadDetailsVC") as? DownloadDetailsVC
                    vc?.link = data!.videoUrl
                    vc?.vidId = data!.videoId
                    vc?.cover = data!.cover
                    vc?.videoMedia = data!
                    self.navigationController?.pushViewController(vc!, animated: true)
                    
                    print("Here goes the data")
                }
                    
                    
                   
            }
        }
        
    }
    
    
}


extension String {
    func trimmingAllSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        return components(separatedBy: characterSet).joined()
    }
}


extension DownloadVC:UITextFieldDelegate{


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        displayRecentSection = true
        let vc = storyboard?.instantiateViewController(withIdentifier: "DownloadDetailsVC")

        self.navigationController?.pushViewController(vc!, animated: true)
        return true

    }
}

extension DownloadVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if videosDict.count <= 10{
            return videosDict.count
        } else {
            return 10
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TiktokUserCVC", for: indexPath) as! TiktokUserCVC
        
        let currentMedia = videosDict[indexPath.row]
        cell.videoImgV.load(urlString: currentMedia.cover)
        cell.media = currentMedia
        print(currentMedia)
        cell.layer.cornerRadius = 5.0
        return cell
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: floor((collectionView.frame.size.width-52)/3), height: collectionView.frame.size.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        displayRecentSection = true
        guard let currentCell = collectionView.cellForItem(at: indexPath) as? TiktokUserCVC else {return}
        let vc = storyboard?.instantiateViewController(withIdentifier: "DownloadDetailsVC") as? DownloadDetailsVC
        vc?.vidId = currentCell.media.videoId
        vc?.cover = currentCell.media.cover
        vc?.link = currentCell.media.videoUrl
        vc?.videoMedia = currentCell.media
        
                self.navigationController?.pushViewController(vc!, animated: true)
            }
         
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath)
        return header
    }
}


class TiktokUserCVC:UICollectionViewCell{
    
    @IBOutlet weak var videoImgV: UIImageView!
    var media: downModel!
}
