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
    case graph(Graph)
    case stroke(Stroke)
    case strokeGradientBackground(StrokeGradientBackground)
    
    enum Text {
        case primaryDarkText
        case secondaryDarkText
        case tertiaryDarkText
        case mediumLightText
        case lightText
        
        var color: UIColor {
            switch self {
            case .primaryDarkText:
                return UIColor(hex: "303030")
            case .secondaryDarkText:
                return UIColor(hex: "5F5F5F")
            case .tertiaryDarkText:
                return UIColor(hex: "5B5B5B")
            case .mediumLightText:
                return UIColor(hex: "8F8F8F")
            case .lightText:
                return UIColor(hex: "A1A1A1")
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
        case clear
        case mostlyClear
        case partlyCloudy
        case cloudy
        case rain
        
        var color: UIColor {
            switch self {
            case .clear:
                return UIColor(hex: "C4EDF7")
            case .mostlyClear:
                return UIColor(hex: "DCEFF4")
            case .partlyCloudy:
                return UIColor(hex: "D8DDE0")
            case .cloudy:
                return UIColor(hex: "C0C9CE")
            case .rain:
                return UIColor(hex: "C0C9CE")
            }
        }
    }
    
    enum Stroke {
        case temperatureStroke
        case apparentTemperatureStroke
        case uvIndexStroke
        case windStroke
        case rainfallStroke
        
        var color: UIColor {
            switch self {
            case .temperatureStroke:
                return UIColor(hex: "FFC11A")
            case .apparentTemperatureStroke:
                return UIColor(hex: "FF351A")
            case .uvIndexStroke:
                return UIColor(hex: "FF961A")
            case .windStroke:
                return UIColor(hex: "A6A4A1")
            case .rainfallStroke:
                return UIColor(hex: "A47FC1")
            }
        }
    }
    
    enum StrokeGradientBackground {
        case temperatureBackground
        case apparentTemperatureBackground
        case uvIndexBackground
        case windBackground
        case rainfallBackground
        
        var color: UIColor {
            switch self {
            case .temperatureBackground:
                return UIColor(hex: "FFE6A1")
            case .apparentTemperatureBackground:
                return UIColor(hex: "FFB2A1")
            case .uvIndexBackground:
                return UIColor(hex: "FFD1A7")
            case .windBackground:
                return UIColor(hex: "DDDBD6")
            case .rainfallBackground:
                return UIColor(hex: "D0CBF0")
            }
        }
    }
    
    enum Graph {
        case line
        case cloudBorder
        case cloudInside
        case rainFallBlue
        
        var color: UIColor {
            switch self {
            case .line:
                return UIColor(hex: "E2E2E2")
            case .cloudBorder:
                return UIColor(hex: "979FB8")
            case .cloudInside:
                return UIColor(hex: "CED1E8")
            case .rainFallBlue:
                return UIColor(hex: "0075FF")
            }
        }
    }
    
    enum Component {
        case highlightBlue
        case blueGray
        case defaultGray
        case lightGray
        case red
        case black
        
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
            case .red:
                return UIColor(hex: "F45656")
            case .black:
                return UIColor(hex: "000000")
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
        case .graph(let graph):
            return graph.color
        case.stroke(let stroke):
            return stroke.color
        case .strokeGradientBackground(let background):
            return background.color
        }
    }
}
