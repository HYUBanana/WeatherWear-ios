//
//  Weather.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/12.
//

import UIKit

struct Weather {
    var date: Date
    var location: String
    var temperature: Int
    var highestTemperature: Int
    var lowestTemperature: Int
    
    var weatherCondition: WeatherCondition
    
    //The feels-like temperature when factoring wind and humidity.
    var apparentTemperature: Int
    //The level of ultraviolet radiation.
    var uvIndex: Int
    var fineDust: Int
    var ultrafineDust: Int
    var wind: Int
    
    var comfort: Int
    var laundry: Int
    var carWash: Int
    var pollen: Int
    
    //A Boolean value indicating whether there is daylight.
    var isDaylight: Bool
}

extension Weather {
    
    var temperatureString: String {
        return String(temperature) + "°"
    }
    
    var highestTemperatureString: String {
        return String(highestTemperature) + "°↗"
    }
    
    var lowestTemperatureString: String {
        return String(lowestTemperature) + "°↘"
    }
    
    var dateTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        let formattedDate = formatter.string(from: date)
        return formattedDate + ","
    }
    
    var title: String {
        return weatherCondition.randomTitles()
    }
    
    var description: String {
        return "오늘은 어제보다 더 덥고 습해서,\n실외활동은 자제하는 게 좋겠어요.\n다행히 비 소식은 없어요."
    }
    
    var weatherConditionString: String {
        return weatherCondition.weatherConditionString
    }
    
    var weatherConditionImage: UIImage {
        return weatherCondition.weatherConditionImage
    }
    
    var lastUpdatedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return "마지막 업데이트 " + formatter.string(from: date) + "시"
    }
    
    var faceAdvice: Advice {
        return Advice(title: "썬크림 필수", description: "자외선이 아주 강해요.")
    }
    
    var clothesAdvice: Advice {
        return Advice(title: "얇고 짧은 옷", description: "기온이 아주 높아요.")
    }
    
    var itemAdvice: Advice {
        return Advice(title: "우산 X", description: "강수확률 없어요.")
    }
    
    var briefingDatas: [BriefingData] {
        return [BriefingData(icon: "🌡️",
                             title: "체감온도",
                             state: "아주 높음",
                             value: apparentTemperature,
                             description: "체감 온도 최대 \(apparentTemperature)도.\n어제보다 2도 더 높으며,\n건강에 위협적인 수준이에요.",
                             color: UIColor(red: 255, green: 92, blue: 0)),
                BriefingData(icon: "😎",
                             title: "자외선",
                             state: "아주 강함",
                             value: uvIndex,
                             description: "자외선지수 최고 \(uvIndex).\n09시부터 17시 사이에는\n썬크림을 꼭 발라야 해요.",
                             color: UIColor(red: 255, green: 184, blue: 0)),
                BriefingData(icon: "😷",
                             title: "대기질",
                             state: "좋음",
                             value: 15,
                             description: "미세먼지 좋음 (\(fineDust)μg/m³)\n초미세먼지 좋음 (\(ultrafineDust)μg/m³)\n오랜만에 맑은 공기네요.",
                             color: UIColor(red: 88, green: 172, blue: 23)),
                BriefingData(icon: "💨",
                             title: "바람",
                             state: "약함",
                             value: wind,
                             description: "최대 풍속 \(wind)m/s 정도로,\n약한 편이에요.",
                             color: UIColor(red: 36, green: 160, blue: 237))]
    }
    
    var comfortDatas: [ComfortIndexData] {
        return [ComfortIndexData(icon: "😡",
                                 title: "불쾌 지수",
                                 value: comfort,
                                 state: "아주 나쁨",
                                 color: UIColor(red: 255, green: 92, blue: 0)),
                ComfortIndexData(icon: "🧺",
                                 title: "빨래 지수",
                                 value: laundry,
                                 state: "나쁨",
                                 color: UIColor(red: 255, green: 184, blue: 0)),
                ComfortIndexData(icon: "🧽",
                                 title: "세차 지수",
                                 value: carWash,
                                 state: "보통",
                                 color: UIColor(red: 88, green: 172, blue: 23)),
                ComfortIndexData(icon: "🌼",
                                 title: "꽃가루 지수",
                                 value: pollen,
                                 state: "좋음",
                                 color: UIColor(red: 36, green: 160, blue: 237))]
    }
}
