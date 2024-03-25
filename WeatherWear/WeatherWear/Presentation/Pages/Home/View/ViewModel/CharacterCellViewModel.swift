//
//  CharacterCellViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/26.
//

import Foundation
import RxSwift
import RxCocoa

final class CharacterCellViewModel {
    
    var data: CharacterCellData
    var showAdvice: Bool
    
    init(data: CharacterCellData, showAdvice: Bool) {
        self.data = data
        self.showAdvice = showAdvice
    }
}

extension CharacterCellViewModel: ViewModel {
    var cellType: Bindable.Type { return CharacterCell.self }
    var cellIdentifier: String { "CharacterCell" }
}
