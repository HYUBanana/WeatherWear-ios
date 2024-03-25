//
//  MockSettingViewDataFormatter.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/07.
//

import Foundation

class MockSettingViewDataFormatter: SettingViewDataFormatterType {
    func transform(_ userSetting: UserSetting) -> SettingData {
        SettingData(locations: makeUserLocations(with: userSetting.locations),
                    timeSchedule: timeToSchedule(departureTime: userSetting.departureTime, arrivalTime: userSetting.arrivalTime),
                    totalTime: timeToString(with: userSetting.totalTime),
                    temperatureUnit: TemperatureUnit.allCases.map { $0.rawValue },
                    selectedTemperatureUnit: userSetting.temperatureUnit.rawValue,
                    windSpeedUnit: WindSpeedUnit.allCases.map { $0.rawValue },
                    selectedWindSpeedUnit: userSetting.windSpeedUnit.rawValue,
                    todayBriefing: OperationMode.allCases.map { $0.rawValue },
                    selectedTodayBriefing: userSetting.todayBriefing.rawValue,
                    detail: OperationMode.allCases.map { $0.rawValue },
                    selectedDetail: userSetting.detail.rawValue)
    }
    
    private func makeUserLocations(with locations: [Location]) -> [UserLocation] {
        locations.map { location in
            UserLocation(location: location.location,
                         time: location.time,
                         temperature: String(location.temperature),
                         weather: location.weather)
        }
    }
    
    private func timeToString(with time: Time) -> String {
        String(format: "%02d", time.hour) + "시 " + String(format: "%02d", time.minute) + "분"
    }
    
    private func timeToSchedule(departureTime: Time, arrivalTime: Time) -> String {
        let departure = timeToString(with: departureTime)
        let arrival = timeToString(with: arrivalTime)
        return "\(departure) 에 나가서,\n\(arrival) 에 돌아와요."
    }
}
