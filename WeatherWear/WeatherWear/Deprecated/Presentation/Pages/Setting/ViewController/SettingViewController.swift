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
import CoreLocation

class SettingViewController: BaseViewController<SettingView>, View {
    
    private let dataSource = BehaviorRelay<DataSource?>(value: nil)
    
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
        
        adapter.rx.touch
            .filter { $0 is UserTimeCellViewModel }
            .map { _ in Reactor.Action.tapAlertCell }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
        
        adapter.rx.buttonTap
            .filter { $0 is TextPlusButtonViewModel }
            .map { _ in Reactor.Action.tapPlusButton(CLLocation(latitude: 40, longitude: 40)) }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    func bind(reactor: SettingViewReactor) {
        
        rx.viewDidLoad
            .map { Reactor.Action.initialize }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
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
    
    private func makeDataSource(data: SettingViewControllerModel) -> DataSource {
        let cells = build {
            ImageCellViewModel(image: "WeatherWearLogo")
            SpacingCellViewModel(spacing: 30)
            TextPlusButtonViewModel.header(text: "위치")
            
            SpacingCellViewModel(spacing: 15)
            
            if let locations = data.locations {
                for (index, location) in locations.enumerated() {
                    LocationCellViewModel(location: location)
                    if index < locations.count - 1 {
                        SpacingCellViewModel(spacing: 15)
                    }
                }
            } else {
                TextCellViewModel(text: "아직 설정된 위치가 없어요.", font: AppFont.description(.D1(.semibold)), color: AppColor.text(.primaryDarkText))
            }
            
            SpacingCellViewModel(spacing: 30)
            
            TextCellViewModel.header(text: "외출 시간")
            SpacingCellViewModel(spacing: 15)
            UserTimeCellViewModel(timeSchedule: data.timeSchedule, totalTime: data.totalTime)
            
            SpacingCellViewModel(spacing: 30)
            
            TextCellViewModel.header(text: "단위")
            SpacingCellViewModel(spacing: 15)
            OptionCellViewModel(options: data.unitOptions)
            
            SpacingCellViewModel(spacing: 30)
            
            TextCellViewModel.header(text: "자동 정렬")
            SpacingCellViewModel(spacing: 7)
            TextCellViewModel.headerDescription(text: "자동 정렬이 설정된 경우,\n날짜 정보를 중요도 순으로 정렬해 보여드려요.")
            SpacingCellViewModel(spacing: 15)
            OptionCellViewModel(options: data.autoSortOptions)
        }
        
        return DataSource(cells)
    }
}


extension SettingViewController: CollectionViewAdapterDelegate {
}
