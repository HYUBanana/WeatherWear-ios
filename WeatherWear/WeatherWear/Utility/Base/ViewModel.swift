//
//  ViewModelType.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/25.
//

import Foundation
import UIKit

protocol ViewModel {
    var cellType: Bindable.Type { get }
    var cellIdentifier: String { get }
    // id string으로 만들어서 넣는 것이 좋음
    
//    func bind(to cell: BaseCell)
}
