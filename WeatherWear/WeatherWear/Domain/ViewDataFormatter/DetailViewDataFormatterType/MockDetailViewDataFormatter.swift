//
//  DetailViewDataFormatter.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/08.
//

import Foundation

class MockDetailViewDataFormatter: DetailViewDataFormatterType {
    func transform(_ weather: Weather) -> DetailData {
        DetailData(simpleWeather: weather.weatherCondition.state,
                   simpleIcon: weather.weatherCondition.image,
                   timeLocation: combineTimeLocation(time: weather.date, location: weather.location),
                   updateTime: dateToString(with: Date.now),
                   temperature: String(weather.temperature),
                   highestTemperature: String(weather.highestTemperature),
                   lowestTemperature: String(weather.lowestTemperature),
                   apparentTemperatureDescription: "체감 온도 최대 34도.\n어제보다 2도 더 높으며, 건강에 위협적인 수준이에요.",
                   graph: [.init(humidity: "3.1", cloudCover: "43%", day: "01", temperature: "23"),
                           .init(humidity: "5.4", cloudCover: "9%", day: "02", temperature: "26"),
                           .init(humidity: "2.7", cloudCover: "12", day: "03", temperature: "20"),
                           .init(humidity: "1.0", cloudCover: "4", day: "04", temperature: "25"),
                           .init(humidity: "4.8", cloudCover: "2", day: "05", temperature: "18"),
                           .init(humidity: "8.2", cloudCover: "34", day: "06", temperature: "20"),
                           .init(humidity: "2.5", cloudCover: "19", day: "07", temperature: "15"),
                           .init(humidity: "6.4", cloudCover: "36", day: "08", temperature: "28"),
                           .init(humidity: "3.3", cloudCover: "20", day: "09", temperature: "14"),
                           .init(humidity: "6.8", cloudCover: "54", day: "10", temperature: "25")])
    }
}

extension MockDetailViewDataFormatter {
    
    func combineTimeLocation(time: Date, location: String) -> String {
        let time = dateToString(with: time)
        return "\(time)\n\(location)"
    }
    
    func dateToString(with date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
}
