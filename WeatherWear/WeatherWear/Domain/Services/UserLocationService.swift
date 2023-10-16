//
//  UserLocationService.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/23.
//

import Foundation

protocol UserLocationServiceType {
    func getUserLocoation(completion: @escaping ([UserLocation]?) -> Void)
    func addUserLocation(completion: @escaping ([UserLocation]?) -> Void)
    func userLocationSelected(previous: Int, next: Int, completion: @escaping (([UserLocation]?) -> Void))
}

final class UserLocationService: UserLocationServiceType {
    
    func getUserLocoation(completion: @escaping ([UserLocation]?) -> Void) {
        
    }
    
    func addUserLocation(completion: @escaping ([UserLocation]?) -> Void) {
        
    }
    
    func userLocationSelected(previous: Int, next: Int, completion: @escaping (([UserLocation]?) -> Void)) {
        
    }
}

final class MockUserLocationService: UserLocationServiceType {
    
    private var userLocations = [
        UserLocation(location: "서울특별시 성동구",
                     time: "지금 있는 곳",
                     temperature: 30,
                     weather: "🌤️구름 조금",
                     isSelected: true),
        UserLocation(location: "서울특별시 강남구",
                     time: "24일, 10시 12분",
                     temperature: 31,
                     weather: "🌤️구름 조금",
                     isSelected: false),
        UserLocation(location: "프랑스 파리",
                     time: "24일, 3시 12분",
                     temperature: 20,
                     weather: "🌙맑음",
                     isSelected: false)
    ]
    
    func getUserLocoation(completion: @escaping ([UserLocation]?) -> Void) {
        
        DispatchQueue.main.async {
            completion(self.userLocations)
        }
    }
    
    func addUserLocation(completion: @escaping ([UserLocation]?) -> Void) {
        userLocations.append(UserLocation(location: "새로운 장소 추가",
                                          time: "새로운 시간",
                                          temperature: 30,
                                          weather: "🌙맑음",
                                          isSelected: false))
        getUserLocoation(completion: completion)
    }
    
    func userLocationSelected(previous: Int, next: Int, completion: @escaping (([UserLocation]?) -> Void)) {
        userLocations[previous].isSelected = false
        userLocations[next].isSelected = true
        getUserLocoation(completion: completion)
    }
}
