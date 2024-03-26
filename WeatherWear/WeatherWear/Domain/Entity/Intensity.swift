//
//  Intensity.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/06.
//

import Foundation

enum Intensity {
    case extreme
    case high
    case medium
    case low
    case veryLow
    
    var state: String {
        switch self {
        case .extreme:
            return "매우 높음"
        case .high:
            return "높음"
        case .medium:
            return "보통"
        case .low:
            return "낮음"
        case .veryLow:
            return "매우 낮음"
        }
    }
    
    var color: AppColor {
        switch self {
        case .extreme:
            return AppColor.intensity(.intensity1)
        case .high:
            return AppColor.intensity(.intensity2)
        case .medium:
            return AppColor.intensity(.intensity3)
        case .low:
            return AppColor.intensity(.intensity4)
        case .veryLow:
            return AppColor.intensity(.intensity5)
        }
    }
}
