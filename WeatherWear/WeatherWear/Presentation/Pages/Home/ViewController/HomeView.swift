//
//  HomeView.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/05.
//

import UIKit

final class HomeView: UIView {
    struct Metric {
        static let mainWeatherImageSideLength: CGFloat = 300
        static let mainWeatherImageX: CGFloat = 200
        static let mainWeatherImageMinY: CGFloat = -50
        static let mainWeatherImageMaxY: CGFloat = 100
    }
    
    let refreshControl = AnimatedRefreshControl()
    
    lazy var collectionView = UICollectionView(frame: CGRectZero,
                                               collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
        $0.isPagingEnabled = true
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
        $0.refreshControl = self.refreshControl
    }
    
    let mainWeatherImageView = UIImageView(image: UIImage()).then {
        $0.alpha = 0.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
    }
    
    private func addSubviews() {
        addSubview(mainWeatherImageView)
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainWeatherImageView.frame = CGRect(x: Metric.mainWeatherImageX,
                                            y: Metric.mainWeatherImageMaxY,
                                            width: Metric.mainWeatherImageSideLength,
                                            height: Metric.mainWeatherImageSideLength)
    }
}

extension HomeView {
    func applyGradientBackground(with color: UIColor) {
        
        if (self.layer.sublayers?.filter { $0 is CAGradientLayer } == []) {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        guard let gradientLayer = self.layer.sublayers?[0] as? CAGradientLayer else { return }
        
        changeGradientColor(on: gradientLayer, to: [color.cgColor, UIColor.white.cgColor])
    }
    
    private func changeGradientColor(on layer: CAGradientLayer, to colors: [CGColor]) {
        
        let colorAnimation = CABasicAnimation(keyPath: "colors")
        colorAnimation.duration = 1
        colorAnimation.fromValue = layer.colors
        colorAnimation.toValue = colors
        colorAnimation.fillMode = .forwards
        colorAnimation.isRemovedOnCompletion = false
        
        layer.add(colorAnimation, forKey: "colorChange")
        layer.colors = colors
    }
}

extension HomeView {
    func moveMainWeatherImageView(currentOffset: CGFloat, maxScrollableHeight: CGFloat) {
        let movingRange = Metric.mainWeatherImageMaxY - Metric.mainWeatherImageMinY
        let newImagePositionY = (currentOffset / maxScrollableHeight) * movingRange
        UIView.animate(withDuration: 0) {
            self.mainWeatherImageView.frame.origin.y = Metric.mainWeatherImageMaxY - newImagePositionY
        }
    }
}
