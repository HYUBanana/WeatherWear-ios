//
//  Weather.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/12.
//

import Foundation.NSDate
import CoreLocation

struct Weather {
    var date: Date
    var weatherSummary: String
    var weatherState: WeatherState
    var symbolName: String
    var location: Location
    
    var temperature: WeatherUnit
    var apparentTemperature: WeatherUnit
    var uvIndex: WeatherUnit
    var fineDust: WeatherUnit
    var ultrafineDust: WeatherUnit
    var wind: WeatherUnit
    var cloudCover: WeatherUnit
    var precipitationChance: WeatherUnit
    var precipitationAmount: WeatherUnit
    var humidity: WeatherUnit
    
    var comfort: WeatherUnit
    var laundry: WeatherUnit
    var carWash: WeatherUnit
    var pollen: WeatherUnit
}
