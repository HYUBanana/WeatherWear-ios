//
//  UserLocation.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/07.
//

import Foundation

struct UserLocationDisplayModel {
    var location: String
    var time: String
    var temperature: String
    var weather: String
}

extension UserLocationDisplayModel: Equatable { }
