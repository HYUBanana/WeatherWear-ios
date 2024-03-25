//
//  Adapter.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/27.
//

import UIKit
import RxSwift
import RxRelay

protocol CollectionViewAdapterDataSource: AnyObject {
    var numberOfItems: Int { get }
    func product(at index: Int) -> any CellViewModelType
    func register(to collectionView: UICollectionView)
}

protocol CollectionViewAdapterDelegate: AnyObject {
}

final class CollectionViewAdapter: NSObject {
    
    private let touchSubject = PublishSubject<CellViewModelType>()
    var touch: Observable<CellViewModelType> {
        return touchSubject.asObservable()
    }
    
    private let buttonTapSubject = PublishSubject<CellViewModelType>()
    var buttonTap: Observable<CellViewModelType> {
        return buttonTapSubject.asObservable()
    }
    
    
    private let minimumLineSpacing: CGFloat = 0
    private let minimumInteritemSpacing: CGFloat = 15
    
    weak var dataSource: CollectionViewAdapterDataSource?
    weak var delegate: CollectionViewAdapterDelegate?
    
    var disposeBag = DisposeBag()
    
    private var collectionViewSectionTopPadding: CGFloat = 0
    private var collectionViewSectionHorizontalPadding: CGFloat = 0
    private var collectionViewSectionBottomPadding: CGFloat = 35
    private var sectionInset: UIEdgeInsets { UIEdgeInsets(top: collectionViewSectionTopPadding, left: collectionViewSectionHorizontalPadding, bottom: collectionViewSectionBottomPadding, right: collectionViewSectionHorizontalPadding) }
    
    init(collectionView: UICollectionView, dataSource: BehaviorRelay<CollectionViewAdapterDataSource?>, delegate: CollectionViewAdapterDelegate?) {
        super.init()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = minimumLineSpacing
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.dataSource = self
        collectionView.delegate = self
        self.delegate = delegate
        
        bind(dataSource: dataSource, to: collectionView)
    }
    
    private func bind(dataSource: BehaviorRelay<CollectionViewAdapterDataSource?>, to collectionView: UICollectionView) {
        dataSource
            .compactMap({ $0 })
            .subscribe(onNext: { dataSource in
                self.dataSource = dataSource
                dataSource.register(to: collectionView)
                collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension CollectionViewAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = dataSource?.product(at: indexPath.item) else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.cellIdentifier, for: indexPath)
        
        if let cell = cell as? Sizeable {
            viewModel.bind(to: cell)
        }
        
        if let cell = cell as? Touchable {
            cell.touch
                .map { _ in viewModel }
                .subscribe(onNext: { [weak self] viewModel in
                    self?.touchSubject.onNext(viewModel)
                })
                .disposed(by: cell.disposeBag)
        }
        
        if let cell = cell as? ContainsButton {
            cell.buttonTap
                .map { _ in viewModel }
                .subscribe(onNext: { [weak self] viewModel in
                    self?.buttonTapSubject.onNext(viewModel)
                })
                .disposed(by: cell.disposeBag)
        }
        
        return cell
    }
}

extension CollectionViewAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension CollectionViewAdapter: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let viewModel = dataSource?.product(at: indexPath.item) else { return CGSizeZero }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.cellIdentifier, for: indexPath)
        
        if let cell = cell as? Sizeable {
            return cell.fittingSize(availableWidth: collectionView.bounds.width, with: viewModel)
        }
        
        return CGSizeZero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
}

extension Reactive where Base: CollectionViewAdapter {
    var touch: Observable<CellViewModelType> {
        return base.touch
    }
    
    var buttonTap: Observable<CellViewModelType> {
        return base.buttonTap
    }
}
