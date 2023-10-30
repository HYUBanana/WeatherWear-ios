//
//  OptionCellViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/27.
//

import Foundation
import RxSwift
import RxCocoa

final class OptionCellViewModel: ViewModelType {
    struct Input {
        let cellInitialized: Observable<Void>
    }
    
    struct Output {
        let title: Driver<String>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        let title = input.cellInitialized
            .map { _ in
                "오늘의 브리핑"
            }
            .asDriver(onErrorJustReturn: "")
        
        return Output(title: title)
    }
}
