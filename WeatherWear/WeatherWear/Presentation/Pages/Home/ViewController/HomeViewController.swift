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
    
    private lazy var adapter = CollectionViewAdapter(collectionView: contentView.collectionView,
                                                     delegate: self)
    
    var disposeBag = DisposeBag()
    
    init(reactor: HomeViewReactor) {
        super.init()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adapter.rx.touch
            .filter { $0 is CharacterCellViewModel }
            .map { _ in Reactor.Action.toggleCharacter }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
        
        adapter.rx.touch
            .filter { $0 is BriefingCellViewModel }
            .map { viewModel in
                let viewModel = viewModel as! BriefingCellViewModel
                return Reactor.Action.tapGraphType(viewModel.data.graphType)
            }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
        
        contentView.refreshControl.rx.controlEvent(.valueChanged)
            .asObservable()
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    func bind(reactor: HomeViewReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.initialize }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.weather }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] weather in
                self?.contentView.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.weather }
            .map { UIImage(named: $0.weatherState.image) }
            .bind(to: contentView.mainWeatherImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.weather }
            .map { $0.weatherState.color.color }
            .subscribe(onNext: { [weak self] color in
                self?.contentView.applyGradientBackground(with: color)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.state.compactMap { $0.weather },
            reactor.state.map { $0.showAdvice },
            reactor.state.map { $0.graphType }
        )
        .flatMapLatest({ [weak self] weather, advice, graphType -> Observable<DataSource> in
            guard let `self` = self else { return .empty() }
            return self.makeDataSource(weather: weather,
                                       showAdvice: advice,
                                       graphType: graphType)
        })
        .bind(to: self.adapter.dataSourceRelay)
        .disposed(by: disposeBag)
    }
    
    private func makeDataSource(weather: Weather,
                                showAdvice: Bool,
                                graphType: GraphType) -> Observable<DataSource> {
        
        let sections = buildSections {
            
            Section(makeHeaderSectionViewModels(weather: weather),
                    sectionInsets: UIEdgeInsets(top: view.safeAreaInsets.top + 30,
                                                left: 25,
                                                bottom: 0,
                                                right: 25),
                    numberOfColumns: 1)
            
            Section(makeCharacterSectionViewModels(weather: weather,
                                                  showAdvice: showAdvice),
                    sectionInsets: UIEdgeInsets(top: 50,
                                                left: 15,
                                                bottom: 0,
                                                right: 15),
                    numberOfColumns: 1)
            
            Section(makeGraphSectionViewModels(weather: weather,
                                               graphType: graphType),
                    sectionInsets: UIEdgeInsets(top: view.safeAreaInsets.top,
                                                left: 15,
                                                bottom: 0,
                                                right: 15),
                    numberOfColumns: 1)
            
            Section(makeComfortIndexSectionViewModels(weather: weather),
                    sectionInsets: UIEdgeInsets(top: 30,
                                                left: 15,
                                                bottom: view.safeAreaInsets.bottom,
                                                right: 15),
                    minimumInteritemSpacing: 15,
                    minimumLineSpacing: 15,
                    numberOfColumns: 2)
        }
        
        return .just(DataSource(sections))
    }
}

extension HomeViewController {
    func makeHeaderSectionViewModels(weather: Weather) -> [ViewModel] {
        
        buildViewModels {
            TextCellViewModel(text: weather.date.toMonthDayWeekdayString(timeZone: weather.location.timezone),
                              font: AppFont.header(.H5(.semibold)),
                              color: AppColor.text(.tertiaryDarkText))
            SpacingCellViewModel(spacing: 5)
            TextCellViewModel(text: weather.weatherState.title,
                              font: AppFont.header(.H1(.bold)),
                              color: AppColor.text(.primaryDarkText))
            SpacingCellViewModel(spacing: 10)
            TextCellViewModel(text: weather.weatherSummary,
                              font: AppFont.description(.D1(.semibold)),
                              color: AppColor.text(.primaryDarkText))
        }
    }
    
    func makeCharacterSectionViewModels(weather: Weather, showAdvice: Bool) -> [ViewModel] {
        let characterCellData = CharacterCellData(weather: weather)
        
        return buildViewModels {
            CharacterCellViewModel(data: characterCellData,
                                   showAdvice: showAdvice)
            SpacingCellViewModel(spacing: 20)
            ImageCellViewModel(image: "Bracket")
            SpacingCellViewModel(spacing: 100)
        }
    }
    
    func makeGraphSectionViewModels(weather: Weather, graphType: GraphType) -> [ViewModel] {
        let weatherGraphCellData = WeatherGraphCellData(weather: weather)
        
        let briefingCellDatas = [BriefingCellData(unit: weather.apparentTemperature),
                                 BriefingCellData(unit: weather.uvIndex),
                                 BriefingCellData(unit: weather.humidity),
                                 BriefingCellData(unit: weather.fineDust),
                                 BriefingCellData(unit: weather.wind),
                                 BriefingCellData(unit: weather.precipitationAmount)]
        
        return buildViewModels {
            WeatherGraphCellViewModel(data: weatherGraphCellData, graphType: graphType)
            SpacingCellViewModel(spacing: 17)
            for (index, model) in briefingCellDatas.compactMap{ $0 }.enumerated() {
                BriefingCellViewModel(data: model)
                if index < briefingCellDatas.count - 1 {
                    SpacingCellViewModel(spacing: 17)
                }
            }
        }
    }
    
    func makeComfortIndexSectionViewModels(weather: Weather) -> [ViewModel] {
        let comfortIndexCellDatas = [ComfortIndexCellData(unit: weather.comfort),
                                     ComfortIndexCellData(unit: weather.laundry),
                                     ComfortIndexCellData(unit: weather.carWash),
                                     ComfortIndexCellData(unit: weather.pollen)]
        
        return buildViewModels {
            for data in comfortIndexCellDatas.compactMap{ $0 } {
                ComfortIndexCellViewModel(data: data)
            }
        }
    }
}

extension HomeViewController: Delegate {
    func didScrolled(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y + scrollView.adjustedContentInset.top
        let maxScrollableHeight = scrollView.contentSize.height - scrollView.bounds.height
        contentView.moveMainWeatherImageView(currentOffset: yOffset,
                                             maxScrollableHeight: maxScrollableHeight)
    }
}

extension HomeViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1.0) { [weak self] in
            self?.contentView.mainWeatherImageView.alpha = 1.0
        }
    }
}
