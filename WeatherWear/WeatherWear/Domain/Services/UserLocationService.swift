//
//  UserLocationService.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/23.
//

import Foundation
import RxSwift

protocol UserLocationServiceType {
    func getUserLocation() -> Observable<UserLocation>
}

final class UserLocationService: UserLocationServiceType {
    
    func getUserLocation() -> Observable<UserLocation> {
        return .empty()
    }
}

final class MockUserLocationService: UserLocationServiceType {
    
    private var userLocation =
        UserLocation(location: "서울특별시 성동구",
                     time: "지금 있는 곳",
                     temperature: 30,
                     weather: "🌤️구름 조금",
                     isSelected: true)
//        UserLocation(location: "서울특별시 강남구",
//                     time: "24일, 10시 12분",
//                     temperature: 31,
//                     weather: "🌤️구름 조금",
//                     isSelected: false),
//        UserLocation(location: "프랑스 파리",
//                     time: "24일, 3시 12분",
//                     temperature: 20,
//                     weather: "🌙맑음",
//                     isSelected: false)
    
    func getUserLocation() -> Observable<UserLocation> {
        return .just(userLocation)
    }
}
