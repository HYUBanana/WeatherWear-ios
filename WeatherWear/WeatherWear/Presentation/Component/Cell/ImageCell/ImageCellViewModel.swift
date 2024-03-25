//
//  LogoCellViewModel.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/02.
//

import Foundation

final class ImageCellViewModel: CellViewModelType {
    var cellType: Sizeable.Type { return ImageCell.self }
    
    var cellIdentifier = "ImageCell"
    
    private var image: String
    
    init(image: String) {
        self.image = image
    }
    
    func bind(to cell: Sizeable) {
        guard let cell = cell as? ImageCell else { return }
        cell.configure(image: image, contentMode: .scaleAspectFit)
    }
}

