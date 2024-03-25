//
//  MockWeatherService.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/11.
//

import Foundation
import RxSwift
import CoreLocation

final class MockWeatherRepository: WeatherRepositoryType {
    
    private let weather = Weather(date: Date(),
                                  weatherSummary: "날씨에용",
                                  weatherState: .init(type: .clear,
                                                      title: "맑아용",
                                                      name: "날씨",
                                                      image: "",
                                                      characterBackground: "",
                                                      color: AppColor.background(.clear)),
                                  symbolName: "cloud.sun",
                                  location: Location(
                                    locality: "서울",
                                    subLocality: "강남구",
                                    administrativeArea: "서울특별시",
                                    timezone: TimeZone(identifier: "Asia/Seoul")
                                  ),
                                  temperature: WeatherUnit(
                                    type: .temperature,
                                    intensity: .low,
                                    value: 21.5,
                                    unit: "°C",
                                    todayHighestValue: 23.0,
                                    todayLowestValue: 18.0,
                                    todayHourlyValue: [20.0, 21.0, 21.5, 22.0, 22.5, 23.0]
                                  ),
                                  apparentTemperature: WeatherUnit(
                                    type: .apparentTemperature,
                                    intensity: .low,
                                    value: 21.5,
                                    unit: "°C",
                                    todayHighestValue: 23.0,
                                    todayLowestValue: 18.0,
                                    todayHourlyValue: [20.0, 21.0, 21.5, 22.0, 22.5, 23.0]
                                  ),
                                  uvIndex: WeatherUnit(
                                    type: .uvIndex,
                                    intensity: .low,
                                    value: 21.5,
                                    unit: "°C",
                                    todayHighestValue: 23.0,
                                    todayLowestValue: 18.0,
                                    todayHourlyValue: [20.0, 21.0, 21.5, 22.0, 22.5, 23.0]
                                  ),
                                  fineDust: WeatherUnit(
                                    type: .fineDust,
                                    intensity: .low,
                                    value: 21.5,
                                    unit: "°C",
                                    todayHighestValue: 23.0,
                                    todayLowestValue: 18.0,
                                    todayHourlyValue: [20.0, 21.0, 21.5, 22.0, 22.5, 23.0]
                                  ),
                                  ultrafineDust: WeatherUnit(
                                    type: .ultraFinedust,
                                    intensity: .low,
                                    value: 21.5,
                                    unit: "°C",
                                    todayHighestValue: 23.0,
                                    todayLowestValue: 18.0,
                                    todayHourlyValue: [20.0, 21.0, 21.5, 22.0, 22.5, 23.0]
                                  ),
                                  wind: WeatherUnit(
                                    type: .wind,
                                    intensity: .low,
                                    value: 21.5,
                                    unit: "°C",
                                    todayHighestValue: 23.0,
                                    todayLowestValue: 18.0,
                                    todayHourlyValue: [20.0, 21.0, 21.5, 22.0, 22.5, 23.0]
                                  ),
                                  cloudCover: WeatherUnit(
                                    type: .cloudCover,
                                    intensity: .low,
                                    value: 21.5,
                                    unit: "°C",
                                    todayHighestValue: 23.0,
                                    todayLowestValue: 18.0,
                                    todayHourlyValue: [20.0, 21.0, 21.5, 22.0, 22.5, 23.0]
                                  ),
                                  precipitationChance: WeatherUnit(
                                    type: .precipitationChance,
                                    intensity: .low,
                                    value: 21.5,
                                    unit: "°C",
                                    todayHighestValue: 23.0,
                                    todayLowestValue: 18.0,
                                    todayHourlyValue: [20.0, 21.0, 21.5, 22.0, 22.5, 23.0]
                                  ),
                                  precipitationAmount: WeatherUnit(
                                    type: .rainfall,
                                    intensity: .low,
                                    value: 21.5,
                                    unit: "°C",
                                    todayHighestValue: 23.0,
                                    todayLowestValue: 18.0,
                                    todayHourlyValue: [20.0, 21.0, 21.5, 22.0, 22.5, 23.0]
                                  ),
                                  humidity: WeatherUnit(
                                    type: .humidity,
                                    intensity: nil,
                                    value: nil,
                                    unit: nil,
                                    todayHighestValue: 10.0,
                                    todayLowestValue: 10.0,
                                    todayHourlyValue: [10.0, 10.0]
                                  ),
                                  comfort: WeatherUnit(type: .comfort),
                                  laundry: WeatherUnit(type: .laundry),
                                  carWash: WeatherUnit(type: .carWash),
                                  pollen: WeatherUnit(type: .pollen))
    
    func fetchCurrentWeather() -> Observable<Weather> {
        return Observable<Weather>.create { [weak self] observer in
            guard let `self` = self else {
                observer.onError(LocalError("self deallocated"))
                return Disposables.create()
            }
            observer.onNext(self.weather)
            return Disposables.create()
        }
    }
    
    func fetchWeather(for: CLLocation) async throws -> Weather {
        return self.weather
        //        return Observable<Weather>.create { [weak self] observer in
        //            guard let `self` = self else {
        //                observer.onError(ErrorType.selfDeallocated)
        //                return Disposables.create()
        //            }
        //            observer.onNext(self.weather)
        //            return Disposables.create()
        //        }
    }
}
