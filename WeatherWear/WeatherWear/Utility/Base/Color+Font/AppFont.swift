//
//  AppFont.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/03.
//

import UIKit

enum AppFont {
    case header(Header)
    case description(Description)
    
    enum Header {
        case H1(FontWeight)
        case H2(FontWeight)
        case H3(FontWeight)
        case H4(FontWeight)
        case H5(FontWeight)
        
        var font: UIFont {
            switch self {
            case .H1(let weight):
                return UIFont.systemFont(ofSize: 36, weight: weight.uiFontWeight)
            case .H2(let weight):
                return UIFont.systemFont(ofSize: 28, weight: weight.uiFontWeight)
            case .H3(let weight):
                return UIFont.systemFont(ofSize: 24, weight: weight.uiFontWeight)
            case .H4(let weight):
                return UIFont.systemFont(ofSize: 20, weight: weight.uiFontWeight)
            case .H5(let weight):
                return UIFont.systemFont(ofSize: 18, weight: weight.uiFontWeight)
            }
        }
    }
    
    enum Description {
        case D1(FontWeight)
        case D2(FontWeight)
        case D3(FontWeight)
        case D4(FontWeight)
        
        var font: UIFont {
            switch self {
            case .D1(let weight):
                return UIFont.systemFont(ofSize: 16, weight: weight.uiFontWeight)
            case .D2(let weight):
                return UIFont.systemFont(ofSize: 14, weight: weight.uiFontWeight)
            case .D3(let weight):
                return UIFont.systemFont(ofSize: 12, weight: weight.uiFontWeight)
            case .D4(let weight):
                return UIFont.systemFont(ofSize: 10, weight: weight.uiFontWeight)
            }
        }
    }
    
    var font: UIFont {
        switch self {
        case .header(let headerFont):
            return headerFont.font
        case .description(let descriptionFont):
            return descriptionFont.font
        }
    }
}

enum FontWeight {
    case bold
    case semibold
    case medium
    case regular
    
    var uiFontWeight: UIFont.Weight {
        switch self {
        case .bold:
            return .bold
        case .semibold:
            return .semibold
        case .medium:
            return .medium
        case .regular:
            return .regular
        }
    }
}
