//
//  SettingViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/02.
//

import Foundation
import ReactorKit
import RxSwift
import CoreLocation

final class SettingViewReactor: Reactor {

    enum Action {
        case initialize
        case tapPlusButton(CLLocation)
        case tapAlertCell
    }

    enum Mutation {
        case setData(SettingViewControllerModel)
        case setAlertMessage(String)
    }

    struct State {
        var settingData: SettingViewControllerModel?
        var temperatureUnit: TemperatureName?
        var windUnit: WindSpeedUnit?
        var todayBriefing: OperationMode?
        var detail: OperationMode?
        @Pulse var alertMessage: String?
    }

    private let fetchUserSettingInteractor: FetchUserSettingUseCase
    private let addUserLocationInteractor: AddUserLocationUseCase

    private let fetchUserSettingPresenter: FetchUserSettingOutputPort

    let initialState = State()

    init(fetchUserSettingInteractor: FetchUserSettingInteractor, fetchUserSettingPresenter: FetchUserSettingOutputPort, addUserLocationInteractor: AddUserLocationInteractor) {
        self.fetchUserSettingInteractor = fetchUserSettingInteractor
        self.fetchUserSettingPresenter = fetchUserSettingPresenter
        self.addUserLocationInteractor = addUserLocationInteractor
    }

    func transform(action: Observable<Action>) -> Observable<Action> {
        let locationAction = LocationService.shared.locationObservable
            .compactMap({ $0 })
            .map {
                Action.tapPlusButton($0)
            }
        return Observable.merge(action, locationAction)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initialize:
            return Single.build { try await self.fetchUserSettingInteractor.execute() }
                .asObservable()
                .flatMap { [weak self] userSetting -> Observable<Mutation> in
                    let result = self?.fetchUserSettingPresenter.create(with: userSetting)
                    switch result {
                    case .success(let viewControllerModel as SettingViewControllerModel):
                        return .just(.setData(viewControllerModel))
                    case .failure(let error):
                        return .error(error)
                    default:
                        return .error(ErrorType.wrongViewControllerModel)
                    }
                }

        case .tapPlusButton(let location):
            return Single.build {
                try await self.addUserLocationInteractor.execute(with: location)
                let userSetting = try await self.fetchUserSettingInteractor.execute()
                let result = self.fetchUserSettingPresenter.create(with: userSetting)
                switch result {
                case .success(let viewControllerModel as SettingViewControllerModel):
                    return Mutation.setData(viewControllerModel)
                case .failure(let error):
                    throw error
                default:
                    throw ErrorType.wrongViewControllerModel
                }
            }
            .asObservable()

        case .tapAlertCell:
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
