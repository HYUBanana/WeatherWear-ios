//
//  SettingSegmentedControl.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/23.
//

import UIKit

final class SettingSegmentedControl: UISegmentedControl {
    
    struct Color {
        static let blueColor = UIColor(red: 36, green: 160, blue: 237)
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.setDividerImage(UIImage(), forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        
        self.selectedSegmentTintColor = Color.blueColor
        
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.setTitleTextAttributes(selectedTextAttributes, for: .selected)
    }
    
}
