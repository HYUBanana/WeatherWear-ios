//
//  ServiceProvider.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/23.
//

protocol ServiceProviderType: AnyObject {
    var userLocationService: UserLocationServiceType { get }
    var outingTimeService: OutingTimeServiceType { get }
    var degreeSettingService: DegreeOptionServiceType { get }
    var autoSettingService: AutoOptionServiceType { get }
    var weatherService: WeatherService { get }
}

final class ServiceProvider: ServiceProviderType {
    var userLocationService: UserLocationServiceType = UserLocationService()
    var outingTimeService: OutingTimeServiceType = OutingTimeService()
    var degreeSettingService: DegreeOptionServiceType = DegreeOptionService()
    var autoSettingService: AutoOptionServiceType = AutoOptionService()
    var weatherService: WeatherService = WeatherService()
}

final class MockServiceProvider: ServiceProviderType {
    var userLocationService: UserLocationServiceType = MockUserLocationService()
    var outingTimeService: OutingTimeServiceType = MockOutingTimeService()
    var degreeSettingService: DegreeOptionServiceType = MockDegreeOptionService()
    var autoSettingService: AutoOptionServiceType = MockAutoOptionService()
    //var weatherService: WeatherServiceType = MockWeatherService()
    var weatherService: WeatherService = WeatherService()
}
