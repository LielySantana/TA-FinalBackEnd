//
//  tryLater.swift
//  TikAnalyzer
//
//  Created by Christina Santana on 9/12/22.
//

import Foundation
import UIKit
 
extension UIViewController{
    
    func tryLateAlert() ->UIAlertController{
        let alert = UIAlertController(title: "Oops!", message: "Something went wrong, please try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
          }))
        self.present(alert, animated: true, completion: nil)
        return alert
        
    }
}
