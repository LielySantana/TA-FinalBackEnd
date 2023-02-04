//
//  login2vc.swift
//  TikAnalyzer
//
//  Created by Christina Santana on 4/1/23.
//
//
//import Foundation
//import UIKit
//
//class Login2VC: UIViewController{
//
//    override func viewDidLoad(){
//        self.hideKeyboardWhenTappedAround()
//        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = true
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        fillHistory()
//    }
////
//    
//    @IBOutlet weak var collectionV: UICollectionView!
//    @IBOutlet weak var userNameTF: UITextField!
//
//    
//    var isSearching = false
////    var comment: StatisticsModel!
//    var userData: UserModel!
//    var userDataList: [UserModel]! = []
//    let userDefaults = UserDefaults.standard
//    var nikcname: String = ""
//    var isFirst: Bool = true
//   
//    
//   
//    
//    @IBAction func searchBtnPressed(_ sender: UIButton) {
//        if(self.userNameTF.text != ""){
//            self.checkText(text: userNameTF.text!)
//            let loader = self.loader()
//            loader
//            
//            var group = DispatchGroup()
//            group.enter()
//            SearchContent(text: userNameTF.text!)
//            group.leave()
//            group.enter()
//            self.getComments(text: self.userNameTF.text!)
//            group.leave()
//            group.notify(queue: .main){
//                self.stopLoader(loader: loader)
//            }
//           
//           
//            
//        } else {
//            print("Empty text")
//        }
//        
////        searchTF.resignFirstResponder()
////        isSearching = !searchTF.text!.isEmpty
////        collectionV.reloadData()
//        
//    }
//    func history(userData: UserModel){
//        var historyData : [String:Any] = (self.userDefaults.object(forKey: "history") as? [String:Any])!
//        do{
//            let encoder = JSONEncoder()
//            let data = try encoder.encode(userData)
//            historyData[userData.nickname] = data
//            userDefaults.set(historyData, forKey: "history")
//            print("history search added")
//            print(historyData.keys.count)
//        }catch{
//            print(error)
//        }
//    }
//    
//    func fillHistory(){
//        userDataList = []
//        let userhistory: [String:Any] = userDefaults.object(forKey: "history") as? [String:Any] ?? [:]
//        for (_, value) in userhistory{
//            do{
//                let profileData = try JSONDecoder().decode(UserModel.self, from: value as! Data)
//                
//                userDataList.append(profileData)
//            } catch{
//                print(error)
//            }
//        }
//        print("Recent search loaded")
//        print(userDataList)
//        collectionV.reloadData()
//    }
//    
//    func SearchContent (text: String){
//        isFirst = false
//        let contentSearch = UserListVM()
//        contentSearch.getSearch(query: text.lowercased()){
//            data in
//            if data != nil {
//                DispatchQueue.main.async {
//                    self.userDataList = []
//                    var currentUser = data
//                        currentUser!.commentCount = 3000
//                    self.userDataList.append(data!)
//                    self.collectionV.reloadData()
////                    print(data!)
//
//                    }
//                }
//            }
//    }
//    
//    func getComments (text: String){
//        var semaphore = DispatchSemaphore(value: 0)
//        var data: StatisticsModel!
//        let contentSearch = StatisticsVM()
//        contentSearch.getSearch2(query: text.lowercased()){
//            data in
//            if data != nil {
//                DispatchQueue.main.async {
//                    var currentUser = self.userDataList[0]
//                    currentUser.commentCount = data!.commentCount
//                    self.userDataList = [currentUser]
//                    self.collectionV.reloadData()
//                    print(data!)
//                    
//                }
//            }
//            semaphore.signal()
//        }
//        
//        semaphore.wait()
//        if data != nil{
//            return
//        }
//        print("First comment request failed")
////        contentSearch.getSearch2(query: text.lowercased()){
////        data in
////        if data != nil {
////            DispatchQueue.main.async {
////                var currentUser = self.userDataList[0]
////                currentUser.commentCount = data!.commentCount
////                self.userDataList = [currentUser]
////                self.collectionV.reloadData()
////                print(data!)
////
////            }
////        } else {
////            print("Second comment request failed")
////            self.tryLateAlert()
////        }
////        semaphore.signal()
////        }
//    }
//                
            
        
    
    
    
  


//extension UIViewController{
//    func checkText(text: String?){
//        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
//        if text!.rangeOfCharacter(from: characterset.inverted) != nil{
//            print("String with special characters")
//
//        } else {
//            return
//            }
//        }
//}

//extension UserListVC:UISearchBarDelegate{
////    func searchBarSearchButtonClicked(_ text: UISearchBar) {
////        searchBar.resignFirstResponder()
////    }
////}

//extension Login2VC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return userDataList.count
//        
//        
////        if userData != nil {
////            if userHistory.count <= 10 {
////                return userHistory.count
////            } else {
////                return 10
////                }
////        }
////        return 0
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCVC2Login", for: indexPath) as! UserCVC2Login
//        var currentData = userDataList[indexPath.item]
//        cell.userInfo = currentData
//        cell.imgV.load(urlString: currentData.profilePicUrl)
//        cell.titleLbl.text = currentData.nickname
//        cell.layer.cornerRadius = 5.0
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (collectionView.frame.size.width-42)/2, height: 65)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileDetailsVC") as? ProfileDetailsVC else {return}
//        history(userData: self.userDataList[indexPath.row])
//        vc.userInfo = self.userDataList[indexPath.row]
//       
//       
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.size.width, height: 40)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UserHeaderView", for: indexPath) as! UserHeaderView
//        header.titleLbl.text = isSearching ? "Search Results" : "Recent Search"
//        return header
//    }
//}
//
//class UserCVC2Login:UICollectionViewCell{
//    @IBOutlet weak var imgV: UIImageView!
//    @IBOutlet weak var titleLbl: UILabel!
//    var userInfo: UserModel!
//    
//}





//var imageCache = NSCache<AnyObject,AnyObject>()
//extension UIImageView {
//    func load(urlString : String) {
//        if  let image = imageCache.object(forKey: urlString as NSString)as? UIImage{
//            self.image = image
//            return
//        }
//        guard let url = URL(string: urlString)else {
//            return
//        }
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        imageCache.setObject(image, forKey: urlString as NSString)
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}


