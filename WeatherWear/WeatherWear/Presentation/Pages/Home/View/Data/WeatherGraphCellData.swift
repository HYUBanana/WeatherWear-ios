//
//  GraphWeatherData.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/08.
//

import Foundation

struct WeatherGraphCellData {
    private let weather: Weather
    
    init(weather: Weather) {
        self.weather = weather
    }
}

extension WeatherGraphCellData {
    
    var date: String? {
        weather.date.toHourMinute24HString(timeZone: weather.location.timezone)
    }
    
    var hour: Int {
        weather.date.getHour()
    }
    
    var minute: Int {
        weather.date.getMinute()
    }
    
    var rangeValue: Int {
        5
    }
    
    var hourlyWeather: [HourlyWeatherGraphViewModel] {
        guard let hourlyTemperature = weather.temperature.todayHourlyValue,
              let hourlyCloudCover = weather.cloudCover.todayHourlyValue,
              let hourlyRainfall = weather.precipitationAmount.todayHourlyValue,
              let hourlyApparentTemperature = weather.apparentTemperature.todayHourlyValue,
              let hourlyUVIndex = weather.uvIndex.todayHourlyValue,
              let hourlyWind = weather.wind.todayHourlyValue
        else { return [] }
        
        var hourlyWeatherGraphs: [HourlyWeatherGraphViewModel] = []
        
        for index in 0..<hourlyTemperature.count {
            let time = String(format: "%02d", index)
            let temperature = hourlyTemperature[index]
            let cloudCover = hourlyCloudCover[index]
            let rainfall = hourlyRainfall[index]
            let apparentTemperature = hourlyApparentTemperature[index]
            let uvIndex = hourlyUVIndex[index]
            let wind = hourlyWind[index]
            
            let hourlyGraph = HourlyWeatherGraphViewModel(cloudCover: cloudCover,
                                                          day: time,
                                                          temperature: temperature,
                                                          rainfall: rainfall,
                                                          apparentTemperature: apparentTemperature,
                                                          uvIndex: uvIndex,
                                                          wind: wind)
            hourlyWeatherGraphs.append(hourlyGraph)
        }
        
        return hourlyWeatherGraphs
    }
}

extension WeatherGraphCellData {
    struct HourlyWeatherGraphViewModel {
        var cloudCover: Double
        var day: String
        var temperature: Double
        var rainfall: Double
        var apparentTemperature: Double
        var uvIndex: Double
        var wind: Double
    }
}
