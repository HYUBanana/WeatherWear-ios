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
        case initialize
        case toggleCharacter
        case refresh
        case tapGraphType(GraphType)
    }
    
    enum Mutation {
        case setData(Weather)
        case toggleCharacter
        case changeGraphType(GraphType)
    }
    
    struct State {
        var weather: Weather?
        var showAdvice: Bool
        var graphType: GraphType
    }
    
    let provider: RepositoryProviderType
    let initialState = State(showAdvice: true,
                             graphType: .all)
    
    init(provider: RepositoryProviderType) {
        self.provider = provider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initialize, .refresh:
            return provider.weatherRepository.fetchCurrentWeather()
                .map { weather in
                    Mutation.setData(weather)
                }
            
        case .toggleCharacter:
            return .just(.toggleCharacter)
            
        case let .tapGraphType(graphType):
            return .just(.changeGraphType(graphType))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setData(weather):
            state.weather = weather
            return state
            
        case .toggleCharacter:
            state.showAdvice = !state.showAdvice
            return state
            
        case let .changeGraphType(newGraphType):
            let previousGraphType = state.graphType
            if previousGraphType == newGraphType {
                state.graphType = .all
            }
            else if newGraphType != .unknown {
                state.graphType = newGraphType
            }
            return state
        }
    }
}
