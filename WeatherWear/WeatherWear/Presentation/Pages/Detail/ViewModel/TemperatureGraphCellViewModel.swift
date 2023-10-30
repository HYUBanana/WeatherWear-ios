//
//  TemperatureGraphCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/26.
//

import Foundation
import RxSwift
import RxCocoa

final class TemperatureGraphCellViewModel: ViewModelType {
    
    struct Input {
        let cellInitialized: Observable<Void>
    }
    
    struct Output {
        
    }
    
    let provider: WeatherServiceType = MockWeatherService()
    
    private let weather = BehaviorRelay<Weather?>(value: nil)
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        input.cellInitialized
            .flatMapLatest { _ in
                self.fetchWeather()
            }
            .bind(to: weather)
            .disposed(by: disposeBag)
        
        return Output()
    }
    
    func fetchWeather() -> Observable<Weather> {
        provider.getWeather()
    }
}
