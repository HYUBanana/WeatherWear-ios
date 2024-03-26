//
//  Adapter.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/27.
//

import UIKit
import RxSwift
import RxRelay

final class CollectionViewAdapter: NSObject {
    
    private let touchSubject = PublishSubject<ViewModel>()
    private let buttonTapSubject = PublishSubject<ViewModel>()
    
    weak var dataSource: DataSource? {
        dataSourceRelay.value
    }
    
    weak var delegate: Delegate?
    
    let dataSourceRelay = BehaviorRelay<DataSource?>(value: nil)
    
    var disposeBag = DisposeBag()
    
    private let collectionView: UICollectionView
    private var registeredCellIds = Set<String>()
    
    init(collectionView: UICollectionView, delegate: Delegate?) {
        self.collectionView = collectionView
        self.delegate = delegate
        
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        bind()
    }
    
    private func bind() {
        dataSourceRelay
            .compactMap({ $0 })
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] dataSource in
                guard let `self` = self else { return }
                self.registerIfNeeded(dataSource)
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func registerIfNeeded(_ dataSource: DataSource) {
        for section in dataSource.sections {
            for viewModel in section.viewModels where !(registeredCellIds.contains(viewModel.cellIdentifier)) {
                collectionView.register(viewModel.cellType, forCellWithReuseIdentifier: viewModel.cellIdentifier)
                registeredCellIds.insert(viewModel.cellIdentifier)
            }
        }
    }
}

extension CollectionViewAdapter: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.getSection(at: section).numberOfItems ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = dataSource?.getSection(at: indexPath.section).product(at: indexPath.item) else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.cellIdentifier, for: indexPath) as? Bindable else { return UICollectionViewCell() }
        
        cell.bind(with: viewModel)
        
        bindButtonIfNeeded(cell, viewModel)
        bindTouchableIfNeeded(cell, viewModel)
        
        return cell
    }
    
    private func bindTouchableIfNeeded(_ cell: UICollectionViewCell, _ viewModel: ViewModel) {
        guard let cell = cell as? Touchable else { return }
        cell.touch
            .map { _ in viewModel }
            .subscribe(onNext: { [weak self] viewModel in
                self?.touchSubject.onNext(viewModel)
            })
            .disposed(by: cell.disposeBag)
    }
    
    private func bindButtonIfNeeded(_ cell: UICollectionViewCell, _ viewModel: ViewModel) {
        guard let cell = cell as? ContainsButton else { return }
        cell.buttonTap
            .map { _ in viewModel }
            .subscribe(onNext: { [weak self] viewModel in
                self?.buttonTapSubject.onNext(viewModel)
            })
            .disposed(by: cell.disposeBag)
    }
}

extension CollectionViewAdapter: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScrolled(scrollView)
    }
}

extension CollectionViewAdapter: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let section = dataSource?.getSection(at: indexPath.section) else { return CGSizeZero }
        
        let viewModel = section.product(at: indexPath.item)
        let cell = viewModel.cellType.init()
        
        cell.bind(with: viewModel)
        
        let cellWidth = (collectionView.bounds.width - (section.sectionInsets.left + section.sectionInsets.right + section.minimumInteritemSpacing * CGFloat(section.numberOfColumns - 1))) / CGFloat(section.numberOfColumns) - 1
        
        let targetSize = CGSize(width: cellWidth, height: UIView.layoutFittingCompressedSize.height)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return dataSource?.getSection(at: section).sectionInsets ?? UIEdgeInsets()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return dataSource?.getSection(at: section).minimumLineSpacing ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return dataSource?.getSection(at: section).minimumInteritemSpacing ?? 0
    }
}

extension CollectionViewAdapter {
    var touch: Observable<ViewModel> {
        return touchSubject.asObservable()
    }

    var buttonTap: Observable<ViewModel> {
        return buttonTapSubject.asObservable()
    }
}
