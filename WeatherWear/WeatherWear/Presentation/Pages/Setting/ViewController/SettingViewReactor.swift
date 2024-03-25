//
//  SettingViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/02.
//

import Foundation
import ReactorKit
import RxSwift

final class SettingViewReactor: Reactor {
    
    enum Action {
        case viewDidLoad
        case addLocation
        case showAlert
    }
    
    enum Mutation {
        case setData(SettingData)
        case setAlertMessage(String)
    }
    
    struct State {
        var settingData: SettingData?
        @Pulse var alertMessage: String?
    }
    
    let serviceProvider: ServiceProviderType
    let formatterProvider: FormatterProviderType
    let initialState = State()
    
    init(serviceProvider: ServiceProviderType, formatterProvider: FormatterProviderType) {
        self.serviceProvider = serviceProvider
        self.formatterProvider = formatterProvider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return self.serviceProvider.userSettingService.getUserSetting()
                .compactMap { [weak self] userSetting in
                    self?.formatterProvider.settingViewDataFormatter.transform(userSetting)
                }
                .map { settingData in
                        .setData(settingData)
                }
            
        case .addLocation:
            return self.serviceProvider.userSettingService.addLocation(location: "장소",
                                                                       time: "시간",
                                                                       temperature: 20,
                                                                       weather: "날씨조음")
                .compactMap { [weak self] userSetting in
                    self?.formatterProvider.settingViewDataFormatter.transform(userSetting)
                }
                .map { settingData in
                        .setData(settingData)
                }
            
        case .showAlert:
            return .just(Mutation.setAlertMessage("대충 시간 설정하는 화면"))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setData(settingData):
            state.settingData = settingData
            
        case let .setAlertMessage(message):
            state.alertMessage = message
        }
        
        return state
    }
}
