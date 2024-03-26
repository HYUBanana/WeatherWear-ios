//
//  ClimateFactorDisplayModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/19.
//

import Foundation

struct ClimateFactorDisplayModel {
    var intensity: IntensityModel
    var icon: String
    var name: String
    var value: Int
    var highestValue: Int
    var lowestValue: Int
    var description: String
}
