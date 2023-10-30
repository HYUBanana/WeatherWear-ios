//
//  OutingTimeCellViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/27.
//

import Foundation
import RxSwift
import RxCocoa

final class OutingTimeCellViewModel: ViewModelType {
    
    struct Input {
        let cellInitialized: Observable<Void>
    }
    
    struct Output {
        let departureTime: Driver<String>
        let arrivalTime: Driver<String>
        let totalTime: Driver<String>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        let departureTime = input.cellInitialized
            .map { _ in
                "08시 00분에 나가서,"
            }
            .asDriver(onErrorJustReturn: "")
        
        let arrivalTime = input.cellInitialized
            .map { _ in
                "19시 00분에 돌아와요."
            }
            .asDriver(onErrorJustReturn: "")
        
        let totalTime = input.cellInitialized
            .map { _ in
                "총 11시간 00분"
            }
            .asDriver(onErrorJustReturn: "")
        
        return Output(departureTime: departureTime, arrivalTime: arrivalTime, totalTime: totalTime)
    }
}
