//
//  ProfileDetailsVC.swift
//  TiktokAnalyzer
//
//  Created by krunal on 03/12/22.
//

import UIKit

class ProfileDetailsVC: UIViewController {
    
    @IBOutlet weak var actIndV: UIActivityIndicatorView!
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet weak var pointV: PointDetailView!
    let titleArr = ["Views","Saves","Uploads","Shares","Hashtags","Challenges"]
    var valueArr: [String] = ["","","","","",""]
    let subtitleArr = ["","","","","",""]
    @IBOutlet weak var analyzeBtn: UIButton!
    @IBOutlet weak var engagementV: UIView!
    @IBOutlet weak var msgLbl: UILabel!
    
    @IBOutlet weak var engagePorc: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var likes: UILabel!
    var userInfo: UserModel!
    var statistics: StatisticsModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStats(text: userInfo.userId)
        pointV.titleLbl.text = userInfo.nickname
        self.userName.text = userInfo.nickname
        self.following.text = "\(userInfo.following)"
        self.followers.text = "\(userInfo.follower)"
        self.likes.text = "\(userInfo.likes)"
        self.comment.text = "\(userInfo.commentCount)"
        self.profilePic.load(urlString: userInfo.profilePicUrl)
        pointV.backBtn.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        self.collectionV.register(UINib(nibName: "ProfileCVC", bundle: nil), forCellWithReuseIdentifier: "ProfileCVC")
        
        //initially show anayze button only post subscription show result
        collectionV.isHidden = true
        engagementV.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pointV.pointLbl.text = "\(totalPoints)"
    }
    
    @IBAction func analyzeBtnPress(_ sender: UIButton) {
        getStats(text: userInfo.userId)
        if totalPoints < 100{
            self.tabBarController?.selectedIndex = 4
            return
            
        }
        
        
        
        
        
        
        let alertVC = UIAlertController(title:"Analyze Profile", message: "By confirming this, 100 coins are going to be substracted from your app wallet.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            totalPoints -= 100
            self.pointV.pointLbl.text = "\(totalPoints)"
            self.analyzeBtn.isHidden = true
            self.engagementV.isHidden = false
            self.engagePorc.text = self.engageCalc()
            self.msgLbl.isHidden = true
            self.actIndV.startAnimating()
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                self.actIndV.stopAnimating()
                self.collectionV.isHidden = false
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc func backPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getStats (text: String){
        var semaphore = DispatchSemaphore(value: 0)
        var data: StatisticsModel!
        let contentSearch = StatisticsVM()
        contentSearch.getStats(query: userInfo.userId){
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
                            print("=======================SOY COMMENT COUNT=====")
                            self.comment.text = "\(data!.commentCount)"

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
            var sum: Int = userInfo.commentCount+userInfo.likes
            var engage: String
            var div: Double = Double(userInfo.follower) / Double(sum)
            var result: Float = Float(div * 100)
            engage = "\(result.rounded())%"
            print(engage)
            return engage
        }
}


extension ProfileDetailsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
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



