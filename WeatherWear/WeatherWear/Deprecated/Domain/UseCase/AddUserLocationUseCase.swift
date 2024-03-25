//
//  AddUserLocationUseCase.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/23.
//

import Foundation
import RxSwift
import CoreLocation

protocol AddUserLocationUseCase {
    func execute(with location: CLLocation) async throws
}
