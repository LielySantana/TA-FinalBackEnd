//
//  StoreVC.swift
//  FollowTok
//
//  Created by krunal on 3/28/20.
//  Copyright © 2020 krunal. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit

class StoreVC: UIViewController {
    
    @IBOutlet weak var pointV: PointView!
    
    //Dollar price array
    let dollarArr = [0.99,1.99,3.99,6.99,11.99,19.99,29.99,49.99,99.99]
    
    //percentage off array
    let discountArr = [0,15,20,30,35,40,55,70,80]
    
    //points off array
    let pointsArr = [100,250,500,1000,3000,6500,10000,20000,50000]
    
    let bundleIdArr = ["com.sperdian.TiktokAnalyze.iapp099","com.sperdian.TiktokAnalyze.iapp199","com.sperdian.TiktokAnalyze.iapp399","com.sperdian.TiktokAnalyze.iapp699","com.sperdian.TiktokAnalyze.iapp1199","com.sperdian.TiktokAnalyze.iapp1999","com.sperdian.TiktokAnalyze.iapp2999","com.sperdian.TiktokAnalyze.iapp4999","com.sperdian.TiktokAnalyze.iapp9999"]
    
    let headerArr = ["Points Available","Earn Points",""]
    
    var productArr = [SKProduct]()
    
    //collectionview displayed on screen for points and price
    @IBOutlet weak var storeCV: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pointV.titleLbl.text = "Coins"
        self.navigationController?.navigationBar.clipsToBounds = true
        
        PKIAPHandler.shared.setProductIds(ids: bundleIdArr)
        PKIAPHandler.shared.fetchAvailableProducts { [weak self](products)   in
            guard let sSelf = self else {return}
            sSelf.productArr = products
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pointV.pointLbl.text = "\(totalPoints)"
    }
    
    
    
    
    func getPoints(){
        
        //In this method we are going to set up the ads 
    }
    
}

extension StoreVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //First section is for only show available points
        //Second section o show price cells
        return headerArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section < 2 {
            //incase first section no rows
            return 0
        }
        return dollarArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //PriceCVC Identifier given to collectionview cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PriceCVC", for: indexPath) as! PriceCVC
        cell.priceLbl.text = "$\(dollarArr[indexPath.row]) USD"
        cell.pointsLbl.text = "\(pointsArr[indexPath.row])"
        
        cell.priceLbl.textColor = UIColor.white
        cell.pointsLbl.textColor = UIColor.white
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.white.cgColor
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 64, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //points available header here
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PointsCVC", for: indexPath) as! PointsCVC
        
        
        //display header title
        header.headerLbl.text = headerArr[indexPath.section]
        header.headerLbl.textColor = UIColor.white
        if indexPath.section == 0 {
            //display points
            header.stackV.isHidden = false
            header.contentView.layer.cornerRadius = 5.0
            header.pointsLbl.text = "\(totalPoints)"
        }else if indexPath.section == 1 {
            //display points
            header.stackV.isHidden = false
            header.contentView.layer.cornerRadius = 5.0
            header.pointsLbl.text = "+5"
        }else{
            //not to display points
            header.stackV.isHidden = true
            header.contentView.clipsToBounds = true
            header.contentView.layer.cornerRadius = 5.0
            header.contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        header.contentView.layer.cornerRadius = 10.0
        header.contentView.layer.borderWidth = 1.0
        header.contentView.layer.borderColor = UIColor.white.cgColor
        header.contentView.backgroundColor = UIColor.clear
        
        /* header.contentView.clipsToBounds = true*/
        return header
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section < 2{
            return CGSize(width: collectionView.frame.width - 32, height: 40)
        }
        return CGSize(width: collectionView.frame.width - 32, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            let alertVC = UIAlertController(title:"Confirm", message: "Do you want to purchase \(pointsArr[indexPath.row]) points", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Yes", style: .default) { _ in
                totalPoints = totalPoints + Int(self.pointsArr[indexPath.row])
                self.pointV.pointLbl.text = "\(totalPoints)"
                self.storeCV.reloadData()
                
                //                self.puchaseProduct(indexNo: indexPath.row)
            }
            
            let cancelAction = UIAlertAction(title: "No", style: .default) { _ in
                
            }
            
            alertVC.addAction(okAction)
            alertVC.addAction(cancelAction)
            present(alertVC, animated: true, completion: nil)
            
        }
    }
    
    func puchaseProduct(indexNo:Int){
        
        var pr : SKProduct?
        for item in productArr {
            if item.productIdentifier ==  bundleIdArr[indexNo]{
                pr = item
                break
            }
        }
        
        
        PKIAPHandler.shared.purchase(product: pr!) { (alert, product, transaction) in
            if let tran = transaction, let prod = product {
                //use transaction details and purchased product as you want
                totalPoints = totalPoints + Int(self.pointsArr[indexNo])
                self.pointV.pointLbl.text = "\(totalPoints)"
                self.storeCV.reloadData()
                UserDefaults.standard.set(totalPoints, forKey: "points")
                
                //                let obj = ReceiptValidator()
                //                obj.verifyReceipt(tran)
                
            }
        }
        
        
    }
    
}



//Create class for Price display Cell
class PriceCVC: UICollectionViewCell {
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
}

//Points Available CollectionViewCell
class PointsCVC: UICollectionReusableView {
    @IBOutlet weak var stackV: UIStackView!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var contentView: UIView!
}

//extension to support specific corner rounded
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
