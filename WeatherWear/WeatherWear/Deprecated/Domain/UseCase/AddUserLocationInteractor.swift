//
//  AddUserLocationInteractor.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/23.
//

import Foundation
import RxSwift
import CoreLocation

class AddUserLocationInteractor: AddUserLocationUseCase {
    
    private let repository: UserSettingRepositoryType
    
    init(repository: UserSettingRepositoryType) {
        self.repository = repository
    }
    
    func execute(with location: CLLocation) async throws {
        //try await repository.addLocation(location: location)
    }
}
