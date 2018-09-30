//
//  Utils.swift
//  HackerNewsApp
//
//  Created by Nishu Priya on 9/30/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import Foundation
struct Utils {
    static func timeFromUnix(time: Int) -> Date {
        let date = Date(timeIntervalSince1970: TimeInterval(time))
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
//        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
////        dateFormatter.timeZone = self.timeZone
//        let localDate = dateFormatter.string(from: date)
        return date
    }
    
    static func offsetFrom(_ date: Date) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date)) years ago"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date)) months ago"  }
        if daysFrom(date)    > 0 { return "\(daysFrom(date)) days ago"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date)) hrs ago"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date)) mins ago" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date)) secs ago" }
        return "now"
    }
    
    internal static func yearsFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.year, from: date, to: Date(), options: []).year!
    }
    
    internal static func monthsFrom(_ date: Date, toDate: Date = Date()) -> Int {
        return (Calendar.current as NSCalendar).components(.month, from: date, to: toDate, options: []).month!
    }
    
    internal static func daysFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.day, from: date, to: Date(), options: []).day!
    }
    
    internal static func hoursFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: Date(), options: []).hour!
    }
    
    internal static func minutesFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: Date(), options: []).minute!
    }
    
    internal static func secondsFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.second, from: date, to: Date(), options: []).second!
    }
}
