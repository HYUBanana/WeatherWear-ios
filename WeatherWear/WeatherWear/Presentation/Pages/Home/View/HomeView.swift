//
//  HomeView.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/05.
//

import UIKit

final class HomeView: UIView {
    struct Metric {
        static let mainWeatherImageViewTopPadding: CGFloat = 5
        
        static let collectionViewTopPadding: CGFloat = 30
        static let collectionViewHorizontalPadding: CGFloat = 20
        static let collectionViewBottomPadding: CGFloat = 0
        
        static let collectionViewHeaderTopPadding: CGFloat = 5
        static let collectionViewHeaderHorizontalPadding: CGFloat = 0
        static let collectionViewHeaderBottomPadding: CGFloat = 35
        
        static let cellVerticalPadding: CGFloat = 12
        static let cellHorizontalPadding: CGFloat = 12
    }
    
    struct Color {
        static let backgroundColor = UIColor(red: 220, green: 239, blue: 244)
    }
    
    struct Font {
        
    }
    
    let layout = UICollectionViewFlowLayout().then {
        $0.sectionInset = UIEdgeInsets(top: Metric.collectionViewHeaderTopPadding, left: Metric.collectionViewHeaderHorizontalPadding, bottom: Metric.collectionViewHeaderBottomPadding, right: Metric.collectionViewHeaderHorizontalPadding)
        
        $0.minimumLineSpacing = Metric.cellVerticalPadding
        $0.minimumInteritemSpacing = Metric.cellHorizontalPadding
        
//        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    
    let mainWeatherImageView = UIImageView(image: UIImage(named: "MainWeather")).then {
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
        self.backgroundColor = Color.backgroundColor
    }
    
    private func addSubviews() {
        addSubview(mainWeatherImageView)
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Metric.collectionViewTopPadding)
            make.left.equalToSuperview().offset(Metric.collectionViewHorizontalPadding)
            make.right.equalToSuperview().offset(-Metric.collectionViewHorizontalPadding)
            make.bottom.equalToSuperview().offset(-Metric.collectionViewBottomPadding)
        }
        
        mainWeatherImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Metric.mainWeatherImageViewTopPadding)
            make.right.equalToSuperview()
        }
    }
}
