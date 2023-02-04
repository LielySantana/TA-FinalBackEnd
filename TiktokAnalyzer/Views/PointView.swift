//
//  PointView.swift
//  TiktokAnalyzer
//
//  Created by krunal on 29/11/22.
//

import UIKit

class PointView: UIView {
    
    @IBOutlet weak var pointLbl: UILabel!
    @IBOutlet weak var pointBgView: UIView!
    @IBOutlet var contentView: PointView!
    @IBOutlet weak var titleLbl: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "PointView", bundle: Bundle.main)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        self.layer.cornerRadius = 10
        pointBgView.backgroundColor = UIColor.clear
        pointBgView.layer.borderWidth = 1.0
        pointBgView.layer.cornerRadius = 5.0
        pointBgView.layer.borderColor = UIColor.white.cgColor
        
        //        self.clipsToBounds = true
        contentView.layer.masksToBounds = true
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        pointLbl.text = "\(totalPoints)"
        addSubview(contentView)
        
    }
}
