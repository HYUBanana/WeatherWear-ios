//
//  SettingView.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/22.
//

import UIKit
import Then

final class SettingView: UIView {
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        setup()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = AppColor.background(.setting).color
    }
    
    private func setupConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
