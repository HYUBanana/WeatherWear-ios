//
//  WeatherDataServiceType.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/11.
//

import CoreLocation
import RxSwift

protocol WeatherRepositoryType {
    func fetchCurrentWeather() -> Observable<Weather>
    func fetchWeather(for location: CLLocation) async throws -> Weather
}
