//
//  FetchWeatherInteractor.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/19.
//

import RxSwift
import CoreLocation

class FetchTodayWeatherInteractor: FetchTodayWeatherUseCase {
    //weak var output: FetchHomeDisplayModelOutputPort?
    
    private let repository: WeatherRepositoryType
    
    init(repository: WeatherRepositoryType) {
        self.repository = repository
    }
    
    func execute() -> Observable<Weather> {
        repository.fetchCurrentWeather()
    }
}
