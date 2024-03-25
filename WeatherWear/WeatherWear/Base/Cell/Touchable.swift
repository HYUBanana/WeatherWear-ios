//
//  Touchable.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/06.
//

import RxSwift

protocol Touchable: BaseCell {
    var touch: Observable<Void> { get }
}
