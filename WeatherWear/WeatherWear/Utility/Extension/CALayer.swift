//
//  CALayer.swift
//  WeatherWear
//
//  Created by 디해 on 2024/02/01.
//

import UIKit

extension CALayer {
    func animateOpacity(to opacity: Float) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = self.opacity
        animation.toValue = opacity
        animation.duration = 0.2
        
        self.opacity = opacity
        self.add(animation, forKey: "opacityAnimation")
    }
}
