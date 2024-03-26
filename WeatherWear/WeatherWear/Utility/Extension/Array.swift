//
//  Array.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/17.
//

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
