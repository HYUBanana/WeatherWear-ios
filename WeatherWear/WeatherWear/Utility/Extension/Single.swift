//
//  Single.swift
//  WeatherWear
//
//  Created by 디해 on 2023/12/27.
//

import RxSwift

public extension Single {
    static func build(_ block: @escaping () async throws -> Element) -> Single<Element> {
        Single<Element>.create { observer in
            Task { @MainActor in
                do {
                    let element = try await block()
                    observer(.success(element))
                } catch {
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
