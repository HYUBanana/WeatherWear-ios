//
//  HomeViewDataFormatter.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/06.
//

protocol HomeViewDataFormatterType {
    func transform(_ weather: Weather) -> HomeData
}
