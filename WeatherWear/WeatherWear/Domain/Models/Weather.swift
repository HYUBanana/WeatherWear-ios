//
//  Weather.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/12.
//

import UIKit

struct Weather {
    var date: Date
    var location: String
    var temperature: Int
    var highestTemperature: Int
    var lowestTemperature: Int
    
    var weatherCondition: WeatherCondition
    
    //The feels-like temperature when factoring wind and humidity.
    var apparentTemperature: Int
    //The level of ultraviolet radiation.
    var uvIndex: Int
    var fineDust: Int
    var ultrafineDust: Int
    var wind: Int
    
    var comfort: Int
    var laundry: Int
    var carWash: Int
    var pollen: Int
    
    //A Boolean value indicating whether there is daylight.
    var isDaylight: Bool
}
