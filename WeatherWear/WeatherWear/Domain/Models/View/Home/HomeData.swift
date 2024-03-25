//
//  HomeData.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/05.
//

import Foundation

struct HomeData {
    
    var randomTitle: String
    var weatherSummary: String
    
    var simpleWeather: String
    var simpleIcon: String
    var date: String
    var location: String
    var updateTime: String
    
    var temperature: String
    var highestTemperature: String
    var lowestTemperature: String
    
    var faceAdvice: Advice
    var clothesAdvice: Advice
    var itemAdvice: Advice
    
    var climateFactor: [ClimateFactor]
    var livingIndex: [LivingIndex]
}
