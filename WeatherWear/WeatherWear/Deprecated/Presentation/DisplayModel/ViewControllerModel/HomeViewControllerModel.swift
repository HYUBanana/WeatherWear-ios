//
//  HomeData.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/05.
//

import Foundation

struct HomeViewControllerModel: ViewControllerModel {
    
    var randomTitle: String
    var weatherSummary: String
    
    var simpleWeather: String
    var iconName: String
    var date: String
    var location: String
    var updateTime: String
    
    var temperature: String
    var highestTemperature: String
    var lowestTemperature: String
    var highestApparentTemperature: String
    var highestWind: String
    
    var faceAdvice: AdviceDisplayModel
    var clothesAdvice: AdviceDisplayModel
    var itemAdvice: AdviceDisplayModel
    
    var climateFactor: [ClimateFactorDisplayModel]
    var livingIndex: [LivingIndexDisplayModel]
}
