//
//  ServiceProvider.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/23.
//

protocol RepositoryProviderType: AnyObject {
    var weatherRepository: WeatherRepositoryType { get }
}

final class RepositoryProvider: RepositoryProviderType {
    var weatherRepository: WeatherRepositoryType = WeatherRepository()
}

final class MockRepositoryProvider: RepositoryProviderType {
    var weatherRepository: WeatherRepositoryType = MockWeatherRepository()
}
