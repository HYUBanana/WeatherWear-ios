//
//  LivingIndex.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/06.
//

import Foundation

struct LivingIndex {
    var type: LivingIndexType
    
    var intensity: Intensity
    var value: Int
    var icon: String { type.icon }
    var name: String { type.name }
    
    enum LivingIndexType {
        case comfort
        case laundry
        case carWash
        case pollen
        
        var icon: String {
            switch self {
            case .comfort:
                return "😆"
            case .laundry:
                return "🧺"
            case .carWash:
                return "🚗"
            case .pollen:
                return "🌷"
            }
        }
        
        var name: String {
            switch self {
            case .comfort:
                return "상쾌 지수"
            case .laundry:
                return "빨래 지수"
            case .carWash:
                return "세차 지수"
            case .pollen:
                return "꽃가루 지수"
            }
        }
    }
}
