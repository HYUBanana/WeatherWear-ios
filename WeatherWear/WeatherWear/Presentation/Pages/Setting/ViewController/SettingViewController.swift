//
//  SettingViewController.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/22.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import ReactorKit

class SettingViewController: BaseViewController<SettingView>, View {
    
    private let dataSource = BehaviorRelay<CollectionViewAdapterDataSource?>(value: nil)
    
    private lazy var adapter = CollectionViewAdapter(collectionView: contentView.collectionView,
                                                     dataSource: dataSource,
                                                     delegate: self)
    
    var disposeBag = DisposeBag()
    
    init(reactor: SettingViewReactor) {
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
            .filter { $0 is UserTimeCellViewModel }
            .map { _ in Reactor.Action.showAlert }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
        
        adapter.rx.buttonTap
            .filter { $0 is TextCellViewModel }
            .map { _ in Reactor.Action.addLocation }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    func bind(reactor: SettingViewReactor) {
        
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
//        adapter.rx.buttonTap
//            .filter { $0 is TextCellViewModel }
//            .map { _ in Reactor.Action.addLocation }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
        
        reactor.state.asObservable()
            .compactMap { $0.settingData }
            .distinctUntilChanged()
            .map { [weak self] in self?.makeDataSource(data: $0) }
            .bind(to: self.dataSource)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$alertMessage)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] message in
                let alertController = UIAlertController(title: nil,
                                                        message: message,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK",
                                                        style: .default,
                                                        handler: nil))
                self?.present(alertController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func makeDataSource(data: SettingData) -> CollectionViewAdapterDataSource {
        let cells = build {
            ImageCellViewModel(image: "WeatherWearLogo")
            SpacingCellViewModel(spacing: 30)
            TextPlusButtonViewModel.header(text: "위치")
            
            SpacingCellViewModel(spacing: 15)
            
            for location in data.locations {
                LocationCellViewModel(location: location)
                SpacingCellViewModel(spacing: 15)
            }
            
            SpacingCellViewModel(spacing: 15)
            
            TextCellViewModel.header(text: "외출 시간")
            SpacingCellViewModel(spacing: 15)
            UserTimeCellViewModel(timeSchedule: data.timeSchedule, totalTime: data.totalTime)
            
            SpacingCellViewModel(spacing: 30)
            
            TextCellViewModel.header(text: "단위")
            SpacingCellViewModel(spacing: 15)
            OptionCellViewModel(rows: [("온도", data.temperatureUnit),
                                       ("바람", data.windSpeedUnit)])
            
            SpacingCellViewModel(spacing: 30)
            
            TextCellViewModel.header(text: "자동 정렬")
            SpacingCellViewModel(spacing: 7)
            TextCellViewModel.headerDescription(text: "자동 정렬이 설정된 경우,\n날짜 정보를 중요도 순으로 정렬해 보여드려요.")
            SpacingCellViewModel(spacing: 15)
            OptionCellViewModel(rows: [("오늘의 브리핑", data.todayBriefing),
                                       ("자세히", data.detail)])
        }
        
        return DataSource(cells)
    }
}


extension SettingViewController: CollectionViewAdapterDelegate {
}

extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
}
