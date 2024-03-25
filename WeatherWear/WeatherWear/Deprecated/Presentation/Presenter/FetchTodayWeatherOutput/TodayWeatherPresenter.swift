//
//  WeatherPresenter.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/19.
//

import Foundation
import RxSwift
import CoreLocation

class TodayWeatherPresenter: FetchTodayWeatherOutputPort {
    
    func create(with weather: Weather) -> Result<ViewControllerModel, Error> {
        
        let randomTitle = getRandomTitle(with: weather)
        let weatherSummary = getWeatherSummary(with: weather)
        let weatherState = getWeatherState(with: weather)
        let iconName = weather.symbolName
        let location = getLocationString(weather.location)
        guard let updateTime = getUpdateTime(with: weather.date, timeZone: weather.location.timezone)
        else { return .failure(ErrorType.noTimeZone)}
        
        guard let date = getLocaleTime(with: weather.date, timeZone: weather.location.timezone)
        else { return .failure(ErrorType.noTimeZone) }
        
        guard let temperature = unitToString(weather.temperature),
              let highTemperature = getHighestUnitString(weather.temperature),
              let lowTemperature = getLowestUnitString(weather.temperature),
              let highestApparentTemperature = getHighestUnitString(weather.apparentTemperature),
              let highestWind = getHighestUnitString(weather.wind)
        else { return .failure(ErrorType.noValue) }
        
        guard let faceAdvice = makeFaceAdvice(with: weather),
              let clothesAdvice = makeClothesAdvice(with: weather),
              let itemAdvice = makeItemAdvice(with: weather)
        else { return .failure(ErrorType.noValue) }
        
        let climateFactors = [makeClimateFactor(with: weather.apparentTemperature),
                              makeClimateFactor(with: weather.uvIndex),
                              makeClimateFactor(with: weather.fineDust),
                              makeClimateFactor(with: weather.wind),
                              makeClimateFactor(with: weather.precipitationAmount)]
        guard climateFactors.allSatisfy({ $0 != nil }) else {
            return .failure(ErrorType.noValue)
        }
        let unwrappedClimateFactors = climateFactors.compactMap { $0 }
        
        let livingIndeices = [makeLivingIndex(with: weather.comfort),
                              makeLivingIndex(with: weather.laundry),
                              makeLivingIndex(with: weather.carWash),
                              makeLivingIndex(with: weather.pollen)]
        guard livingIndeices.allSatisfy({ $0 != nil }) else {
            return .failure(ErrorType.noValue)
        }
        let unwrappedLivingIndices = livingIndeices.compactMap { $0 }
        
        let weatherDisplayModel = HomeViewControllerModel(randomTitle: randomTitle,
                                                   weatherSummary: weatherSummary,
                                                   simpleWeather: weatherState,
                                                   iconName: iconName,
                                                   date: date,
                                                   location: location,
                                                   updateTime: updateTime,
                                                   temperature: temperature,
                                                   highestTemperature: highTemperature,
                                                   lowestTemperature: lowTemperature,
                                                   highestApparentTemperature: highestApparentTemperature,
                                                   highestWind: highestWind,
                                                   faceAdvice: faceAdvice,
                                                   clothesAdvice: clothesAdvice,
                                                   itemAdvice: itemAdvice,
                                                   climateFactor: unwrappedClimateFactors,
                                                   livingIndex: unwrappedLivingIndices)
        
        return .success(weatherDisplayModel)
    }
}

extension TodayWeatherPresenter {
    private func getLocationString(_ location: Location) -> String {
        guard let locality = location.locality else { return "" }
        guard let subLocality = location.subLocality else { return locality }
        return locality + " " + subLocality
    }
    
    private func getRandomTitle(with weather: Weather) -> String {
        let state = weather.weatherState
        
        switch state {
        case .clear:
            let titles = [
                "그래,\n이게 날씨지. 😆",
                "놀러가기\n딱 좋은 날씨. 🏕️",
                "오늘은 정말\n땡땡이 각인걸. 🤪"
            ]
            return titles.randomElement()!
            
        case .cloudy:
            let titles = [
                "구름이\n몽실몽실. ☁️"
            ]
            return titles.randomElement()!
            
        case .rain:
            let titles = [
                "하늘에 구멍이\n뚫렸나 봐. 🕳️",
                "오늘같은 날엔\n개발자도 재택. 🏠"
            ]
            return titles.randomElement()!
            
        case .unknown:
            let titles = [
                "미정입니다."
            ]
            return titles.randomElement()!
        }
    }
    
    private func getWeatherSummary(with weather: Weather) -> String {
        return "오늘은 어제보다 더 덥고 습해서,\n실외활동은 자제하는 게 좋겠어요.\n다행히 비 소식은 없어요."
    }
    
    private func getWeatherState(with weather: Weather) -> String {
        let state = weather.weatherState
        
        switch state {
        case .clear:
            return "맑음"
        case .cloudy:
            return "구름 조금"
        case .rain:
            return "비"
        case .unknown:
            return "미정"
        }
    }
    
    private func getLocaleTime(with date: Date, timeZone: TimeZone?) -> String? {
        guard let timeZone = timeZone else { return nil }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = timeZone
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
    
    private func getUpdateTime(with date: Date, timeZone: TimeZone?) -> String? {
        guard let timeZone = timeZone else { return nil }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        formatter.timeZone = timeZone
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
    
    private func unitToString(_ unit: WeatherUnit) -> String? {
        guard let value = unit.value, var unit = unit.unit else { return nil }
        if unit == "°C" { unit = "°" }
        return String(Int(value)) + unit
    }
    
    private func getHighestUnitString(_ unit: WeatherUnit) -> String? {
        guard let value = unit.todayHighestValue, var unit = unit.unit else { return nil }
        if unit == "°C" { unit = "°" }
        return String(Int(value)) + unit + "↗"
    }
    
    private func getLowestUnitString(_ unit: WeatherUnit) -> String? {
        guard let value = unit.todayLowestValue, var unit = unit.unit else { return nil }
        if unit == "°C" { unit = "°" }
        return String(Int(value)) + unit + "↘"
    }
    
    private func makeFaceAdvice(with weather: Weather) -> AdviceDisplayModel? {
        guard let maxUVIndex = weather.uvIndex.todayHighestValue.flatMap({ Int($0) }) else { return nil }
        return AdviceDisplayModel(title: "썬크림 필수",
                                  description: "자외선 지수 최고 \(maxUVIndex).")
    }
    
    private func makeClothesAdvice(with weather: Weather) -> AdviceDisplayModel? {
        return AdviceDisplayModel(title: "얇고 짧은 옷",
                                  description: "기온이 아주 높아요.")
    }
    
    private func makeItemAdvice(with weather: Weather) -> AdviceDisplayModel? {
        return AdviceDisplayModel(title: "우산 없음",
                                  description: "강수확률이 없어요.")
    }
    
    private func makeClimateFactor(with unit: WeatherUnit) -> ClimateFactorDisplayModel? {
        guard let intensity = getIntensityOfUnit(with: unit),
              let icon = getIconOfUnit(with: unit),
              let name = getNameOfUnit(with: unit),
              let value = unit.value.flatMap({ Int($0) }),
              let highestValue = unit.todayHighestValue.flatMap({ Int($0) }),
              let lowestValue = unit.todayLowestValue.flatMap({ Int($0 )}),
              let description = getDescriptionOfUnit(with: unit)
        else { return nil }
        
        let climateFactor = ClimateFactorDisplayModel(intensity: intensity,
                                                      icon: icon,
                                                      name: name,
                                                      value: value,
                                                      highestValue: highestValue,
                                                      lowestValue: lowestValue,
                                                      description: description)
        return climateFactor
    }
    
    private func makeLivingIndex(with unit: WeatherUnit) -> LivingIndexDisplayModel? {
        guard let intensity = getIntensityOfUnit(with: unit),
              let icon = getIconOfUnit(with: unit),
              let name = getNameOfUnit(with: unit),
              let value = unit.value.flatMap({ Int($0) })
        else { return nil }
        
        let livingIndex = LivingIndexDisplayModel(intensity: intensity,
                                                  icon: icon,
                                                  name: name,
                                                  value: value)
        return livingIndex
    }
}

extension TodayWeatherPresenter {
    private func getIntensityOfUnit(with unit: WeatherUnit) -> IntensityModel? {
        guard let value = unit.value else { return nil }
        if value < 0 {
            return .veryLow
        }
        else if value < 10 {
            return .low
        }
        else if value < 20 {
            return .medium
        }
        else if value < 30 {
            return .high
        }
        else {
            return .extreme
        }
    }
    
    private func getIconOfUnit(with unit: WeatherUnit) -> String? {
        switch unit.type {
        case .apparentTemperature:
            return "🌡️"
        case .uvIndex:
            return "😎"
        case .fineDust:
            return "😮‍💨"
        case .wind:
            return "💨"
        case .rainfall:
            return "💧"
        case .comfort:
            return "😆"
        case .laundry:
            return "🧺"
        case .carWash:
            return "🚗"
        case .pollen:
            return "🌷"
        default:
            return nil
        }
    }
    
    private func getNameOfUnit(with unit: WeatherUnit) -> String? {
        switch unit.type {
        case .apparentTemperature:
            return "체감 기온"
        case .uvIndex:
            return "자외선"
        case .fineDust:
            return "대기질"
        case .wind:
            return "바람"
        case .rainfall:
            return "강수량"
        case .comfort:
            return "상쾌 지수"
        case .laundry:
            return "빨래 지수"
        case .carWash:
            return "세차 지수"
        case .pollen:
            return "꽃가루 지수"
        default:
            return nil
        }
    }
    
    private func getDescriptionOfUnit(with unit: WeatherUnit) -> String? {
        return "설명해줘어어어어어어"
    }
}
