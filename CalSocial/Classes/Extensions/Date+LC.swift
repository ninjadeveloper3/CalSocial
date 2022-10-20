//
//  Date+LC.swift
//  Labour Choice Labour
//
//  Created by Usama on 27/09/2017.
//  Copyright © 2017 Usama. All rights reserved.
//

import Foundation

extension Date {

    var monthMedium: String  { return Formatter.monthMedium.string(from: self) }
    var hour12:  String      { return Formatter.hour12.string(from: self) }
    var minute0x: String     { return Formatter.minute0x.string(from: self) }
    var amPM: String         { return Formatter.amPM.string(from: self) }

    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }

    func toString() -> String {
        let chatDateFormatter = DateFormatter()
        chatDateFormatter.dateFormat = "yyyy-MM-dd" //2019-02-15
        return chatDateFormatter.string(from: self)
    }
    func timeFormatter() -> String {
        let chatDateFormatter = DateFormatter()
        chatDateFormatter.dateFormat = "HH:mm:ss" 
        return chatDateFormatter.string(from: self)
    }
    
    func toDateTimeFormat() -> String {
        let chatDateFormatter = DateFormatter()
        chatDateFormatter.dateFormat = "EE, MM dd HH:mma"
        return chatDateFormatter.string(from: self)
    }
    
    func convertDateFormat(date: String) -> String {
        let stringDateFormatter = DateFormatter()
        stringDateFormatter.dateFormat = "yyyy-MM-dd"
        let date = stringDateFormatter.date(from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd"
        let modifiedDate = dateFormatter.string(from: date ?? Date())
        return modifiedDate
    }
        
    func covertTimeFormat(time: String) -> String {
        let stringDateFormatter = DateFormatter()
        stringDateFormatter.dateFormat = "HH:mm:ss"
        let date = stringDateFormatter.date(from: time)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        let modifiedDate = dateFormatter.string(from: date ?? Date())
        return modifiedDate
    }
    
    func covertStringToDate(date: String) -> Date {
        let stringDateFormatter = DateFormatter()
        stringDateFormatter.dateFormat = "yyyy-MM-dd"
        let dateObj = stringDateFormatter.date(from: date)
        return dateObj ?? Date()
    
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
