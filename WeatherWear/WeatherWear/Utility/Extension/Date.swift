//
//  Date.swift
//  WeatherWear
//
//  Created by 디해 on 2024/01/03.
//

import Foundation

extension Date {
    func getHour() -> Int {
        let calendar = Calendar.current
        return calendar.component(.hour, from: self)
    }
    
    func getMinute() -> Int {
        let calendar = Calendar.current
        return calendar.component(.minute, from: self)
    }
    
    func toMonthDayWeekdayString(timeZone: TimeZone?) -> String? {
        guard let timeZone = timeZone else { return nil }
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "MM월 dd일 EEEE"
        return formatter.string(from: self)
    }
    
    func toHourMinuteString(timeZone: TimeZone?) -> String? {
        guard let timeZone = timeZone else { return nil }
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "HH시 mm분"
        return formatter.string(from: self)
    }
    
    func toHourMinute24HString(timeZone: TimeZone?) -> String? {
        guard let timeZone = timeZone else { return nil }
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
