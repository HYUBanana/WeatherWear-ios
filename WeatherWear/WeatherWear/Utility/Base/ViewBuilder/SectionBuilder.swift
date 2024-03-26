//
//  ViewModelBuilder.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/06.
//

import Foundation

@resultBuilder
struct SectionBuilder {
    static func buildBlock(_ components: [Section]...) -> [Section] {
        return Array(components.joined())
    }
    
    static func buildExpression(_ expression: Section) -> [Section] {
        return [expression]
    }
    
    static func buildArray(_ components: [[Section]]) -> [Section] {
        return Array(components.joined())
    }
    
    static func buildEither(first component: [Section]) -> [Section] {
        return component
    }
    
    static func buildEither(second component: [Section]) -> [Section] {
        return component
    }
    
    static func buildIf(_ element: [Section]?) -> [Section] { element ?? [] }
}

func buildSections(@SectionBuilder content: () -> [Section]) -> [Section] {
    return content()
}
