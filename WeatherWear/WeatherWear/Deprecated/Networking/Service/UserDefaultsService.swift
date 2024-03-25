//
//  UserDefaultsService.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/19.
//

import Foundation

class UserDefaultsService {
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func value<T>(for keyPath: KeyPath<UserDefaults, T>) -> T {
        return defaults[keyPath: keyPath]
    }
    
    func setValue<T>(_ value: T, for keyPath: ReferenceWritableKeyPath<UserDefaults, T>) {
        defaults[keyPath: keyPath] = value
    }
}
