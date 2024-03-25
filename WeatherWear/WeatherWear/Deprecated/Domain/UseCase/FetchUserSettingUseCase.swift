//
//  FetchUserSettingUseCase.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/23.
//

import Foundation
import RxSwift

protocol FetchUserSettingUseCase {
    func execute() async throws -> UserSetting
}
