//
//  Weather.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/04.
//

import Foundation
import RxSwift

final class WeatherGraphCellViewModel: CellViewModelType {
    var cellType: Sizeable.Type { return WeatherGraphCell.self }
    var cellIdentifier = "WeatherGraphCell"
    
    private var graphData: [WeatherGraph]
    
    init(graphData: [WeatherGraph]) {
        self.graphData = graphData
    }
    
    func bind(to cell: Sizeable) {
        guard let cell = cell as? WeatherGraphCell else { return }
        
        cell.configure(data: graphData)
    }
}
