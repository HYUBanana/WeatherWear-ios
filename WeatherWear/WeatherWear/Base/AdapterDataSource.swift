//
//  AdapterDataSource.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/31.
//

import Foundation
import UIKit.UICollectionView

class DataSource: CollectionViewAdapterDataSource {

    private var viewModels: [CellViewModelType]

    init(_ viewModels: [CellViewModelType]) {
        self.viewModels = viewModels
    }
    
    var numberOfItems: Int { viewModels.count }

    func product(at index: Int) -> CellViewModelType {
        return viewModels[index]
    }
    
    func register(to collectionView: UICollectionView) {
        for viewModel in viewModels {
            collectionView.register(viewModel.cellType, forCellWithReuseIdentifier: viewModel.cellIdentifier)
        }
    }
}
