//
//  BaseCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/07.
//

import UIKit
import RxSwift

class BaseCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
