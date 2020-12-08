//
//  UiViewControllerExtension.swift
//  DiaryApp
//
//  Created by Dhara Patel on 08/12/20.
//  Copyright © 2020 Dhara Patel. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func instantiate(from appStoryboard: DGStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}

