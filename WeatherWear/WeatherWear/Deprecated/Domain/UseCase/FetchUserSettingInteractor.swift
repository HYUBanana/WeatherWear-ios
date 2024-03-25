//
//  FetchUserSettingInteractor.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/23.
//

import RxSwift

class FetchUserSettingInteractor: FetchUserSettingUseCase {
    private let repository: UserSettingRepositoryType
    
    init(repository: UserSettingRepositoryType) {
        self.repository = repository
    }
    
    func execute() async throws -> UserSetting {
        try await repository.fetchUserSetting()
    }
}
