//
//  Diary+CoreDataProperties.swift
//  DiaryApp
//
//  Created by Dhara Patel on 08/12/20.
//  Copyright © 2020 Dhara Patel. All rights reserved.
//
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var date: String?

}
