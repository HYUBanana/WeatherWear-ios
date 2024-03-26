//
//  AdapterDataSource.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/31.
//

import Foundation
import UIKit.UICollectionView

class DataSource {
    let sections: [Section]
    
    init(_ sections: [Section]) {
        self.sections = sections
    }
    
    var numberOfSections: Int { sections.count }

    func getSection(at sectionIndex: Int) -> Section {
        return sections[sectionIndex]
    }
}
