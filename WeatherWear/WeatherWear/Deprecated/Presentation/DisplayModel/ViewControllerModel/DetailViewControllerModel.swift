//
//  DetailData.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/08.
//

import Foundation

struct DetailViewControllerModel: ViewControllerModel {

    var timeLocation: String
    var updateTime: String
    
    var temperature: String
    var highestTemperature: String
    var lowestTemperature: String
    
    var apparentTemperatureDescription: String
    
    var graph: WeatherGraphDisplayModel
    
}
