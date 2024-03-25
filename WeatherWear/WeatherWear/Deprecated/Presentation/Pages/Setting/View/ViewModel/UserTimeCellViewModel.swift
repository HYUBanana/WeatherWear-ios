//
//  OutingTimeCellViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/27.
//

import Foundation
import RxSwift
import RxCocoa

final class UserTimeCellViewModel: CellViewModelType {
    
    var cellType: Sizeable.Type { return UserTimeCell.self }
    var cellIdentifier = "UserTimeCell"
    
    private var timeSchedule: String
    private var totalTime: String
    
    init(timeSchedule: String, totalTime: String) {
        self.timeSchedule = timeSchedule
        self.totalTime = totalTime
    }
    
    func bind(to cell: Sizeable) {
        guard let cell = cell as? UserTimeCell else { return }
        cell.configure(timeSchedule: timeSchedule, totalTime: totalTime)
    }
}
