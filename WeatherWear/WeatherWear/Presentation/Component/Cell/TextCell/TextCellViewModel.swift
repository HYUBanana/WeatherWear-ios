//
//  TextCellViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/31.
//

import Foundation
import UIKit.UIFont
import UIKit.UIColor

class TextCellViewModel: CellViewModelType {
    var cellType: Sizeable.Type { return TextCell.self }
    var cellIdentifier: String { return "TextCell" }
    
    private var text: String
    private var font: AppFont
    private var color: AppColor
    
    required init(text: String, font: AppFont, color: AppColor) {
        self.text = text
        self.font = font
        self.color = color
    }
    
    func bind(to cell: Sizeable) {
        guard let cell = cell as? TextCell else { return }
        cell.configure(text: text, font: font, color: color)
    }
}

extension TextCellViewModel {
    static func header(text: String) -> Self {
        return Self.init(text: text,
                  font: AppFont.header(.H3(.semibold)),
                  color: AppColor.text(.primaryDarkText))
    }
    
    static func headerDescription(text: String) -> Self {
        return Self.init(text: text,
                         font: AppFont.description(.D2(.regular)),
                         color: AppColor.text(.tertiaryDarkText))
    }
}
