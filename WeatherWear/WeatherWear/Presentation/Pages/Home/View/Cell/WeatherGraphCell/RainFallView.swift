//
//  RainFallView.swift
//  WeatherWear
//
//  Created by 디해 on 2024/01/30.
//

import UIKit

extension WeatherGraphCell {
    final class RainFallView: UIView {
        struct Metric {
            static let cornerRadius: CGFloat = 2.5
        }

        override init(frame: CGRect) {
            super.init(frame: frame)

            self.layer.cornerRadius = Metric.cornerRadius
            self.backgroundColor = AppColor.graph(.rainFallBlue).color
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
