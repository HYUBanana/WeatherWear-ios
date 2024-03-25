//
//  CircleView.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/18.
//

import UIKit

class CircleView: UIView {

    let color: UIColor

    init(frame: CGRect = CGRectZero, color: UIColor) {
        self.color = color
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
    
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        
        let radius = min(rect.width, rect.height) / 2

        context.addArc(center: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        context.fillPath()
    }
}
