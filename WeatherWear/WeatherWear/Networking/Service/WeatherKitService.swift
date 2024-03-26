//
//  WeatherService.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/20.
//

import WeatherKit
import CoreLocation
import RxSwift

class WeatherKitService {
    private let service = WeatherService.shared
    
    func fetchCurrentWeather(location: CLLocation) async throws -> CurrentWeather {
        try await self.service.weather(for: location, including: .current)
    }
    
    func fetchDailyWeather(location: CLLocation) async throws -> Forecast<DayWeather> {
        try await self.service.weather(for: location, including: .daily)
    }
    
    func fetchHourlyWeather(location: CLLocation) async throws -> Forecast<HourWeather> {
        do {
            let calendar = Calendar.current
            let now = Date()
            let startDate = calendar.startOfDay(for: now)
            var endDateComponents = DateComponents()
            endDateComponents.day = 1
            endDateComponents.hour = 1
            let endDate = calendar.date(byAdding: endDateComponents, to: startDate)!
            return try await self.service.weather(for: location, including: .hourly(startDate: startDate, endDate: endDate))
        } catch {
            throw LocalError("fetch error")
        }
    }
}
