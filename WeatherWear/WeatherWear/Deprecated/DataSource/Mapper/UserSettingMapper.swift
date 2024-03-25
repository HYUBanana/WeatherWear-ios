//
//  UserSettingMapper.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/20.
//

import Foundation
import CoreLocation
import WeatherKit

class UserSettingMapper {
    func map(placemarks: [CLPlacemark]?,
             weathers: [CurrentWeather]?,
             departureTime: String?,
             arrivalTime: String?,
             temperatureUnit: String?,
             windUnit: String?,
             todayBriefing: String?,
             detail: String?) -> UserSetting {
        
        let locationInformations: [LocationInformation]?
        if let placemarks = placemarks, let weathers = weathers {
            locationInformations = zip(placemarks, weathers).map { (placemark, weather) in
                createLocationInformation(placemark: placemark, currentWeather: weather)
            }
        } else {
            locationInformations = nil
        }
        
        let totalTime = getTotalTime(arrivalTime: arrivalTime, departureTime: departureTime)
        let departureTime = stringToTime(time: departureTime)
        let arrivalTime = stringToTime(time: arrivalTime)
        let temperatureUnit = getTemperatureUnit(temperatureUnit)
        let windUnit = getWindUnit(windUnit)
        let todayBriefingOperationMode = getOperationMode(todayBriefing)
        let detailOperationMode = getOperationMode(detail)
        
        let userSetting = UserSetting(locations: locationInformations,
                                      departureTime: departureTime,
                                      arrivalTime: arrivalTime,
                                      totalTime: totalTime,
                                      temperatureUnit: temperatureUnit,
                                      windSpeedUnit: windUnit,
                                      todayBriefing: todayBriefingOperationMode,
                                      detail: detailOperationMode)
        return userSetting
    }
}

extension UserSettingMapper {
    private func stringToTime(time: String?) -> Time? {
        guard let time = time else { return nil }
        let timeComponents = time.split(separator: ":")
        guard timeComponents.count == 2, let hour = Int(timeComponents[0]), let minute = Int(timeComponents[1]) else { return nil }
        guard hour >= 0, hour <= 23, minute >= 0, minute <= 59 else { return nil }
        return Time(hour: hour, minute: minute)
    }
    
    private func getTotalTime(arrivalTime: String?, departureTime: String?) -> Time? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard let arrivalTime = arrivalTime, let departureTime = departureTime else { return nil }
        
        guard let arrivalDate = dateFormatter.date(from: arrivalTime), let departureDate = dateFormatter.date(from: departureTime) else { return nil }
        
        let interval = arrivalDate.timeIntervalSince(departureDate)
        
        let hour = Int(interval) / 3600
        let minute = Int(interval) % 3600 / 60
        
        return Time(hour: hour, minute: minute)
    }
    
    private func createLocationInformation(placemark: CLPlacemark, currentWeather: CurrentWeather) -> LocationInformation {
        
        let location = Location(locality: placemark.locality,
                                subLocality: placemark.subLocality,
                                administrativeArea: placemark.administrativeArea,
                                timezone: placemark.timeZone)
        let unit = currentWeather.temperature.unit.symbol
        let value = currentWeather.temperature.value
        let state = currentWeather.condition
        
        return LocationInformation(location: location,
                                   temperature: WeatherUnit(type: .temperature,
                                                            value: value, unit: unit),
                                   weather: convertConditionToState(condition: state))
    }
    
    private func convertConditionToState(condition: WeatherCondition) -> WeatherState {
        switch condition {
        case .clear, .mostlyClear:
            return .clear
        case .cloudy, .mostlyCloudy, .partlyCloudy:
            return .cloudy
        case .rain, .sunShowers:
            return .rain
        default:
            return .unknown
        }
    }
    
    private func getTemperatureUnit(_ temperatureUnit: String?) -> TemperatureName {
        switch temperatureUnit {
        case "°C":
            return .celsius
        case "°F":
            return .fahrenheit
        default:
            return .unknown
        }
    }
    
    private func getWindUnit(_ windUnit: String?) -> WindSpeedUnit {
        switch windUnit {
        case "m/s":
            return .metersPerSecond
        case "km/h":
            return .kilometersPerHour
        case "mph":
            return .milesPerHour
        default:
            return .unknown
        }
    }
    
    private func getOperationMode(_ operationMode: String?) -> OperationMode {
        switch operationMode {
        case "자동":
            return .automatic
        case "수동":
            return .manual
        default:
            return .unknown
        }
    }
}
