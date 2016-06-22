//
//  InputValidator.swift
//  UI
//
//  Created by LiChendi on 16/6/21.
//  Copyright © 2016年 LiChendi. All rights reserved.
//

import Foundation

class InputValidator {
    class func isValidEmail(email: String) -> Bool {
        let re = try? NSRegularExpression(pattern: "^\\S+@\\S+\\.\\S+$",
                                          options: .CaseInsensitive)
        
        if let re = re {
            let range = NSMakeRange(0, email.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            let result = re.matchesInString(email,
                                            options: NSMatchingOptions.ReportProgress,
                                            range: range)
            
            return result.count > 0
        }
        
        return false
    }
    
    class func isValidPassword(password: String) -> Bool {
        return password.characters.count >= 8
    }
    
    class func isValidDate(date: NSDate) -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let compare = calendar.compareDate(date, toDate: NSDate(), toUnitGranularity: .Day)
        
        return compare == .OrderedAscending
    }
}
