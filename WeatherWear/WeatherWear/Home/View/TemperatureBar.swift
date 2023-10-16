//
//  TemperatureBar.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/06.
//

import UIKit

final class TemperatureBar: UIView {
    
    struct Metric {
        static let cornerRadius: CGFloat = 2
    }
    
    let gradientLayer = CAGradientLayer().then {
        $0.colors = [
            UIColor(red: 0, green: 178, blue: 255).cgColor,
            UIColor(red: 143, green: 255, blue: 0).cgColor,
            UIColor(red: 250, green: 255, blue: 0).cgColor,
            UIColor(red: 255, green: 92, blue: 0).cgColor
                ]
        $0.startPoint = CGPoint(x: 0, y: 0.5)
        $0.endPoint = CGPoint(x: 1, y: 0.5)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
        self.layer.cornerRadius = Metric.cornerRadius
        self.layer.masksToBounds = true
    }
}
