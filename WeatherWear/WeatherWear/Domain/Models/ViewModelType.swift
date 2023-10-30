//
//  ViewModelType.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/25.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(_ input: Input) -> Output
}
