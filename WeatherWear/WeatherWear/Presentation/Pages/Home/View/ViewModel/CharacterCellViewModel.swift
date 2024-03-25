//
//  CharacterCellViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/26.
//

import Foundation
import RxSwift
import RxCocoa

final class CharacterCellViewModel: CellViewModelType {
    
    var cellType: Sizeable.Type { return CharacterCell.self }
    var cellIdentifier = "CharacterCell"
    
    private var data: HomeData
    private var showAdvice: Bool
    
    init(data: HomeData, showAdvice: Bool) {
        self.data = data
        self.showAdvice = showAdvice
    }
    
    func bind(to cell: Sizeable) {
        guard let cell = cell as? CharacterCell else { return }
        
        cell.configure(temperature: data.temperature,
                       highestTemperature: data.highestTemperature,
                       lowestTemperature: data.lowestTemperature,
                       weather: data.simpleWeather,
                       weatherImage: data.simpleIcon,
                       location: data.location,
                       lastUpdateTime: data.updateTime,
                       faceAdviceTitle: data.faceAdvice.title,
                       faceAdviceDescription: data.faceAdvice.description,
                       clothesAdviceTitle: data.clothesAdvice.title,
                       clothesAdviceDescription: data.clothesAdvice.description,
                       itemAdviceTitle: data.itemAdvice.title,
                       itemAdviceDescription: data.itemAdvice.description,
                       showAdvice: showAdvice)
    }
}
