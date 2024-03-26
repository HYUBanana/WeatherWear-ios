//
//  AsyncSequeunce.swift
//  WeatherWear
//
//  Created by 디해 on 2023/12/15.
//

import Foundation
import RxSwift

extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}
