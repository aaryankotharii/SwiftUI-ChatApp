//
//  Extensions.swift
//  ChatApp
//
//  Created by Aaryan Kothari on 04/06/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation


extension Int {
    var timeStringConverter : String{
        
        let timestampDate = NSDate(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let time = dateFormatter.string(from: timestampDate as Date)
        
        return time
    }
}
