//
//  DetailViewDataFormatterType.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/08.
//

protocol DetailViewDataFormatterType {
    func transform(_ weather: Weather) -> DetailData
}

