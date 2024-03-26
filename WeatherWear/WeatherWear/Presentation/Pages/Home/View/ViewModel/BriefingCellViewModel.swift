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

final class BriefingCellViewModel {
    
    var data: BriefingCellData
    
    init(data: BriefingCellData) {
        self.data = data
    }
}

extension BriefingCellViewModel: ViewModel {
    var cellType: Bindable.Type { return BriefingCell.self }
    var cellIdentifier: String { "BriefingCell" }
}
