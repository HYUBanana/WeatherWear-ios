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
        static let leftPadding: CGFloat = 10
        static let topPadding: CGFloat = 0
        static let bottomPadding: CGFloat = 10
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
    
    static func fittingSize(availableWidth: CGFloat, headerText: String) -> CGSize {
        let cell = HomeHeaderView()
        cell.configure(headerText: headerText)
        
        let targetSize = CGSize(width: availableWidth, height: UIView.layoutFittingCompressedSize.height)
        return cell.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func configure(headerText: String) {
        titleLabel.text = headerText
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.leftPadding)
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(Metric.topPadding)
            make.bottom.equalToSuperview().offset(-Metric.bottomPadding)
        }
    }
}