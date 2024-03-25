//
//  UserDefaults.swift
//  WeatherWear
//
//  Created by 디해 on 2023/12/27.
//

import Foundation

extension UserDefaults {
    @objc dynamic var locations: [[String: Double]]? {
        return array(forKey: UserDefaultsKeys.locations._kvcKeyPathString!) as? [[String: Double]]
    }
    
    @objc dynamic var times: Data? {
        return data(forKey: UserDefaultsKeys.times._kvcKeyPathString!)
    }
    
    @objc dynamic var units: Data? {
        return data(forKey: UserDefaultsKeys.units._kvcKeyPathString!)
    }
    
    @objc dynamic var options: Data? {
        return data(forKey: UserDefaultsKeys.options._kvcKeyPathString!)
    }
}
