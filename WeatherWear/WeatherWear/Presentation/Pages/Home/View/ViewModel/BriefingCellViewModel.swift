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

final class BriefingCellViewModel: CellViewModelType {
    
    var cellType: Sizeable.Type { return BriefingCell.self }
    var cellIdentifier = "BriefingCell"
    
    private var climateFactor: ClimateFactor
    
    init(climateFactor: ClimateFactor) {
        self.climateFactor = climateFactor
    }
    
    func bind(to cell: Sizeable) {
        guard let cell = cell as? BriefingCell else { return }
        cell.configure(icon: climateFactor.icon,
                       highestValue: climateFactor.highestValue,
                       lowestValue: climateFactor.lowestValue,
                       title: climateFactor.name,
                       state: climateFactor.intensity.state,
                       stateColor: climateFactor.intensity.color,
                       description: climateFactor.description)
    }
}
