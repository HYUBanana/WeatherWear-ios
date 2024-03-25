//
//  MockUserSettingRepository.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/20.
//

import RxSwift
import CoreLocation

final class MockUserSettingRepository: UserSettingRepositoryType {

    private var userSetting = UserSetting(locations: nil,
                                          departureTime: nil,
                                          arrivalTime: nil,
                                          totalTime: nil,
                                          temperatureUnit: .celsius,
                                          windSpeedUnit: .milesPerHour,
                                          todayBriefing: .manual,
                                          detail: .automatic)

    func fetchUserSetting() async throws -> UserSetting {
        return userSetting
    }

    func addLocation(location: CLLocation) async throws {

    }
}
