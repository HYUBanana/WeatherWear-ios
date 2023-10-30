//
//  HomeTitleCellViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/25.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeTitleCellViewModel: ViewModelType {
    
    struct Input {
        let cellInitialized: Observable<Void>
    }
    
    struct Output {
        let date: Driver<String>
        let mainText: Driver<String>
        let description: Driver<String>
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
            .compactMap { $0?.weatherCondition }
            .map { self.getRandomTitle(with: $0) }
            .asDriver(onErrorJustReturn: "")
        
        let description = weather
            .compactMap { $0 }
            .map { self.getDescription(with: $0) }
            .asDriver(onErrorJustReturn: "")
        
        return Output(date: date, mainText: mainText, description: description)
    }
    
    func fetchWeather() -> Observable<Weather> {
        provider.getWeather()
    }
}

extension HomeTitleCellViewModel {
    func dateToText(with date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
    
    func getRandomTitle(with condition: WeatherCondition) -> String {
        return condition.randomTitles()
    }
    
    func getDescription(with weather: Weather) -> String {
        return "오늘은 어제보다 더 덥고 습해서,\n실외활동은 자제하는 게 좋겠어요.\n다행히 비 소식은 없어요."
    }
}
