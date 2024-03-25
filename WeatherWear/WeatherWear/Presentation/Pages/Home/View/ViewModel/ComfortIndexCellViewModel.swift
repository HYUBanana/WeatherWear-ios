//
//  ComfortIndexCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/26.
//

import Foundation
import RxSwift
import RxCocoa

final class ComfortIndexCellViewModel: CellViewModelType {

    var cellType: Sizeable.Type { return ComfortIndexCell.self }
    var cellIdentifier = "ComfortIndexCell"

    private var livingIndex: LivingIndex
    
    init(livingIndex: LivingIndex) {
        self.livingIndex = livingIndex
    }
    
    func bind(to cell: Sizeable) {
        guard let cell = cell as? ComfortIndexCell else { return }
        cell.configure(icon: livingIndex.icon,
                       title: livingIndex.name,
                       value: livingIndex.value,
                       state: livingIndex.intensity.state,
                       degreeColor: livingIndex.intensity.color)
    }
}
