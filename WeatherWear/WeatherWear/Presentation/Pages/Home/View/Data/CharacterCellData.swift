//
//  CharacterCellModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/12/27.
//

import Foundation

struct CharacterCellData {
    private let weather: Weather
    
    init(weather: Weather) {
        self.weather = weather
    }
}

extension CharacterCellData {
    var temperature: String? {
        weather.temperature.unitString
    }
    
    var highestTemperature: String? {
        weather.temperature.highestUnitString
    }
    
    var lowestTemperature: String? {
        weather.temperature.lowestUnitString
    }
    
    var backgroundImage: String {
        weather.weatherState.characterBackground
    }
    
    var weatherName: String {
        weather.weatherState.name
    }
    
    var weatherIcon: String {
        weather.symbolName
    }
    
    var location: String? {
        weather.location.descriptionString
    }
    
    var lastUpdateTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "마지막 업데이트 HH시"
        return formatter.string(from: weather.date)
    }
    
    var faceAdvice: AdviceViewModel {
        AdviceViewModel(adviceCase: .face,
                    title: "썬크림 필수",
                    description: "자외선 지수 최고 \(weather.uvIndex.todayHighestValue ?? 0)")
    }
    
    var clothesAdvice: AdviceViewModel {
        AdviceViewModel(adviceCase: .clothes,
                    title: "얇고 짧은 옷",
                    description: "기온이 아주 높아요.")
    }
    
    var itemAdvice: AdviceViewModel {
        AdviceViewModel(adviceCase: .item,
                    title: "우산 없음",
                    description: "강수확률이 없어요.")
    }
}

extension CharacterCellData {
    struct AdviceViewModel {
        var adviceCase: AdviceCase
        var title: String
        var description: String
        
        enum AdviceCase {
            case face
            case clothes
            case item
        }
    }
}
