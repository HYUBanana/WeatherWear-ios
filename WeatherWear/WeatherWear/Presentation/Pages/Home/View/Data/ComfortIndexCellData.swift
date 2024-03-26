//
//  ComfortIndexModel.swift
//  WeatherWear
//
//  Created by 디해 on 2024/01/04.
//

import Foundation

struct ComfortIndexCellData {
    private let unit: WeatherUnit
    
    init(unit: WeatherUnit) {
        self.unit = unit
    }
}

extension ComfortIndexCellData {
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
}
