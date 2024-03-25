//
//  ViewModelType.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/25.
//

import Foundation
import UIKit

protocol CellViewModelType {
    var cellType: Sizeable.Type { get }
    var cellIdentifier: String { get }
    
    func bind(to cell: Sizeable)
}
