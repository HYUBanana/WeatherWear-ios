//
//  BriefingCellViewMode.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/26.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit.UIColor

final class BriefingCellViewModel: ViewModelType {
    struct Input {
        let cellInitialized: Observable<Void>
    }
    
    struct Output {
        let icon: Driver<String>
        let title: Driver<String>
        let state: Driver<String>
        let color: Driver<UIColor>
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
        
        let icon = weather
            .compactMap { $0 }
            .map { _ in return "🌡️" }
            .asDriver(onErrorJustReturn: "")
        
        let title = weather
            .compactMap { $0 }
            .map { _ in return "체감온도" }
            .asDriver(onErrorJustReturn: "")
        
        let state = weather
            .compactMap { $0 }
            .map { _ in return "아주 높음" }
            .asDriver(onErrorJustReturn: "")
        
        let color = weather
            .compactMap { $0 }
            .map { _ in return UIColor(red: 255, green: 92, blue: 0) }
            .asDriver(onErrorJustReturn: UIColor.black)
        
        let description = weather
            .compactMap { $0?.apparentTemperature }
            .map { temp in return "체감 온도 최대 \(String(temp))도.\n어제보다 2도 더 높으며,\n건강에 위협적인 수준이에요."}
            .asDriver(onErrorJustReturn: "")
        
        return Output(icon: icon, title: title, state: state, color: color, description: description)
    }
    
    func fetchWeather() -> Observable<Weather> {
        provider.getWeather()
    }
}


//var briefingDatas: [BriefingData] {
//    return [BriefingData(icon: "🌡️",
//                         title: "체감온도",
//                         state: "아주 높음",
//                         value: apparentTemperature,
//                         description: "체감 온도 최대 \(apparentTemperature)도.\n어제보다 2도 더 높으며,\n건강에 위협적인 수준이에요.",
//                         color: UIColor(red: 255, green: 92, blue: 0)),
//            BriefingData(icon: "😎",
//                         title: "자외선",
//                         state: "아주 강함",
//                         value: uvIndex,
//                         description: "자외선지수 최고 \(uvIndex).\n09시부터 17시 사이에는\n썬크림을 꼭 발라야 해요.",
//                         color: UIColor(red: 255, green: 184, blue: 0)),
//            BriefingData(icon: "😷",
//                         title: "대기질",
//                         state: "좋음",
//                         value: 15,
//                         description: "미세먼지 좋음 (\(fineDust)μg/m³)\n초미세먼지 좋음 (\(ultrafineDust)μg/m³)\n오랜만에 맑은 공기네요.",
//                         color: UIColor(red: 88, green: 172, blue: 23)),
//            BriefingData(icon: "💨",
//                         title: "바람",
//                         state: "약함",
//                         value: wind,
//                         description: "최대 풍속 \(wind)m/s 정도로,\n약한 편이에요.",
//                         color: UIColor(red: 36, green: 160, blue: 237))]
//}
