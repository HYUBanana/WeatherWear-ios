//
//  DetailView.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/13.
//

import UIKit

final class DetailView: UIView {
    struct Metric {
        static let collectionViewHorizontalPadding: CGFloat = 20
        static let collectionViewBottomPadding: CGFloat = 0
        
        static let collectionViewSectionTopPadding: CGFloat = 0
        static let collectionViewSectionHorizontalPadding: CGFloat = 0
        static let collectionViewSectionBottomPadding: CGFloat = 35
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
        self.backgroundColor = AppColor.background(.sky).color
    }
    
    private func addSubviews() {
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().offset(Metric.collectionViewHorizontalPadding)
            make.right.equalToSuperview().offset(-Metric.collectionViewHorizontalPadding)
            make.bottom.equalToSuperview().offset(-Metric.collectionViewBottomPadding)
        }
    }
}
