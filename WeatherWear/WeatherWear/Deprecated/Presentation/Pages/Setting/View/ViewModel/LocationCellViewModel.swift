//
//  UserLocationCellViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/27.
//

import Foundation
import RxSwift
import RxCocoa

final class LocationCellViewModel: CellViewModelType {
    
    var cellType: Sizeable.Type { return LocationCell.self }
    var cellIdentifier = "LocationCell"
    
    private var location: UserLocationDisplayModel
    
    init(location: UserLocationDisplayModel) {
        self.location = location
    }
    
    func bind(to cell: Sizeable) {
        guard let cell = cell as? LocationCell else { return }
        cell.configure(location: location.location,
                       time: location.time,
                       temperature: location.temperature,
                       weather: location.weather)
    }
}
