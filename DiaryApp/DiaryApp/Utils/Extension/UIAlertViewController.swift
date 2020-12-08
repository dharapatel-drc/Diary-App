//
//  UIAlertViewController.swift
//  DiaryApp
//
//  Created by Dhara Patel on 08/12/20.
//  Copyright © 2020 Dhara Patel. All rights reserved.
//

import Foundation
import UIKit
typealias ClosureType = () -> ()

extension UIAlertController{
    
    class func showAlert(_ viewController:UIViewController, message:String, title: String = Constant.appName, clickAction:ClosureType? = nil ){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.message = message
        alertView.title = title
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            clickAction?()
        }))
        viewController.present(alertView, animated: true, completion: nil)
    }
    
    class func showAlertWithMultipleOption(_ viewController:UIViewController, message:String, title:String = Constant.appName,okTitle:String = "", clickAction:ClosureType? = nil, cancelAction:ClosureType? = nil) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.message = message
        alertView.title = title
        alertView.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
            clickAction?()
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            cancelAction?()
        }))
        viewController.present(alertView, animated: true, completion: nil)
    }
}
