//
//  Section.swift
//  WeatherWear
//
//  Created by 디해 on 2024/01/12.
//

import UIKit

class Section {
    var viewModels: [ViewModel]
    
    var numberOfItems: Int { viewModels.count }
    var sectionInsets: UIEdgeInsets
    var minimumInteritemSpacing: CGFloat
    var minimumLineSpacing: CGFloat
    var numberOfColumns: Int
    
    init(_ viewModels: [ViewModel],
         sectionInsets: UIEdgeInsets,
         minimumInteritemSpacing: CGFloat = 0,
         minimumLineSpacing: CGFloat = 0,
         numberOfColumns: Int) {
        self.viewModels = viewModels
        self.sectionInsets = sectionInsets
        self.numberOfColumns = numberOfColumns
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
    }
    
    func product(at index: Int) -> ViewModel {
        return viewModels[index]
    }
}
