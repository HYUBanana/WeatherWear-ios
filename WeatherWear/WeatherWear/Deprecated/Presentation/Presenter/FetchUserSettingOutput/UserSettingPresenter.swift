//
//  UserSettingPresenter.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/23.
//

import Foundation

class UserSettingPresenter: FetchUserSettingOutputPort {
    func create(with userSetting: UserSetting) -> Result<ViewControllerModel, Error> {
        let locations = convertLocationToDisplayModel(with: userSetting.locations)
        let timeSchedule = timeToSchedule(departureTime: userSetting.departureTime, arrivalTime: userSetting.arrivalTime)
        let totalTime = timeToString(with: userSetting.totalTime)
        
        let unitOptions = [createOption(with: "온도", value: userSetting.temperatureUnit),
                           createOption(with: "바람", value: userSetting.windSpeedUnit)]
        let autoSortOptions = [createOption(with: "오늘의 브리핑", value: userSetting.todayBriefing),
                               createOption(with: "자세히", value: userSetting.detail)]
        
        let settingViewControllerModel = SettingViewControllerModel(locations: locations,
                                                                    timeSchedule: timeSchedule,
                                                                    totalTime: totalTime,
                                                                    unitOptions: unitOptions,
                                                                    autoSortOptions: autoSortOptions)
        
        return .success(settingViewControllerModel)
    }
}

extension UserSettingPresenter {
    private func getLocationString(_ location: Location) -> String {
        guard let locality = location.locality else { return "" }
        guard let subLocality = location.subLocality else { return locality }
        return locality + " " + subLocality
    }
    
    private func convertLocationToDisplayModel(with locations: [LocationInformation]?) -> [UserLocationDisplayModel]? {
        guard let locations = locations else { return nil }
        return locations.compactMap { location in
            let locationString = getLocationString(location.location)
            guard let time = getTime(with: location.location.timezone) else { return nil }
            guard let temperature = unitToString(location.temperature) else { return nil }
            let weather = getWeatherState(with: location.weather)
            
            let userLocationDisplayModel = UserLocationDisplayModel(location: locationString,
                                                                    time: time,
                                                                    temperature: temperature,
                                                                    weather: weather)
            return userLocationDisplayModel
        }
    }
    
    private func getTime(with timezone: TimeZone?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd일, HH시 mm분"
        dateFormatter.timeZone = timezone
        
        let localTime = dateFormatter.string(from: Date())
        return localTime
    }
    
    private func getWeatherState(with state: WeatherState) -> String {
        
        switch state {
        case .clear:
            return "맑음"
        case .cloudy:
            return "구름 조금"
        case .rain:
            return "비"
        case .unknown:
            return "미정"
        }
    }
    
    private func unitToString(_ unit: WeatherUnit) -> String? {
        guard let value = unit.value, let unit = unit.unit else { return nil }
        return String(Int(value)) + " " + unit
    }
 
    private func timeToString(with time: Time?) -> String {
        guard let time = time else { return "" }
        return String(format: "%02d", time.hour) + "시 " + String(format: "%02d", time.minute) + "분"
    }
    
    private func timeToSchedule(departureTime: Time?, arrivalTime: Time?) -> String {
        guard let departureTime = departureTime, let arrivalTime = arrivalTime else { return "시간을 설정해주세요." }
        
        let departure = timeToString(with: departureTime)
        let arrival = timeToString(with: arrivalTime)
        return "\(departure) 에 나가서,\n\(arrival) 에 돌아와요."
    }
    
    private func createOption<T: OptionEnumCollection>(with title: String, value: T) -> OptionDisplayModel {
        
        var optionCases: [String] = []
        let enumType = T.self
        for option in enumType.allCases.dropLast() {
            optionCases.append(option.rawValue)
        }
        let index = T.allCases.firstIndex(of: value) as! Int
        let name = title
        
        return OptionDisplayModel(optionName: name, optionCases: optionCases, selectedOption: index)
    }
}
