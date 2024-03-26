//
//  Weather.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/04.
//

import Foundation
import RxSwift

final class WeatherGraphCellViewModel {
    
    var data: WeatherGraphCellData
    var graphType: GraphType
    
    init(data: WeatherGraphCellData, graphType: GraphType) {
        self.data = data
        self.graphType = graphType
    }
}

extension WeatherGraphCellViewModel: ViewModel {
    var cellType: Bindable.Type { return WeatherGraphCell.self }
    var cellIdentifier: String { "WeatherGraphCell" }
}
