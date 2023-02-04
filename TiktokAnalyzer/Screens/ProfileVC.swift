//
//  ProfileVC.swift
//  TiktokAnalyzer
//
//  Created by krunal on 03/12/22.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet weak var pointV: PointView!
    let titleArr = ["Views","Saves","Uploads","Shares","Hashtags","Challenges"]
    var valueArr: [String] = ["","","","","",""]
    let subtitleArr = ["","","","","",""]

    @IBOutlet weak var engagement: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var follower: UILabel!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var comments: UILabel!
    var userInfo: UserModel!
    var statistics: StatisticsModel!
    
    
    var comment: StatisticsModel!
    var userDataList: [UserModel]! = []
    let userDefaults = UserDefaults.standard
    var nikcname: String = ""
    var isFirst: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillUserProfile()
        pointV.titleLbl.text = "Welcome, \(userInfo.nickname)"
        self.userName.text = userInfo.nickname
        self.following.text = "\(userInfo.following)"
        self.follower.text = "\(userInfo.follower)"
        self.likes.text = "\(userInfo.likes)"
        var firstValue: Int = userInfo.likes
        var secondValue: Double = 0.22
        var result: Double = Double(firstValue) * secondValue
        self.comments.text = "\(Int(result.rounded()))"
        self.profilePic.load(urlString: userInfo.profilePicUrl)
        self.engagement.text = self.engageCalc()
        self.collectionV.register(UINib(nibName: "ProfileCVC", bundle: nil), forCellWithReuseIdentifier: "ProfileCVC")
        
        getStats(text: userInfo.userId)
    }
  
    override func viewWillAppear(_ animated: Bool) {
        self.pointV.pointLbl.text = "\(totalPoints)"
    }
    
    
    
    func fillUserProfile(){
        userDataList = []
        let userInfoSaved: Any? = userDefaults.object(forKey: "credentials") as? Any
//        for value in userInfoSaved{
            do{
                let profileData = try JSONDecoder().decode(UserModel.self, from: userInfoSaved as! Data)
                userDataList.append(profileData)
                self.userInfo = profileData
                pointV.titleLbl.text = "Welcome, \(profileData.nickname)"
                self.userName.text = profileData.nickname
                self.following.text = "\(profileData.following)"
                self.follower.text = "\(profileData.follower)"
                self.likes.text = "\(profileData.likes)"
                var firstValue: Int = profileData.likes
                var secondValue: Double = 0.22
                var result: Double = Double(firstValue) * secondValue
                self.comments.text = "\(result.rounded(.towardZero))"
                self.profilePic.load(urlString: profileData.profilePicUrl)
                self.engagement.text = self.engageCalc()
            } catch{
                print(error)
            }
//        }
        print("User profile Loaded")
        print(userDataList)
        collectionV.reloadData()
    }
    
    
    
    func getStats (text: String){
        var semaphore = DispatchSemaphore(value: 0)
        var data: StatisticsModel!
        let contentSearch = StatisticsVM()
        contentSearch.getStats(query: text.lowercased()){
            data in
            if data != nil {
                DispatchQueue.main.async {
                    self.valueArr[0] = "\(data!.playCount)"
                    self.valueArr[1] = "\(data!.downCount)"
                    self.valueArr[2] = "\(data!.uploadCount)"
                    self.valueArr[3] = "\(data!.shareCount)"
                    self.valueArr[4] = "\(data!.hashtagCount)"
                    self.valueArr[5] = "\(data!.challengeCount)"
                    self.engageCalc()
                    self.collectionV.reloadData()
                    print(data!)

                }
            }
            semaphore.signal()

        }

        semaphore.wait()
        if data != nil{
            return
        }
        print("First request failed")
    }
    
    
    func engageCalc() -> String{
        var firstValue: Int = userInfo.likes
        var secondValue: Double = 0.22
        var commentResult: Double = Double(firstValue) * secondValue
        var sum: Int = Int(commentResult)+userInfo.likes
        var engage: String
        var div: Double = Double(userInfo.follower) / Double(sum)
        var result: Float = Float(div * 100)
        engage = "\(result.rounded())%"
        print(engage)
        return engage
    }

    
    
    
    
}

extension ProfileVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCVC", for: indexPath) as! ProfileCVC
        
        cell.titleLbl.text = titleArr[indexPath.row]
        cell.subtitleLbl.text = subtitleArr[indexPath.row]
        cell.valueLbl.text = valueArr[indexPath.row]
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 5.0

        cell.layer.cornerRadius = 5.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width-42)/2, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CollectionDetailsVC")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}



