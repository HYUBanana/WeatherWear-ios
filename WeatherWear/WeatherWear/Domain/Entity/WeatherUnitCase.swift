//
//  WeatherUnit.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/22.
//

enum WeatherUnitCase {
    case temperature
    case apparentTemperature
    case uvIndex
    case fineDust
    case ultraFinedust
    case wind
    case rainfall
    case cloudCover
    case precipitationChance
    case humidity
    case comfort
    case laundry
    case carWash
    case pollen
}

extension WeatherUnitCase {
    var title: String? {
        switch self {
        case .apparentTemperature:
            return "체감 기온"
        case .uvIndex:
            return "자외선"
        case .humidity:
            return "습도"
        case .fineDust:
            return "대기질"
        case .wind:
            return "바람"
        case .rainfall:
            return "강수량"
        case .comfort:
            return "상쾌 지수"
        case .laundry:
            return "빨래 지수"
        case .carWash:
            return "세차 지수"
        case .pollen:
            return "꽃가루 지수"
        default:
            return nil
        }
    }
    
    var icon: String? {
        switch self {
        case .apparentTemperature:
            return "🌡️"
        case .uvIndex:
            return "😎"
        case .humidity:
            return "💧"
        case .fineDust:
            return "😮‍💨"
        case .wind:
            return "💨"
        case .rainfall:
            return "☔️"
        case .comfort:
            return "😆"
        case .laundry:
            return "🧺"
        case .carWash:
            return "🚗"
        case .pollen:
            return "🌷"
        default:
            return nil
        }
    }
}
