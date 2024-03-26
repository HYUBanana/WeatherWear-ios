//
//  SpacingCellViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/31.
//

import Foundation

final class SpacingCellViewModel {
    
    let spacing: CGFloat
    
    init(spacing: CGFloat) {
        self.spacing = spacing
    }
}

extension SpacingCellViewModel: ViewModel {
    var cellType: Bindable.Type { return SpacingCell.self }
    var cellIdentifier: String { "SpacingCell" }
}
