//
//  UserLocation.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/23.
//

import UIKit

struct UserLocation: Identifiable {
    var id: String = UUID().uuidString
    var location: String
    var time: String
    var temperature: Int
    var weather: String
    var isSelected: Bool
}
