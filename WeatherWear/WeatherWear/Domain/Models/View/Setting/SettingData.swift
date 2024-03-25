//
//  SettingData.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/07.
//

import Foundation

struct SettingData {
    var locations: [UserLocation]
    var timeSchedule: String
    var totalTime: String
    
    var temperatureUnit: [String]
    var selectedTemperatureUnit: String
    
    var windSpeedUnit: [String]
    var selectedWindSpeedUnit: String
    
    var todayBriefing: [String]
    var selectedTodayBriefing: String
    
    var detail: [String]
    var selectedDetail: String
}

extension SettingData: Equatable { }

