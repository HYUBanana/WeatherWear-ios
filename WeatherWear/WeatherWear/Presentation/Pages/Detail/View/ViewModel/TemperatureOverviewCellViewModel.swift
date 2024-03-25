//
//  TemperatureOverviewViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/04.
//

import Foundation

final class TemperatureOverviewCellViewModel: CellViewModelType {
    var cellType: Sizeable.Type { return TemperatureOverviewCell.self }
    
    var cellIdentifier = "TemperatureOverviewCell"
    
    private var data: DetailData
    
    init(data: DetailData) {
        self.data = data
    }
    
    func bind(to cell: Sizeable) {
        guard let cell = cell as? TemperatureOverviewCell else { return }
        
        cell.configure(temperature: data.temperature,
                       highestTemperature: data.highestTemperature,
                       lowestTemperature: data.lowestTemperature,
                       weather: data.simpleWeather,
                       weatherImage: data.simpleIcon,
                       timeLocation: data.timeLocation,
                       lastUpdateTime: data.updateTime)
    }
}
