//
//  WeatherService.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/12.
//

import CoreLocation
import RxSwift
import WeatherKit

final class WeatherRepository: WeatherRepositoryType {
    private let locationService = LocationService.shared
    private let weatherService = WeatherKitService()
    
    private let mapper = WeatherMapper()
    
    func fetchCurrentWeather() -> Observable<Weather> {
        locationService
            .locationObservable
            .flatMapLatest { [weak self] location -> Observable<Weather> in
                guard let self, let location else { return .empty() }
                return Single.build {
                    return try await self.fetchWeather(for: location)
                }
                .asObservable()
            }
    }
    
    func fetchWeather(for location: CLLocation) async throws -> Weather {
        async let placeMark = locationService.getPlacemark(with: location)
        async let current = self.weatherService.fetchCurrentWeather(location: location)
        async let daily = self.weatherService.fetchDailyWeather(location: location)
        async let hourly = self.weatherService.fetchHourlyWeather(location: location)
        return try await self.mapper.map(placemark: placeMark.value,
                               current: current,
                               daily: daily,
                               hourly: hourly)
    }
}
