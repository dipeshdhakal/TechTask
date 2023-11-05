//
//  Date+Format.swift
//  EntainTask
//
//  Created by Dipesh Dhakal on 31/10/2023.
//

import Foundation

extension Calendar {
    static var currentCalendar: Calendar {
        var utcCalendar = Calendar.current
        utcCalendar.timeZone = .autoupdatingCurrent
        return utcCalendar
    }
}

extension Date {
    func withAddingValue(_ value: Int, to component: Calendar.Component) -> Date? {
        var components = DateComponents()
        components.setValue(value, for: component)
        return Calendar.currentCalendar.date(byAdding: components, to: self)
    }
}

extension TimeInterval {
    
    var formattedCountDownTime: String {
        let time = NSInteger(self)

        let hours = (time / 60 / 60) % 60
        var minutes = (time / 60) % 60
        var seconds = time % 60
        
        
        if minutes < 0 {
            seconds = seconds > 0 ? seconds : seconds * -1 // removing negative sign from second component if already in minute component
        }
        
        if hours < 0 {
            minutes = minutes > 0 ? minutes : minutes * -1 // removing negative sign from minute component if already in hour component
        }

        guard hours < 2 else {
            return String(format: "%0.1dh", hours)
        }

        guard hours == 0 else {
            return String(format: "%0.1dh %0.1dm", hours, minutes)
        }
        
        guard minutes < 5 else {
            return String(format: "%0.1dm", minutes)
        }

        guard minutes == 0 else {

            if seconds == 0 {
                return String(format: "%0.1dm", minutes)
            }

            return String(format: "%0.1dm %0.1ds", minutes, seconds)
        }

        return String(format: "%0.1ds", seconds)
    }
    
    var minuteSecond: String {
        return String(format:"%02d:%02d", minute, second)
    }
    
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    
    var nanoseconds: UInt64 {
        return UInt64(second) * UInt64(1_000_000_000)
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
