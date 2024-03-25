//
//  WeatherState.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/20.
//

import Foundation

struct WeatherState {
    var type: WeatherStateCase
    var title: String
    var name: String
    var image: String
    var characterBackground: String
    var color: AppColor
}

enum WeatherStateCase {
    case clear
    case cloudy
    case rain
    case unknown
}

//
//extension WeatherState {
//    var title: String {
//        switch self {
//        case .clear:
//            return [
//                "그래,\n이게 날씨지. 😆",
//                "놀러가기\n딱 좋은 날씨. 🏕️",
//                "오늘은 정말\n땡땡이 각인걸. 🤪"
//            ].randomElement()!
//
//        case .cloudy:
//            return [
//                "구름이\n몽실몽실. ☁️"
//            ].randomElement()!
//
//        case .rain:
//            return [
//                "하늘에 구멍이\n뚫렸나 봐. 🕳️",
//                "오늘같은 날엔\n개발자도 재택. 🏠"
//            ].randomElement()!
//
//        default:
//            return "미정"
//        }
//    }
//}
//
//extension WeatherState {
//    var state: String {
//        switch self {
//        case .clear:
//            return "맑음"
//        case .cloudy:
//            return "구름 조금"
//        case .rain:
//            return "비"
//        default:
//            return "미정"
//        }
//    }
//}
//
//extension WeatherState {
//    var image: String {
//        switch self {
//        case .clear:
//            return "clear"
//        case .cloudy:
//            return "partlyCloudy"
//        case .rain:
//            return "rain"
//        case .unknown:
//            return ""
//        }
//    }
//}
//
//extension WeatherState {
//    var characterBackground: String {
//        switch self {
//        case .clear:
//            return "ClearBackground"
//        case .cloudy, .rain:
//            return "CloudyBackground"
//        case .unknown:
//            return ""
//        }
//    }
//}
//
//extension WeatherState {
//    var color: AppColor {
//        switch self {
//        case .clear:
//            return AppColor.background(.clear)
//        case .cloudy:
//            return AppColor.background(.partlyCloudy)
//        case .rain:
//            return AppColor.background(.rain)
//        case .unknown:
//            return AppColor.background(.rain) //수정 필요
//        }
//    }
//}
