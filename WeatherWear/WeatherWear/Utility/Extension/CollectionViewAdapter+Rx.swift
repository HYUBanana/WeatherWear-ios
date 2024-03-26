//
//  Reactive+CollectionViewAdapter.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/18.
//

import RxSwift

extension Reactive where Base: CollectionViewAdapter {
    var touch: Observable<ViewModel> {
        return base.touch
    }
    
    var buttonTap: Observable<ViewModel> {
        return base.buttonTap
    }
}
