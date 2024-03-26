//
//  FetchWeatherOutputPort.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/19.
//

protocol FetchTodayWeatherOutputPort: AnyObject {
    func create(with weather: Weather) -> Result<ViewControllerModel, Error>
}
