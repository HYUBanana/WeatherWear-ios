//
//  String.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/06.
//

import UIKit

extension String {
    func attributedStringWithLineSpacing(_ lineSpacing: CGFloat) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        return attrString
    }
}
