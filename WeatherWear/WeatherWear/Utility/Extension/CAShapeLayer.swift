//
//  CAShapeLayer.swift
//  WeatherWear
//
//  Created by 디해 on 2024/02/01.
//

import UIKit

extension CAShapeLayer {
    func animatePath(to newPath: CGPath) {
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = self.path
        animation.toValue = newPath
        animation.duration = 0.7
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        self.path = newPath
        self.add(animation, forKey: "pathAnimation")
    }
}
