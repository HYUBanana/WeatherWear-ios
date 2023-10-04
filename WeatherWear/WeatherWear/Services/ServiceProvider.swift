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
}

final class ServiceProvider: ServiceProviderType {
    lazy var userLocationService: UserLocationServiceType = UserLocationService()
    lazy var outingTimeService: OutingTimeServiceType = OutingTimeService()
    lazy var degreeSettingService: DegreeOptionServiceType = DegreeOptionService()
    lazy var autoSettingService: AutoOptionServiceType = AutoOptionService()
}

final class MockServiceProvider: ServiceProviderType {
    lazy var userLocationService: UserLocationServiceType = MockUserLocationService()
    lazy var outingTimeService: OutingTimeServiceType = MockOutingTimeService()
    lazy var degreeSettingService: DegreeOptionServiceType = MockDegreeOptionService()
    lazy var autoSettingService: AutoOptionServiceType = MockAutoOptionService()
}
