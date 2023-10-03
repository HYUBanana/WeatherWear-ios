//
//  SettingSegmentedControl.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/23.
//

import UIKit

final class SettingSegmentedControl: UISegmentedControl {
    
    struct Color {
        static let blueColor = UIColor(red: 36.0 / 255.0,
                                       green: 160.0 / 255.0,
                                       blue: 237.0 / 255.0,
                                       alpha: 1.0)
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
