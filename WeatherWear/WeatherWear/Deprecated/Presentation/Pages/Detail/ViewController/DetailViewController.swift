//
//  DetailViewController.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/13.
//

import UIKit
import RxSwift
import RxRelay
import ReactorKit

class DetailViewController: BaseViewController<DetailView>, View {
    
    private let dataSource = BehaviorRelay<DataSource?>(value: nil)
    
    private lazy var adapter = CollectionViewAdapter(collectionView: contentView.collectionView,
                                                     dataSource: dataSource,
                                                     delegate: self)
    
    var disposeBag = DisposeBag()
    
    init(reactor: DetailViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = adapter
    }
    
    func bind(reactor: DetailViewReactor) {
        
        rx.viewDidLoad
            .map { Reactor.Action.initialize }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable()
            .compactMap { $0.detailData }
            .map { [weak self] in self?.makeDataSource(data: $0) }
            .bind(to: self.dataSource)
            .disposed(by: disposeBag)
    }
    
    private func makeDataSource(data: DetailViewControllerModel) -> DataSource {
        let cells = build {
            SpacingCellViewModel(spacing: 60)
            
            TextCellViewModel(text: data.timeLocation, font: AppFont.header(.H3(.bold)), color: AppColor.text(.primaryDarkText))
            SpacingCellViewModel(spacing: 13)
            TextCellViewModel(text: data.updateTime, font: AppFont.description(.D3(.semibold)), color: AppColor.text(.primaryDarkText))
            
            SpacingCellViewModel(spacing: 30)
            
            WeatherGraphCellViewModel(graphData: data.graph)
        }
        
        return DataSource(cells)
    }
}

extension DetailViewController: CollectionViewAdapterDelegate {
}
