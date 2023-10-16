//
//  WeatherCondition.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/12.
//

import UIKit

enum WeatherCondition {
    case clear
    case cloudy
    case rain
    
    var weatherConditionString: String {
        switch self {
        case .clear:
            return "맑음"
        case .cloudy:
            return "구름 조금"
        case .rain:
            return "비"
        }
    }
    
    var weatherConditionImage: UIImage {
        return UIImage(named: "MiniCloud") ?? UIImage()
    }
    
    func randomTitles() -> String {
        switch self {
        case .clear:
            let titles = [
                "그래,\n이게 날씨지. 😆",
                "놀러가기\n딱 좋은 날씨. 🏕️",
                "오늘은 정말\n땡땡이 각인걸. 🤪"
            ]
            return titles.randomElement() ?? ""
            
        case .cloudy:
            let titles = [
                ""
            ]
            return titles.randomElement() ?? ""
            
        case .rain:
            let titles = [
                "하늘에 구멍이\n뚫렸나 봐. 🕳️",
                "오늘같은 날엔\n개발자도 재택. 🏠"
            ]
            return titles.randomElement() ?? ""
        }
    }
}
