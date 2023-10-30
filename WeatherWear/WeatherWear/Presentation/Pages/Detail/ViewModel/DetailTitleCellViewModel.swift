//
//  DetailTitleCellViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/26.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailTitleCellViewModel: ViewModelType {
    
    struct Input {
        let cellInitialized: Observable<Void>
    }
    
    struct Output {
        let date: Driver<String>
        let mainText: Driver<String>
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
        
        let date = weather
            .compactMap { $0?.date }
            .map { self.dateToText(with: $0) }
            .asDriver(onErrorJustReturn: "")
        
        let mainText = weather
            .compactMap { $0?.location }
            .map { self.locationToText(with: $0) }
            .asDriver(onErrorJustReturn: "")
        
        return Output(date: date, mainText: mainText)
    }
    
    func fetchWeather() -> Observable<Weather> {
        provider.getWeather()
    }
}

extension DetailTitleCellViewModel {
    func dateToText(with date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
                
    func locationToText(with location: String) -> String {
        return "성동구는 지금."
    }
}
