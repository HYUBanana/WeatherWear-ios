//
//  Option.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/21.
//

import Foundation

struct OptionDisplayModel {
    var optionName: String
    var optionCases: [String]
    var selectedOption: Int
}

extension OptionDisplayModel: Equatable { }
