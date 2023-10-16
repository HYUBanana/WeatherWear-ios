//
//  WeatherService.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/12.
//

import Foundation

protocol WeatherServiceType {
    func getWeather(completion: @escaping (Weather) -> Void)
}

final class WeatherService: WeatherServiceType {
    func getWeather(completion: @escaping (Weather) -> Void) {
        
    }
}

final class MockWeatherService: WeatherServiceType {
    
    private let weather = Weather(date: Date(),
                                  location: "서울특별시 성동구",
                                  temperature: 30,
                                  highestTemperature: 32,
                                  lowestTemperature: 22,
                                  weatherCondition: .clear,
                                  apparentTemperature: 34,
                                  uvIndex: 8, fineDust: 23,
                                  ultrafineDust: 11,
                                  wind: 2,
                                  comfort: 80,
                                  laundry: 30,
                                  carWash: 50,
                                  pollen: 10,
                                  isDaylight: true)
    
    func getWeather(completion: @escaping (Weather) -> Void) {
        DispatchQueue.main.async {
            completion(self.weather)
        }
    }
}
