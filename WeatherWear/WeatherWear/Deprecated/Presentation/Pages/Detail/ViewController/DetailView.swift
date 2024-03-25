//
//  DetailView.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/13.
//

import UIKit

final class DetailView: UIView {
    
    let collectionView = UICollectionView(frame: CGRectZero,
                                          collectionViewLayout: UICollectionViewLayout())
    
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
            make.edges.equalToSuperview()
        }
    }
}
