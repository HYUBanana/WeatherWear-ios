//
//  TabBarItem.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/05.
//

import UIKit

enum TabBarItem: Int {
    case home
    case detail
    case week
    case setting
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .detail:
            return "자세히"
        case .week:
            return "일주일"
        case .setting:
            return "설정"
        }
    }
    
    var normalImage: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "Home")
        case .detail:
            return UIImage(named: "Detail")
        case .week:
            return UIImage(named: "Week")
        case .setting:
            return UIImage(named: "Setting")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "HomeSelected")
        case .detail:
            return UIImage(named: "DetailSelected")
        case .week:
            return UIImage(named: "WeekSelected")
        case .setting:
            return UIImage(named: "SettingSelected")
        }
    }
}
