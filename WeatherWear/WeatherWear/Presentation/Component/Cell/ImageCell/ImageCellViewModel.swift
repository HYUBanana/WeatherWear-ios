//
//  LogoCellViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/02.
//

import Foundation

final class ImageCellViewModel {

    var image: String
    
    init(image: String) {
        self.image = image
    }
}

extension ImageCellViewModel: ViewModel {
    var cellType: Bindable.Type { return ImageCell.self }
    var cellIdentifier: String { "ImageCell" }
}
