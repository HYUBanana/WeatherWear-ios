//
//  FetchUserSettingOutputPort.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/23.
//

protocol FetchUserSettingOutputPort: AnyObject {
    func create(with userSetting: UserSetting) -> Result<ViewControllerModel, Error>
}
