//
//  ApparentTemperatureGraphCellViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/26.
//

import Foundation
import RxSwift
import RxCocoa

final class ApparentTemperatureGraphCellViewModel: CellViewModelType {
    var cellType: Sizeable.Type { return ApparentTemperatureGraphCell.self }
    var cellIdentifier = "ApparentTemperatureGraphCell"
    
    private var graphData: [WeatherGraph]
    
    init(graphData: [WeatherGraph]) {
        self.graphData = graphData
    }
    
    func bind(to cell: Sizeable) {
        guard let cell = cell as? ApparentTemperatureGraphCell else { return }
        cell.configure(data: graphData)
    }
}
