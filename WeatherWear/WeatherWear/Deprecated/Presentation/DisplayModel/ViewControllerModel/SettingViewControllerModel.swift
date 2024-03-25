//
//  SettingData.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/07.
//

import Foundation

struct SettingViewControllerModel: ViewControllerModel {
    var locations: [UserLocationDisplayModel]?
    var timeSchedule: String
    var totalTime: String
    
    var unitOptions: [OptionDisplayModel]
    var autoSortOptions: [OptionDisplayModel]
}

extension SettingViewControllerModel: Equatable { }
