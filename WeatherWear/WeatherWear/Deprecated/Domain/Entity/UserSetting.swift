//
//  UserSetting.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/02.
//

import Foundation

struct UserSetting {
    var locations: [LocationInformation]?
    var departureTime: Time?
    var arrivalTime: Time?
    var totalTime: Time?
    var temperatureUnit: TemperatureName
    var windSpeedUnit: WindSpeedUnit
    var todayBriefing: OperationMode
    var detail: OperationMode
}
