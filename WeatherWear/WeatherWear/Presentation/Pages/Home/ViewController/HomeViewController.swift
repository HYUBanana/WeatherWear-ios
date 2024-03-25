//
//  HomeViewController.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/05.
//

import UIKit
import RxSwift
import RxRelay
import ReactorKit

class HomeViewController: BaseViewController<HomeView>, View {
    
    private let dataSource = BehaviorRelay<CollectionViewAdapterDataSource?>(value: nil)
    
    private lazy var adapter = CollectionViewAdapter(collectionView: contentView.collectionView,
                                                     dataSource: dataSource,
                                                     delegate: self)
    
    var disposeBag = DisposeBag()
    
    init(reactor: HomeViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //_ = adapter
        
        adapter.rx.touch
            .filter { $0 is CharacterCellViewModel }
            .map { _ in Reactor.Action.toggleCharacter }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    func bind(reactor: HomeViewReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.state.asObservable().compactMap { $0.homeData },
            reactor.state.asObservable().map { $0.showAdvice })
        .map { [weak self] data, advice in
            self?.makeDataSource(data: data, showAdvice: advice)
        }
        .bind(to: self.dataSource)
        .disposed(by: disposeBag)
    }
    
    private func makeDataSource(data: HomeData, showAdvice: Bool) -> CollectionViewAdapterDataSource {
        
        let cells = build {
            SpacingCellViewModel(spacing: 30)
            
            TextCellViewModel(text: data.date,
                              font: AppFont.header(.H4(.semibold)),
                              color: AppColor.text(.tertiaryDarkText))
            SpacingCellViewModel(spacing: 5)
            TextCellViewModel(text: data.randomTitle,
                              font: AppFont.header(.H1(.bold)),
                              color: AppColor.text(.primaryDarkText))
            SpacingCellViewModel(spacing: 10)
            TextCellViewModel(text: data.weatherSummary,
                              font: AppFont.description(.D1(.semibold)),
                              color: AppColor.text(.primaryDarkText))
            
            SpacingCellViewModel(spacing: 30)
            
            CharacterCellViewModel(data: data, showAdvice: showAdvice)
            
            SpacingCellViewModel(spacing: 30)
            
            TextCellViewModel.header(text: "오늘의 브리핑")
            SpacingCellViewModel(spacing: 10)
            
            for climateFactor in data.climateFactor {
                BriefingCellViewModel(climateFactor: climateFactor)
                SpacingCellViewModel(spacing: 15)
            }
            
            SpacingCellViewModel(spacing: 15)
            
            TextCellViewModel.header(text: "생활 지수")
            SpacingCellViewModel(spacing: 15)
            
            for livingIndex in data.livingIndex {
                ComfortIndexCellViewModel(livingIndex: livingIndex)
            }
        }
        
        return DataSource(cells)
    }
}

extension HomeViewController: CollectionViewAdapterDelegate {
}

extension HomeViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.0) { [weak self] in
            self?.contentView.mainWeatherImageView.alpha = 1.0
        }
    }
}
