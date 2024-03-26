//
//  TextCellViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/31.
//

import Foundation
import UIKit.UIFont
import UIKit.UIColor

class TextCellViewModel {
    
    var text: String?
    var font: AppFont
    var color: AppColor
    
    required init(text: String?, font: AppFont, color: AppColor) {
        self.text = text
        self.font = font
        self.color = color
    }
}

extension TextCellViewModel: ViewModel {
    var cellType: Bindable.Type { return TextCell.self }
    var cellIdentifier: String { return "TextCell" }
}

extension TextCellViewModel {
    static func header(text: String) -> Self {
        return Self.init(text: text,
                  font: AppFont.header(.H4(.semibold)),
                  color: AppColor.text(.primaryDarkText))
    }
    
    static func headerDescription(text: String) -> Self {
        return Self.init(text: text,
                         font: AppFont.description(.D2(.regular)),
                         color: AppColor.text(.tertiaryDarkText))
    }
}
