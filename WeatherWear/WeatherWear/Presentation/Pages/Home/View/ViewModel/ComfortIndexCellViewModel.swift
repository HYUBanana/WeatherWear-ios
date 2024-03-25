//
//  ComfortIndexCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/26.
//

import Foundation
import RxSwift
import RxCocoa

final class ComfortIndexCellViewModel {

    var data: ComfortIndexCellData
    
    init(data: ComfortIndexCellData) {
        self.data = data
    }
}

extension ComfortIndexCellViewModel: ViewModel {
    var cellType: Bindable.Type { return ComfortIndexCell.self }
    var cellIdentifier: String { "ComfortIndexCell" }
}
