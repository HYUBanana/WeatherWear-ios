//
//  SettingView.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/22.
//

import UIKit
import Then

final class SettingView: UIView {
    
    struct Metric {
        static let collectionViewTopPadding: CGFloat = 10
        static let collectionViewHorizontalPadding: CGFloat = 17
        static let collectionViewBottomPadding: CGFloat = 30
        
        static let cellSpacing: CGFloat = 15
        static let titlePadding: CGFloat = 15
    }
    
    struct Color {
        static let backgroundColor = UIColor(red: 240, green: 240, blue: 240)
    }
    
    let layout = UICollectionViewFlowLayout().then {
        $0.sectionInset = UIEdgeInsets(top: Metric.collectionViewTopPadding,
                                       left: Metric.collectionViewHorizontalPadding,
                                       bottom: Metric.collectionViewBottomPadding,
                                       right: Metric.collectionViewHorizontalPadding)
        $0.minimumLineSpacing = Metric.cellSpacing
    }
    
    let mainLogo = UIImageView(image: UIImage(named: "WeatherWearLogo"))
    
    lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        addSubview(mainLogo)
        
        setup()
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = Color.backgroundColor
    }
    
    private func setupConstraints() {
        mainLogo.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Metric.titlePadding)
            make.left.equalToSuperview().offset(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(mainLogo.snp.bottom).offset(Metric.titlePadding)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
