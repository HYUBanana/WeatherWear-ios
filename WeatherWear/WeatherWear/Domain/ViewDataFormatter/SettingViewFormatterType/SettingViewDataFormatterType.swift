//
//  SettingViewDataFormatterType.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/07.
//

protocol SettingViewDataFormatterType {
    func transform(_ userSetting: UserSetting) -> SettingData
}
