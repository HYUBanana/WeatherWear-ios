//
//  AppColor.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/02.
//

import UIKit.UIColor

enum AppColor {
    case text(Text)
    case intensity(Intensity)
    case background(Background)
    case component(Component)
    
    enum Text {
        case primaryDarkText
        case secondaryDarkText
        case tertiaryDarkText
        case lightText
        
        var color: UIColor {
            switch self {
            case .primaryDarkText:
                return UIColor(hex: "303030")
            case .secondaryDarkText:
                return UIColor(hex: "5F5F5F")
            case .tertiaryDarkText:
                return UIColor(hex: "5B5B5B")
            case .lightText:
                return UIColor(hex: "8F8F8F")
            }
        }
    }
    
    enum Intensity {
        case intensity1
        case intensity2
        case intensity3
        case intensity4
        case intensity5
        
        var color: UIColor {
            switch self {
            case .intensity1:
                return UIColor(hex: "df524d")
            case .intensity2:
                return UIColor(hex: "DD960C")
            case .intensity3:
                return UIColor(hex: "89AA07")
            case .intensity4:
                return UIColor(hex: "1EB67F")
            case .intensity5:
                return UIColor(hex: "24A0ED")
            }
        }
    }
    
    enum Background {
        case sky
        case setting
        case white
        case lightGray
        
        var color: UIColor {
            switch self {
            case .sky:
                return UIColor(red: 220, green: 239, blue: 244)
            case .setting:
                return UIColor(red: 240, green: 240, blue: 240)
            case .white:
                return UIColor(hex: "FFFFFF")
            case .lightGray:
                return UIColor(hex: "F3F3F3")
            }
        }
    }
    
    enum Component {
        case highlightBlue
        case blueGray
        case defaultGray
        case lightGray
        case yellow
        
        var color: UIColor {
            switch self {
            case .highlightBlue:
                return UIColor(hex: "24A0ED")
            case .blueGray:
                return UIColor(hex: "30587D")
            case .defaultGray:
                return UIColor(hex: "808080")
            case .lightGray:
                return UIColor(hex: "e2e2e2")
            case .yellow:
                return UIColor(hex: "FFBC00")
            }
        }
    }
    
    enum Gradient {
        case red
        case yellow
        case green
        case blue
        
        var color: UIColor {
            switch self {
            case .red:
                return UIColor(red: 255, green: 74, blue: 74)
            case .yellow:
                return UIColor(red: 242, green: 203, blue: 0)
            case .green:
                return UIColor(red: 71, green: 241, blue: 88)
            case .blue:
                return UIColor(red: 60, green: 149, blue: 255)
            }
        }
    }
    
    var color: UIColor {
        switch self {
        case .text(let text):
            return text.color
        case .intensity(let intensity):
            return intensity.color
        case .background(let background):
            return background.color
        case .component(let component):
            return component.color
        }
    }
}
