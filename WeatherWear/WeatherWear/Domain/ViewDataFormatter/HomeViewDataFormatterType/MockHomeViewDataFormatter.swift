//
//  MockHomeViewDataFormatter.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/06.
//

import Foundation

class MockHomeViewDataFormatter: HomeViewDataFormatterType {
    func transform(_ weather: Weather) -> HomeData {
        
        HomeData(randomTitle: getRandomTitle(with: weather.weatherCondition),
                 weatherSummary: getWeatherSummary(with: weather),
                 simpleWeather: weather.weatherCondition.state,
                 simpleIcon: weather.weatherCondition.image,
                 date: dateToString(with: weather.date),
                 location: weather.location,
                 updateTime: dateToString(with: Date.now),
                 temperature: String(weather.temperature),
                 highestTemperature: String(weather.highestTemperature),
                 lowestTemperature: String(weather.lowestTemperature),
                 faceAdvice: makeAdvice(with: weather, type: .face),
                 clothesAdvice: makeAdvice(with: weather, type: .clothes),
                 itemAdvice: makeAdvice(with: weather, type: .item),
                 climateFactor: makeClimateFactor(with: weather),
                 livingIndex: makeLivingIndex(with: weather))
    }
    
    private func makeAdvice(with weather: Weather, type: AdviceCategory) -> Advice {
        switch type {
        case .face:
            return Advice(title: "썬크림 필수",
                          description: "자외선 지수 최고 8.")
        case .clothes:
            return Advice(title: "얇고 짧은 옷",
                          description: "기온이 아주 높아요.")
        case .item:
            return Advice(title: "우산 없음",
                          description: "강수확률이 없어요.")
        }
    }
    
    private func makeClimateFactor(with weather: Weather) -> [ClimateFactor] {
        let apparentTemperatureFactor = ClimateFactor(type: .apparentTemperature,
                                                      intensity: .extreme,
                                                      value: 34,
                                                      highestValue: 34,
                                                      lowestValue: 20,
                                                      description: "체감 기온 최대 34도.\n어제보다 2도 높아요.")
        let uvIndexFactor = ClimateFactor(type: .uvIndex,
                                          intensity: .high,
                                          value: 25,
                                          highestValue: 28,
                                          lowestValue: 20,
                                          description: "자외선이 09시 ~ 17시에\n중간 이상으로 강해요.")
        let fineDustFactor = ClimateFactor(type: .fineDust,
                                           intensity: .medium,
                                           value: 20,
                                           highestValue: 24,
                                           lowestValue: 2,
                                           description: "미세먼지는 중간 정도,\n초미세먼지는 적어요.")
        let windFactor = ClimateFactor(type: .wind,
                                       intensity: .low,
                                       value: 10,
                                       highestValue: 13,
                                       lowestValue: 0,
                                       description: "최대 풍속 2m/s 정도로,\n약한 편이에요.")
        let rainfallFactor = ClimateFactor(type: .rainfall,
                                           intensity: .veryLow,
                                           value: 0,
                                           highestValue: 0,
                                           lowestValue: -4,
                                           description: "오늘은 비가 내리지 않아요.\n우산이 없어도 괜찮아요.")
        return [apparentTemperatureFactor, uvIndexFactor, fineDustFactor, windFactor, rainfallFactor]
    }
    
    private func makeLivingIndex(with weather: Weather) -> [LivingIndex] {
        let comfortIndex = LivingIndex(type: .comfort,
                                       intensity: .low,
                                       value: 6)
        let laundryIndex = LivingIndex(type: .laundry,
                                       intensity: .medium,
                                       value: 12)
        let carWashIndex = LivingIndex(type: .carWash,
                                       intensity: .high,
                                       value: 25)
        let pollenIndex = LivingIndex(type: .pollen,
                                      intensity: .extreme,
                                      value: 45)
        return [comfortIndex, laundryIndex, carWashIndex, pollenIndex]
    }
}

extension MockHomeViewDataFormatter {
    
    func dateToString(with date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
    
    func getRandomTitle(with condition: WeatherCondition) -> String {
        return condition.randomTitles()
    }
    
    func getWeatherSummary(with weather: Weather) -> String {
        return "오늘은 어제보다 더 덥고 습해서,\n실외활동은 자제하는 게 좋겠어요.\n다행히 비 소식은 없어요."
    }
}
