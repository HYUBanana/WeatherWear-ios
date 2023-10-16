//
//  TriangleView.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/06.
//

import UIKit

final class TriangleView: UIView {
    
    var color: UIColor
    var cornerRadius: CGFloat
    
    init(frame: CGRect = CGRectZero, color: UIColor = .black, cornerRadius: CGFloat = 0) {
        self.color = color
        self.cornerRadius = cornerRadius
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let triangle = CAShapeLayer()
        triangle.fillColor = color.cgColor
        triangle.path = roundedTriangle()
        triangle.position = CGPoint(x: 0, y: 0)
        
        self.layer.addSublayer(triangle)
    }
    
    func roundedTriangle() -> CGPath {
        let widthHeight = bounds.size.height
        let point1 = CGPoint(x: widthHeight/2, y: 0)
        let point2 = CGPoint(x: widthHeight, y: widthHeight)
        let point3 =  CGPoint(x: 0, y: widthHeight)
        
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: 0, y: widthHeight))
        path.addArc(tangent1End: point1, tangent2End: point2, radius: cornerRadius)
        path.addArc(tangent1End: point2, tangent2End: point3, radius: cornerRadius)
        path.addArc(tangent1End: point3, tangent2End: point1, radius: cornerRadius)
        path.closeSubpath()
        return path
    }
}
