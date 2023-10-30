//
//  CharacterCellViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/26.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit.UIImage

final class CharacterCellViewModel: ViewModelType {
    
    struct Input {
        let cellInitialized: Observable<Void>
    }
    
    struct Output {
        let temperature: Driver<String>
        let highestTemperature: Driver<String>
        let lowestTemperature: Driver<String>
        let weatherCondition: Driver<String>
        let weatherConditionImage: Driver<UIImage>
        let location: Driver<String>
        let lastUpdateDate: Driver<String>
        let faceAdvice: Driver<String>
        let faceDescription: Driver<String>
        let clothesAdvice: Driver<String>
        let clothesDescription: Driver<String>
        let itemAdvice: Driver<String>
        let itemDescription: Driver<String>
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
        
        let temperature = weather
            .compactMap { $0?.temperature }
            .map { self.temperatureToString(with: $0)}
            .asDriver(onErrorJustReturn: "")
        
        let highestTemperature = weather
            .compactMap { $0?.highestTemperature }
            .map { self.highestTemperatureToString(with: $0)}
            .asDriver(onErrorJustReturn: "")
        
        let lowestTemperature = weather
            .compactMap { $0?.lowestTemperature }
            .map { self.lowestTemperatureToString(with: $0)}
            .asDriver(onErrorJustReturn: "")
        
        let weatherCondition = weather
            .compactMap { $0?.weatherCondition }
            .map { $0.weatherConditionString }
            .asDriver(onErrorJustReturn: "")
        
        let weatherConditionImage = weather
            .compactMap { $0?.weatherCondition }
            .map { $0.weatherConditionImage }
            .asDriver(onErrorJustReturn: UIImage())
        
        let location = weather
            .compactMap { $0?.location }
            .asDriver(onErrorJustReturn: "")
        
        let lastUpdateDate = weather
            .compactMap { $0 }
            .map { _ in self.getLastUpdateDate() }
            .asDriver(onErrorJustReturn: "")
        
        let faceAdvice = weather
            .compactMap { $0 }
            .map { self.getFaceAdvice(with: $0)}
            .asDriver(onErrorJustReturn: "")
        
        let faceDescription = weather
            .compactMap { $0 }
            .map { self.getFaceDescription(with: $0)}
            .asDriver(onErrorJustReturn: "")
        
        let clothesAdvice = weather
            .compactMap { $0 }
            .map { self.getClothesAdvice(with: $0)}
            .asDriver(onErrorJustReturn: "")
        
        let clothesDescription = weather
            .compactMap{ $0 }
            .map { self.getClothesDescription(with: $0)}
            .asDriver(onErrorJustReturn: "")
        
        let itemAdvice = weather
            .compactMap { $0 }
            .map { self.getItemAdvice(with: $0)}
            .asDriver(onErrorJustReturn: "")
        
        let itemDescription = weather
            .compactMap{ $0 }
            .map { self.getItemDescription(with: $0)}
            .asDriver(onErrorJustReturn: "")
        
        return Output(temperature: temperature, highestTemperature: highestTemperature, lowestTemperature: lowestTemperature, weatherCondition: weatherCondition, weatherConditionImage: weatherConditionImage, location: location, lastUpdateDate: lastUpdateDate, faceAdvice: faceAdvice, faceDescription: faceDescription, clothesAdvice: clothesAdvice, clothesDescription: clothesDescription, itemAdvice: itemAdvice, itemDescription: itemDescription)
    }
    
    func fetchWeather() -> Observable<Weather> {
        provider.getWeather()
    }
}

extension CharacterCellViewModel {
    func temperatureToString(with temperature: Int) -> String {
        return String(temperature) + "°"
    }
    
    func highestTemperatureToString(with temperature: Int) -> String {
        return String(temperature) + "°↗"
    }
    
    func lowestTemperatureToString(with temperature: Int) -> String {
        return String(temperature) + "°↘"
    }
    
    func getLastUpdateDate() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH"
//        return "마지막 업데이트 " + formatter.string(from: date) + "시"
        return "마지막 업데이트 10시"
    }
    
    func getFaceAdvice(with weather: Weather) -> String {
        return "썬크림 필수"
    }
    
    func getFaceDescription(with weather: Weather) -> String {
        return "자외선이 아주 강해요."
    }
    
    func getClothesAdvice(with weather: Weather) -> String {
        return "얇고 짧은 옷"
    }
    
    func getClothesDescription(with weather: Weather) -> String {
        return "기온이 아주 높아요."
    }
    
    func getItemAdvice(with weather: Weather) -> String {
        return "우산 X"
    }
    
    func getItemDescription(with weather: Weather) -> String {
        return "강수확률 없어요."
    }
}
