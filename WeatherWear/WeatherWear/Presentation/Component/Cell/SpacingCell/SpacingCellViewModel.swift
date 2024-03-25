//
//  SpacingCellViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/31.
//

import Foundation

final class SpacingCellViewModel: CellViewModelType {
    var cellType: Sizeable.Type { return SpacingCell.self }
    
    var cellIdentifier = "SpacingCell"
    
    private var spacing: CGFloat
    
    init(spacing: CGFloat) {
        self.spacing = spacing
    }
    
    func bind(to cell: Sizeable) {
        guard let cell = cell as? SpacingCell else { return }
        cell.configure(spacing: spacing)
    }
}
