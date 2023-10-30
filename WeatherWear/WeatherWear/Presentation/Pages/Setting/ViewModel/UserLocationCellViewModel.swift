//
//  UserLocationCellViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/27.
//

import Foundation
import RxSwift
import RxCocoa

final class UserLocationCellViewModel: ViewModelType {
    struct Input {
        let cellInitialized: Observable<Void>
    }
    
    struct Output {
        let location: Driver<String>
        let time: Driver<String>
        let temperature: Driver<String>
        let weather: Driver<String>
    }
    
    let provider: UserLocationServiceType = MockUserLocationService()
    
    private let userLocation = BehaviorRelay<UserLocation?>(value: nil)
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        input.cellInitialized
            .flatMapLatest { _ in
                self.fetchUserLocation()
            }
            .bind(to: userLocation)
            .disposed(by: disposeBag)
        
        let location = userLocation
            .compactMap { $0?.location }
            .asDriver(onErrorJustReturn: "")
        
        let time = userLocation
            .compactMap { $0?.time }
            .asDriver(onErrorJustReturn: "")
        
        let temperature = userLocation
            .compactMap { $0?.temperature }
            .map { self.temperatureToString(with: $0) }
            .asDriver(onErrorJustReturn: "")
        
        let weather = userLocation
            .compactMap { $0?.weather }
            .asDriver(onErrorJustReturn: "")
        
        return Output(location: location, time: time, temperature: temperature, weather: weather)
    }
    
    func fetchUserLocation() -> Observable<UserLocation> {
        provider.getUserLocation()
    }
}

extension UserLocationCellViewModel {
    func temperatureToString(with temperature: Int) -> String {
        return String(temperature) + "°"
    }
}
