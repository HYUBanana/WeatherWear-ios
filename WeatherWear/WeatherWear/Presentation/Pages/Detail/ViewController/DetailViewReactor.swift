//
//  DetailViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/04.
//

import Foundation
import ReactorKit
import RxSwift

final class DetailViewReactor: Reactor {
    
    enum Action {
        case viewDidLoad
    }
    
    enum Mutation {
        case setData(DetailData)
        
    }
    
    struct State {
        var detailData: DetailData?
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
            return self.serviceProvider.weatherService.getWeather()
                .compactMap { [weak self] weather in
                    self?.formatterProvider.detailViewDataFormatter.transform(weather)
                }
                .map { detailData in
                    .setData(detailData)
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setData(detailData):
            state.detailData = detailData
            return state
        }
    }
}
