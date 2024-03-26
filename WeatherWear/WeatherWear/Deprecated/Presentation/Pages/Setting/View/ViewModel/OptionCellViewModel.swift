//
//  OptionCellViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/27.
//

import Foundation
import RxSwift
import RxCocoa

final class OptionCellViewModel: CellViewModelType {
    
    var cellType: Sizeable.Type { return OptionCell.self }
    var cellIdentifier = "OptionCell"
    
    private var options: [OptionDisplayModel]
    
    init(options: [OptionDisplayModel]) {
        self.options = options
    }
    
    func bind(to cell: Sizeable) {
        guard let cell = cell as? OptionCell else { return }
        cell.configure(options: options)
    }
}
