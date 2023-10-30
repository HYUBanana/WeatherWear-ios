//
//  DetailView.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/13.
//

import UIKit

final class DetailView: UIView {
    struct Metric {
        static let collectionViewTopPadding: CGFloat = 0
        static let collectionViewHorizontalPadding: CGFloat = 20
        static let collectionViewBottomPadding: CGFloat = 0
        
        static let cellVerticalSpacing: CGFloat = 30
    }
    
    struct Color {
        static let backgroundColor = UIColor(red: 220, green: 239, blue: 244)
    }
    
    struct Font {
        
    }
    
    let layout = UICollectionViewFlowLayout()
    
    lazy var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
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
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Metric.collectionViewTopPadding)
            make.left.equalToSuperview().offset(Metric.collectionViewHorizontalPadding)
            make.right.equalToSuperview().offset(-Metric.collectionViewHorizontalPadding)
            make.bottom.equalToSuperview().offset(-Metric.collectionViewBottomPadding)
        }
    }
}
