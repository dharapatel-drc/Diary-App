//
//  AppConstant.swift
//  DiaryApp
//
//  Created by Dhara Patel on 08/12/20.
//  Copyright © 2020 Dhara Patel. All rights reserved.
//

import Foundation
import UIKit

enum Constant {
    static let entityName = "Diary"
    static let appName = "Diary App"
    static let networkError = "Networn error"
}

enum CellIdentifier {
    static let diaryListTableViewCell = "DiaryListTableViewCell"
}

enum StoryBoardId {
    static let EditDiaryViewController = "EditDiaryViewController"
}

enum DGStoryboard: String {
    
    case Main
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardId = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardId) as! T
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

enum UserMessage {
    static let emptyTitle = "Please enter title"
    static let emptyContent = "Please enter content"
    static let deleteDiary = "Are you sure you want to delete this diary?"
    static let NoInternet = "Unable to contact the server"
}

enum DateFormat: String {
    case yyyy_MM_dd = "yyyy-MM-dd"
    case backEndDate = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
}
