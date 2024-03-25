//
//  HomeViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/31.
//

import Foundation
import ReactorKit
import RxSwift

final class HomeViewReactor: Reactor {
    
    enum Action {
        case viewDidLoad
        case toggleCharacter
    }
    
    enum Mutation {
        case setData(HomeData)
        case toggleCharacter
    }
    
    struct State {
        var homeData: HomeData?
        var showAdvice: Bool
    }
    
    let serviceProvider: ServiceProviderType
    let formatterProvider: FormatterProviderType
    let initialState = State(showAdvice: true)
    
    init(serviceProvider: ServiceProviderType, formatterProvider: FormatterProviderType) {
        self.serviceProvider = serviceProvider
        self.formatterProvider = formatterProvider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return self.serviceProvider.weatherService.getWeather()
                .compactMap { [weak self] weather in
                    self?.formatterProvider.homeViewDataFormatter.transform(weather)
                }
                .map { homeData in
                        .setData(homeData)
                }
        case .toggleCharacter:
            return .just(.toggleCharacter)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setData(homeData):
            state.homeData = homeData
            return state
            
        case .toggleCharacter:
            state.showAdvice = !state.showAdvice
            return state
        }
    }
}
