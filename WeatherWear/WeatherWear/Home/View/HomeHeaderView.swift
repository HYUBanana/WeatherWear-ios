//
//  HomeHeader.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/11.
//

import UIKit

final class HomeHeaderView: UICollectionReusableView {
    
    static let identifier = "HomeHeaderView"
    
    struct Metric {
        static let headerPadding: CGFloat = 10
    }
    
    struct Color {
        static let titleLabel = UIColor(red: 48, green: 48, blue: 48)
    }
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = Color.titleLabel
        $0.font = Font.titleLabel
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Metric.headerPadding)
        }
    }
}
