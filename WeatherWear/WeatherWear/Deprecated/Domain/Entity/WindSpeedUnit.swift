//
//  WindSpeedUnit.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/02.
//

import Foundation

enum WindSpeedUnit: String, OptionEnumCollection {
    case metersPerSecond = "m/s"
    case kilometersPerHour = "km/h"
    case milesPerHour = "mph"
    case unknown = "ERROR"
}
