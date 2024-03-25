//
//  Temperature.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/22.
//

import Foundation

struct WeatherUnit {
    var type: WeatherUnitCase
    var intensity: Intensity?
    var value: Double?
    var unit: String?
    var todayHighestValue: Double?
    var todayLowestValue: Double?
    
    var todayHourlyValue: [Double]?
}

extension WeatherUnit {
    var unitString: String? {
        guard let value = value, var unit = unit else { return nil }
        if unit == "°C" { unit = "°" }
        return String(Int(value)) + unit
    }
    
    var highestUnitString: String? {
        guard let value = todayHighestValue, var unit = unit else { return nil }
        if unit == "°C" { unit = "°" }
        return String(Int(value)) + unit + "↗"
    }
    
    var lowestUnitString: String? {
        guard let value = todayLowestValue, var unit = unit else { return nil }
        if unit == "°C" { unit = "°" }
        return String(Int(value)) + unit + "↘"
    }
    
    
}

