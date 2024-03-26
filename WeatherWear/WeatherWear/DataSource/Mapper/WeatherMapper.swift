//
//  WeatherMapper.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/19.
//

import Foundation
import CoreLocation
import WeatherKit

class WeatherMapper {
    func map(placemark: CLPlacemark, current: CurrentWeather, daily: Forecast<DayWeather>, hourly: Forecast<HourWeather>) -> Weather {
        
        let dayWeather = daily.forecast[0]
        let hourWeathers = hourly.forecast
        
        let weatherSummary = getWeatherSummary(current: current, daily: dayWeather, hourly: hourWeathers)
        
        let temperature = getUnitWithMeasurement(current: current.temperature,
                                                 hourly: hourWeathers.map { $0.temperature },
                                                 type: .temperature)
        
        let apparentTemperature = getUnitWithMeasurement(current: current.apparentTemperature,
                                                         hourly: hourWeathers.map { $0.apparentTemperature },
                                                         type: .apparentTemperature)
        
        let uvIndex = getUnitWithDouble(current: Double(current.uvIndex.value),
                                        hourly: hourWeathers.map { Double($0.uvIndex.value) },
                                        unit: nil,
                                        type: .uvIndex)
        
        let fineDust = getUnitWithDouble(current: 5,
                                         hourly: [1, 7],
                                         unit: nil,
                                         type: .fineDust)
        
        let ultrafineDust = getUnitWithDouble(current: 5,
                                              hourly: [1, 7],
                                              unit: nil,
                                              type: .ultraFinedust)
        
        let wind = getUnitWithMeasurement(current: current.wind.speed,
                                          hourly: hourWeathers.map { $0.wind.speed },
                                          type: .wind)
        
        let cloudCover = getUnitWithDouble(current: current.cloudCover * 100,
                                           hourly: hourWeathers.map { $0.cloudCover * 100 },
                                           unit: "%",
                                           type: .cloudCover)
        
        let precipitationChance = getUnitWithDouble(current: dayWeather.precipitationChance * 100,
                                                    hourly: hourWeathers.map { $0.precipitationChance * 100 },
                                                    unit: "%",
                                                    type: .precipitationChance)
        
        let precipicationAmount = getUnitWithMeasurement(current: dayWeather.rainfallAmount,
                                                         hourly: hourWeathers.map { $0.precipitationAmount },
                                                         type: .rainfall)
        
        let humidity = getUnitWithDouble(current: 10,
                                         hourly: hourWeathers.map { $0.humidity },
                                         unit: nil,
                                         type: .humidity)
        
        let comfort = getUnitWithDouble(current: 10,
                                        hourly: nil,
                                        unit: nil,
                                        type: .comfort)
        
        let laundry = getUnitWithDouble(current: 10,
                                        hourly: nil,
                                        unit: nil,
                                        type: .laundry)
        
        let carWash = getUnitWithDouble(current: 10,
                                        hourly: nil,
                                        unit: nil,
                                        type: .carWash)
        
        let pollen = getUnitWithDouble(current: 10,
                                       hourly: nil,
                                       unit: nil,
                                       type: .pollen)
        
        let weather = Weather(date: Date.now,
                              weatherSummary: weatherSummary,
                              weatherState: self.convertConditionToState(condition: current.condition),
                              symbolName: current.symbolName,
                              location: self.convertPlacemarkToLocation(placemark: placemark),
                              temperature: temperature,
                              apparentTemperature: apparentTemperature,
                              uvIndex: uvIndex,
                              fineDust: fineDust,
                              ultrafineDust: ultrafineDust,
                              wind: wind,
                              cloudCover: cloudCover,
                              precipitationChance: precipitationChance,
                              precipitationAmount: precipicationAmount,
                              humidity: humidity,
                              comfort: comfort,
                              laundry: laundry,
                              carWash: carWash,
                              pollen: pollen)
        
        return weather
    }
}

extension WeatherMapper {
    private func getWeatherSummary(current: CurrentWeather, daily: DayWeather, hourly: [HourWeather]) -> String {
        return "오늘은 어제보다 더 덥고 습해서,\n실외활동은 자제하는 게 좋겠어요.\n다행히 비 소식은 없어요."
    }
    
    private func convertPlacemarkToLocation(placemark: CLPlacemark) -> Location {
        let locality = placemark.locality
        let subLocality = placemark.subLocality
        let administrativeArea = placemark.administrativeArea
        
        let location = Location(locality: locality,
                                subLocality: subLocality,
                                administrativeArea: administrativeArea,
                                timezone: placemark.timeZone)
        return location
    }
    
    private func convertConditionToState(condition: WeatherCondition) -> WeatherState {
        switch condition {
        case .clear, .mostlyClear:
            return WeatherState(type: .clear,
                                title: [
                                    "그래,\n이게 날씨지. 😆",
                                    "놀러가기\n딱 좋은 날씨. 🏕️",
                                    "오늘은 정말\n땡땡이 각인걸. 🤪"
                                ].randomElement()!,
                                name: "맑음",
                                image: "clear",
                                characterBackground: "ClearBackground",
                                color: AppColor.background(.clear))
            
        case .cloudy, .mostlyCloudy, .partlyCloudy:
            return WeatherState(type: .cloudy,
                                title: [
                                    "구름이\n몽실몽실. ☁️"
                                ].randomElement()!,
                                name: "구름 조금",
                                image: "partlyCloudy",
                                characterBackground: "CloudyBackground",
                                color: AppColor.background(.cloudy))
            
        case .rain, .sunShowers:
            return WeatherState(type: .rain,
                                title: [
                                    "하늘에 구멍이\n뚫렸나 봐. 🕳️",
                                    "오늘같은 날엔\n개발자도 재택. 🏠"
                                ].randomElement()!,
                                name: "비",
                                image: "rain",
                                characterBackground: "CloudyBackground",
                                color: AppColor.background(.rain))
        default:
            return WeatherState(type: .unknown,
                                title: "미정",
                                name: "미정",
                                image: "",
                                characterBackground: "",
                                color: AppColor.background(.clear))
        }
    }
    
    private func getUnitWithMeasurement<T: Unit>(current: Measurement<T>?, hourly: [Measurement<T>], type: WeatherUnitCase) -> WeatherUnit {
        guard let current = current else {
            return WeatherUnit(type: type,
                               intensity: nil,
                               value: nil,
                               unit: nil,
                               todayHighestValue: hourly.map { $0.value }.max(),
                               todayLowestValue: hourly.map { $0.value }.min(),
                               todayHourlyValue: hourly.map { $0.value})
        }
        
        return WeatherUnit(type: type,
                           intensity: setIntensity(with: type, value: current.value),
                           value: current.value,
                           unit: current.unit.symbol,
                           todayHighestValue: hourly.map { $0.value }.max(),
                           todayLowestValue: hourly.map { $0.value }.min(),
                           todayHourlyValue: hourly.map { $0.value })
    }
    
    private func getUnitWithDouble(current: Double?, hourly: [Double]?, unit: String?, type: WeatherUnitCase) -> WeatherUnit {
        guard let current = current else {
            return WeatherUnit(type: type,
                               intensity: nil,
                               value: nil,
                               unit: unit,
                               todayHighestValue: hourly?.max(),
                               todayLowestValue: hourly?.min(),
                               todayHourlyValue: hourly)
        }
        
        return WeatherUnit(type: type,
                           intensity: setIntensity(with: type, value: current),
                           value: current,
                           unit: unit,
                           todayHighestValue: hourly?.max(),
                           todayLowestValue: hourly?.min(),
                           todayHourlyValue: hourly)
    }
    
    private func setIntensity(with type: WeatherUnitCase, value: Double) -> Intensity? {
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
}
