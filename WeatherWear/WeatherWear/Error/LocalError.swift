//
//  Error.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/21.
//

import Foundation

struct LocalError: Error, CustomStringConvertible {
    
    let description: String
    
    init(_ description: String) {
        self.description = description
    }
}
