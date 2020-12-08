//
//  SwiftExtension.swift
//  DiaryApp
//
//  Created by Dhara Patel on 08/12/20.
//  Copyright © 2020 Dhara Patel. All rights reserved.
//

import Foundation

extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func toDate(format: DateFormat = .backEndDate) -> Date? {
              let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = DateFormat.backEndDate.rawValue
                  if let formattedDate = dateFormatter.date(from: self) {
                      return formattedDate
                  }
              return dateFormatter.date(from: self)
          }
}

extension Date {
     func toString(formateType type: DateFormat) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = type.rawValue
           return dateFormatter.string(from: self)
       }
    
    var chatHeaderDisplayDate: String {
           let calendar = Calendar.current
           if calendar.isDateInToday(self) {
               //            return "\(self.toString(formateType: .hh_mm_a))"
               return "Today"
           } else if calendar.isDateInYesterday(self) {
               return "Yesterday"
           } else {
            return self.toString(formateType: DateFormat.yyyy_MM_dd)
           }
       }
       
}
