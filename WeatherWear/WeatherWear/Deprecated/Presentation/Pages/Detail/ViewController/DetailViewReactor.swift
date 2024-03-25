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
        case initialize
    }
    
    enum Mutation {
        case setData(DetailViewControllerModel)
        
    }
    
    struct State {
        var detailData: DetailViewControllerModel?
    }
    
    private let fetchTodayWeatherInteractor: FetchTodayWeatherUseCase
    private let fetchTodayWeatherPresenter: FetchTodayWeatherOutputPort
    
    
    let initialState = State()
    
    init(fetchTodayWeatherInteractor: FetchTodayWeatherUseCase, fetchTodayWeatherPresenter: FetchTodayWeatherOutputPort) {
        self.fetchTodayWeatherInteractor = fetchTodayWeatherInteractor
        self.fetchTodayWeatherPresenter = fetchTodayWeatherPresenter
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initialize:
            return self.fetchTodayWeatherInteractor.execute()
                .asObservable()
                .flatMap { weather -> Observable<Mutation> in
                    let result = self.fetchTodayWeatherPresenter.create(with: weather)
                    switch result {
                    case .success(let viewControllerModel as DetailViewControllerModel):
                        return .just(.setData(viewControllerModel))
                    case .failure(let error):
                        return .error(error)
                    default:
                        return .error(ErrorType.wrongViewControllerModel)
                    }
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
