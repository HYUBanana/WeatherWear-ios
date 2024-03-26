//
//  Location.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/20.
//

import Foundation

struct Location {
    var locality: String?
    var subLocality: String?
    var administrativeArea: String?
    var timezone: TimeZone?
}

extension Location {
    var descriptionString: String? {
        guard let locality = locality else { return nil }
        guard let subLocality = subLocality else { return locality }
        return locality + " " + subLocality
    }
}
