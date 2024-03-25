//
//  FetchWeatherUseCase.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/23.
//

import Foundation
import CoreLocation
import RxSwift

protocol FetchTodayWeatherUseCase {
    func execute() -> Observable<Weather>
}
