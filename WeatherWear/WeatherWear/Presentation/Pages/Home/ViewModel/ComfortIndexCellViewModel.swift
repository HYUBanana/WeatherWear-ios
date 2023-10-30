//
//  ComfortIndexCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/26.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit.UIColor

final class ComfortIndexCellViewModel: ViewModelType {
    struct Input {
        let cellInitialized: Observable<Void>
    }
    
    struct Output {
        let icon: Driver<String>
        let title: Driver<String>
        let value: Driver<String>
        let color: Driver<UIColor>
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
        
        let icon = weather
            .compactMap { $0 }
            .map { _ in return "😡" }
            .asDriver(onErrorJustReturn: "")
        
        let title = weather
            .compactMap { $0 }
            .map { _ in return "불쾌 지수" }
            .asDriver(onErrorJustReturn: "")
        
        let value = weather
            .compactMap { $0?.comfort }
            .map { String($0) }
            .asDriver(onErrorJustReturn: "")
        
        let color = weather
            .compactMap { $0 }
            .map { _ in return UIColor(red: 255, green: 92, blue: 0)}
            .asDriver(onErrorJustReturn: UIColor.black)
        
        return Output(icon: icon, title: title, value: value, color: color)
    }
    
    func fetchWeather() -> Observable<Weather> {
        provider.getWeather()
    }
}

extension ComfortIndexCellViewModel {

}

//var comfortDatas: [ComfortIndexData] {
//    return [ComfortIndexData(icon: "😡",
//                             title: "불쾌 지수",
//                             value: comfort,
//                             state: "아주 나쁨",
//                             color: UIColor(red: 255, green: 92, blue: 0)),
//            ComfortIndexData(icon: "🧺",
//                             title: "빨래 지수",
//                             value: laundry,
//                             state: "나쁨",
//                             color: UIColor(red: 255, green: 184, blue: 0)),
//            ComfortIndexData(icon: "🧽",
//                             title: "세차 지수",
//                             value: carWash,
//                             state: "보통",
//                             color: UIColor(red: 88, green: 172, blue: 23)),
//            ComfortIndexData(icon: "🌼",
//                             title: "꽃가루 지수",
//                             value: pollen,
//                             state: "좋음",
//                             color: UIColor(red: 36, green: 160, blue: 237))]
//}
