//
//  BaseCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/28.
//

import Foundation
import UIKit.UICollectionViewCell

protocol Sizeable: UICollectionViewCell {
    func fittingSize(availableWidth: CGFloat, with viewModel: CellViewModelType) -> CGSize
}
