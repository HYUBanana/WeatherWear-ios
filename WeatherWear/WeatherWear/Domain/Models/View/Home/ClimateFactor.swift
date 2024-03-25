//
//  ClimateFactor.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/06.
//

import Foundation

struct ClimateFactor {
    var type: ClimateFactorType
    
    var intensity: Intensity
    var value: Int
    var highestValue: Int
    var lowestValue: Int
    var description: String
    var icon: String { type.icon }
    var name: String { type.name }
    
    enum ClimateFactorType {
        case apparentTemperature
        case uvIndex
        case fineDust
        case wind
        case rainfall
        
        var icon: String {
            switch self {
            case .apparentTemperature:
                return "🌡️"
            case .uvIndex:
                return "😎"
            case .fineDust:
                return "😮‍💨"
            case .wind:
                return "💨"
            case .rainfall:
                return "💧"
            }
        }
        
        var name: String {
            switch self {
            case .apparentTemperature:
                return "체감 기온"
            case .uvIndex:
                return "자외선"
            case .fineDust:
                return "대기질"
            case .wind:
                return "바람"
            case .rainfall:
                return "강수량"
            }
        }
    }
}
