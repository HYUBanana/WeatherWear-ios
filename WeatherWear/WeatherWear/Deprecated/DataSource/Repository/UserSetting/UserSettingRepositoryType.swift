//
//  UserSettingRepositoryType.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/20.
//

import Foundation
import RxSwift
import CoreLocation

protocol UserSettingRepositoryType {
    func fetchUserSetting() async throws -> UserSetting
    //func addLocation(location: CLLocation) async throws
}
