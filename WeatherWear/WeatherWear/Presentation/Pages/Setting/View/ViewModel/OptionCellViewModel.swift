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
    
    private var rows: [(String, [String])]
    
    init(rows: [(String, [String])]) {
        self.rows = rows
    }
    
    func bind(to cell: Sizeable) {
        guard let cell = cell as? OptionCell else { return }
        cell.configure(rows: rows)
    }
}
