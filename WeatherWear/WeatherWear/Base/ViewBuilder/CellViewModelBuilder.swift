//
//  ViewModelBuilder.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/06.
//

import Foundation

@resultBuilder
struct CellViewModelBuilder {
    static func buildBlock(_ components: [CellViewModelType]...) -> [CellViewModelType] {
        return Array(components.joined())
    }
    
    static func buildExpression(_ expression: CellViewModelType) -> [CellViewModelType] {
        return [expression]
    }
    
    static func buildArray(_ components: [[CellViewModelType]]) -> [CellViewModelType] {
        return Array(components.joined())
    }
    
    static func buildEither(first component: [CellViewModelType]) -> [CellViewModelType] {
        return component
    }
    
    static func buildEither(second component: [CellViewModelType]) -> [CellViewModelType] {
        return component
    }
}

func build(@CellViewModelBuilder content: () -> [CellViewModelType]) -> [CellViewModelType] {
    return content()
}
