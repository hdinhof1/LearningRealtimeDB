//
//  TimeStamp.swift
//  LearningRealtimeDB
//
//  Created by Henry Dinhofer on 3/12/17.
//  Copyright © 2017 Henry Dinhofer. All rights reserved.
//

import Foundation

class TimeStamp {
    
    let user : String
    let timestamp : NSNumber
    
    init(dictionary dict : NSDictionary) {
        
        self.user = dict["user"] as? String             ?? "blah"
        self.timestamp = dict["timestamp"] as? NSNumber ?? NSNumber(value: 101)
        
    }
    
    func toDate() -> Date {
        let timedbl = self.timestamp.doubleValue
        return Date(timeIntervalSince1970: timedbl)
    }
    
    /// Returns string representing time stamp
    ///
    /// - Returns: String e.g. "March 12,  4:17:02 PM"
    func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d,  h:mm:ss a"
        let dateString = formatter.string(from: self.toDate())
        
        
        return dateString
        // March 12,  4:17 PM
        
    }
}
