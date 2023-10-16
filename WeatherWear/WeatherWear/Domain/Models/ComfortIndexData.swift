//
//  ComfortIndexData.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/13.
//

import UIKit

struct ComfortIndexData {
    var icon: String
    var title: String
    var value: Int
    var state: String
    var color: UIColor
    
    var valueTitle: String {
        return title + " " + String(value)
    }
}
