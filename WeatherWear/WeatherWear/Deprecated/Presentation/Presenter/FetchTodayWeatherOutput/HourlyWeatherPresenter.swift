//
//  DetailViewDataFormatter.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/08.
//

import Foundation

class HourlyWeatherPresenter: FetchTodayWeatherOutputPort {
    
    func create(with weather: Weather) -> Result<ViewControllerModel, Error> {
        
        let timeLocation = combineTimeLocationToString(time: weather.date, location: weather.location)
        let updateTime = getUpdateTimeString(updateTime: weather.date)
        guard let temperature = unitToString(weather.temperature),
              let highTemperature = getHighestUnitString(weather.temperature),
              let lowTemperature = getLowestUnitString(weather.temperature),
              let apparentTemperatureDescription = getDescription(weather.apparentTemperature),
              let graphData = createGraphData(with: weather)
        else { return .failure(ErrorType.noValue) }
        
        let detailViewControllerModel = DetailViewControllerModel(timeLocation: timeLocation,
                                                                  updateTime: updateTime,
                                                                  temperature: temperature,
                                                                  highestTemperature: highTemperature,
                                                                  lowestTemperature: lowTemperature,
                                                                  apparentTemperatureDescription: apparentTemperatureDescription,
                                                                  graph: graphData)
        return .success(detailViewControllerModel)
    }
}

extension HourlyWeatherPresenter {
    
    func combineTimeLocationToString(time: Date, location: Location) -> String {
        let time = dateToString(with: time)
        
        guard let locality = location.locality else { return "" }
        guard let subLocality = location.subLocality else { return locality }
        
        let location = locality + " " + subLocality
        return "\(time)\n\(location)."
    }
    
    func dateToString(with date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "d일 EEEE,"
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
    
    func getUpdateTimeString(updateTime: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "마지막 업데이트 HH시"
        let formattedDate = formatter.string(from: updateTime)
        return formattedDate
    }
    
    private func unitToString(_ unit: WeatherUnit) -> String? {
        guard let value = unit.value, let unit = unit.unit else { return nil }
        return String(Int(value)) + " " + unit
    }
    
    private func getHighestUnitString(_ unit: WeatherUnit) -> String? {
        guard let value = unit.todayHighestValue else { return nil }
        return String(Int(value)) + " " + "°"
    }
    
    private func getLowestUnitString(_ unit: WeatherUnit) -> String? {
        guard let value = unit.todayLowestValue else { return nil }
        return String(Int(value)) + " " + "°"
    }
    
    private func getDescription(_ unit: WeatherUnit) -> String? {
        guard case .apparentTemperature = unit.type else { return nil }
        guard let unitString = unitToString(unit) else { return nil }
        return "체감 온도 \(unitString)도.\n어제보다 2도 더 높으며, 건강에 위협적인 수준이에요."
    }
    
    private func timeToString(with date: Date, location: Location) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = location.timezone
        formatter.dateFormat = "HH:mm"
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
    
    private func getHour(with date: Date, location: Location) -> Int {
        let formatter = DateFormatter()
        formatter.timeZone = location.timezone
        formatter.dateFormat = "HH"
        let formattedDate = formatter.string(from: date)
        return Int(formattedDate)!
    }
    
    private func getMinute(with date: Date, location: Location) -> Int {
        let formatter = DateFormatter()
        formatter.timeZone = location.timezone
        formatter.dateFormat = "mm"
        let formattedDate = formatter.string(from: date)
        return Int(formattedDate)!
    }
    
    private func createGraphData(with weather: Weather) -> WeatherGraphDisplayModel? {
        let date = Date.now
        let dateString = timeToString(with: date, location: weather.location)
        let hour = getHour(with: date, location: weather.location)
        let minute = getMinute(with: date, location: weather.location)
        
        var hourlyWeatherGraphs: [HourlyWeatherGraphDisplayModel] = []
        
        guard let hourlyTemperature = weather.temperature.todayHourlyValue else { return nil }
        guard let hourlyCloudCover = weather.cloudCover.todayHourlyValue else { return nil }
        guard let hourlyRainfall = weather.precipitationAmount.todayHourlyValue else { return nil }
        
        for index in 0..<hourlyTemperature.count {
            let time = String(format: "%02d", index)
            let temperature = Int(hourlyTemperature[index])
            let cloudCover = Int(hourlyCloudCover[index])
            let rainfall = hourlyRainfall[index]
            
            let hourlyGraph = HourlyWeatherGraphDisplayModel(cloudCover: cloudCover,
                                                             day: time,
                                                             temperature: temperature,
                                                             rainfall: rainfall)
            hourlyWeatherGraphs.append(hourlyGraph)
        }
        
        guard let highestTemperature = weather.temperature.todayHighestValue else { return nil }
        guard let lowestTemperature = weather.temperature.todayLowestValue else { return nil }
        
        guard let highestTemperatureString = getHighestUnitString(weather.temperature) else { return nil }
        guard let lowestTemperatureString = getLowestUnitString(weather.temperature) else { return nil }
        
        let rangeValue = 5
        let highestTemperatureRange = Int(highestTemperature) + rangeValue
        let lowestTemperatureRange = Int(lowestTemperature) - rangeValue
        
        guard let rainFallRange = weather.precipitationAmount.todayHighestValue else { return nil }
        
        let weatherGraph = WeatherGraphDisplayModel(time: date,
                                                    timeString: dateString,
                                                    hour: hour,
                                                    minute: minute,
                                                    highestTemperatureRange: highestTemperatureRange,
                                                    lowestTemperatureRange: lowestTemperatureRange,
                                                    highestRainfallRange: rainFallRange, highestTemperatureString: highestTemperatureString,
                                                    lowestTemperatureString: lowestTemperatureString,
                                                    hourlyWeather: hourlyWeatherGraphs)
        
        return weatherGraph
    }
}
