//
//  Bindable.swift
//  WeatherWear
//
//  Created by 디해 on 2024/01/18.
//

import Foundation

protocol Bindable: BaseCell {
    func bind(with model: ViewModel)
}
