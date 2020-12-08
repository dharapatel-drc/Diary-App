//
//  Diary+CoreDataClass.swift
//  DiaryApp
//
//  Created by Dhara Patel on 08/12/20.
//  Copyright © 2020 Dhara Patel. All rights reserved.
//
//

import Foundation
import CoreData


public class Diary: NSManagedObject {

}

class DiaryDetail {
    
    var date: String?
    var diary: [Diary]?
    
     init() { }
}

