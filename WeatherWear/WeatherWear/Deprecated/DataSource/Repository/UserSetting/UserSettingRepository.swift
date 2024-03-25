//
//  UserLocationService.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/23.
//

import Foundation
import WeatherKit
import RxSwift
import CoreLocation

final class UserSettingRepository: UserSettingRepositoryType {
    
    private let locationService = LocationService.shared
    private let weatherService = WeatherKitService()
    private let userDefaultsService = UserDefaultsService()
    
    private let mapper = UserSettingMapper()
    
    func fetchUserSetting() async throws -> UserSetting {
        typealias WeatherInfo = (CurrentWeather, CLPlacemark)

        let locationData = userDefaultsService.value(for: \.locations)
        let locations: [CLLocation]? = locationData?.compactMap { dict in
            guard let latitude = dict["latitude"], let longitude = dict["longitude"] else {
                return nil
            }
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        
        let timeData = userDefaultsService.value(for: \.times)
        let decodedTimeData = timeData.flatMap { try? JSONDecoder().decode(UserTimes.self, from: $0) }
        
        let unitsData = userDefaultsService.value(for: \.units)
        let decodedUnitsData = unitsData.flatMap { try? JSONDecoder().decode(UserUnits.self, from: $0) }
        
        let optionsData = userDefaultsService.value(for: \.options)
        let decodedOptionsData = optionsData.flatMap { try? JSONDecoder().decode(UserOptions.self, from: $0) }
        
        let weatherInfos: [WeatherInfo]? = try await locations?.asyncMap { location in
            async let currentWeather = self.weatherService.fetchCurrentWeather(location: location)
            async let placeMarks = self.locationService.getPlacemark(with: location).value
            return try await (currentWeather, placeMarks)
        }

        let weathers = weatherInfos?.compactMap { $0 }.map { $0.0 }
        let placeMarks = weatherInfos?.compactMap { $0 }.map { $0.1 }
        let userSetting = self.mapper.map(placemarks: placeMarks,
                                          weathers: weathers,
                                          departureTime: decodedTimeData?.departureTime,
                                          arrivalTime: decodedTimeData?.arrivalTime,
                                          temperatureUnit: decodedUnitsData?.temperatureUnit,
                                          windUnit: decodedUnitsData?.windUnit,
                                          todayBriefing: decodedOptionsData?.todayBriefing,
                                          detail: decodedOptionsData?.detail)
        
        return userSetting
    }
    
//    func addLocation(location: CLLocation) async throws {
//        let latitude = location.coordinate.latitude
//        let longitude = location.coordinate.longitude
//        let locationArray = ["latitude": latitude, "longitude": longitude]
//
//        guard var userLocationArray = self.userDefaultsService.array(forKey: "locations") as? [[String: Double]] else {
//            self.userDefaultsService.set([locationArray], forKey: "locations")
//            throw LocalError("어쩌구")
//        }
//
//        let isDuplicate = userLocationArray.contains { location in
//            let savedLatitude = location["latitude"]
//            let savedLongitude = location["longitude"]
//            return savedLatitude == latitude && savedLongitude == savedLongitude
//        }
//
//        if !isDuplicate {
//            userLocationArray.append(locationArray)
//            self.userDefaultsService.set([locationArray], forKey: "locations")
//        }
//    }
//
//    func saveTemperatureUnit(unit: String) {
//        userDefaultsService.set(unit, forKey: "temperatureUnit")
//    }
//
//    func saveWindUnit(unit: String) {
//        userDefaultsService.set(unit, forKey: "windUnit")
//    }
//
//    func saveTodayBriefingUnit(value: String) {
//        userDefaultsService.set(value, forKey: "todayBriefing")
//    }
//
//    func saveDetail(value: String) {
//        userDefaultsService.set(value, forKey: "detail")
//    }
}
