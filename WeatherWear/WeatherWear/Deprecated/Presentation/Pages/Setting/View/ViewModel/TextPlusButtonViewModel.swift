//
//  TextPlusButtonViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/03.
//

import Foundation

class TextPlusButtonViewModel: TextCellViewModel {
    override var cellType: Sizeable.Type { return TextPlusButtonCell.self }
    override var cellIdentifier: String { return "TextPlusButtonCell" }
}

