//
//  BriefingModel.swift
//  WeatherWear
//
//  Created by 디해 on 2024/01/03.
//

import Foundation

struct BriefingCellData {
    private let unit: WeatherUnit
    
    init(unit: WeatherUnit) {
        self.unit = unit
    }
}

extension BriefingCellData {
    var graphType: GraphType {
        switch unit.type {
        case .apparentTemperature:
            return .apparentTemperature
        case .uvIndex:
            return .uvIndex
        case .humidity:
            return .humidity
        case .fineDust:
            return .fineDust
        case .wind:
            return .wind
        case .rainfall:
            return .rainfall
        default:
            return .unknown
        }
    }
    
    var intensity: Intensity? {
        unit.intensity
    }
    
    var icon: String? {
        unit.type.icon
    }
    
    var name: String? {
        unit.type.title
    }
    
    var value: Int? {
        guard let value = unit.value else { return nil }
        return Int(value)
    }
    
    var highestValue: Int? {
        guard let highestValue = unit.todayHighestValue else { return nil }
        return Int(highestValue)
    }
    
    var lowestValue: Int? {
        guard let lowestValue = unit.todayLowestValue else { return nil }
        return Int(lowestValue)
    }
    
    var description: String? {
        return "설명설명설명"
    }
}
