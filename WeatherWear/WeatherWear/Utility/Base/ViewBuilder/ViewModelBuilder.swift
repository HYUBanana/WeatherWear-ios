//
//  ViewModelBuilder.swift
//  WeatherWear
//
//  Created by 디해 on 2024/01/12.
//

import Foundation

@resultBuilder
struct ViewModelBuilder {
    static func buildBlock(_ components: [ViewModel]...) -> [ViewModel] {
        return Array(components.joined())
    }

    static func buildExpression(_ expression: ViewModel) -> [ViewModel] {
        return [expression]
    }

    static func buildArray(_ components: [[ViewModel]]) -> [ViewModel] {
        return Array(components.joined())
    }

    static func buildEither(first component: [ViewModel]) -> [ViewModel] {
        return component
    }

    static func buildEither(second component: [ViewModel]) -> [ViewModel] {
        return component
    }

    static func buildIf(_ element: [ViewModel]?) -> [ViewModel] { element ?? [] }
}

func buildViewModels(@ViewModelBuilder content: () -> [ViewModel]) -> [ViewModel] {
    return content()
}
