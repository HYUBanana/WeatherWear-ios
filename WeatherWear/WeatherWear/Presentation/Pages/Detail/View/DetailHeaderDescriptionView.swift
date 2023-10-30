//
//  DetailHeaderDescriptionView.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/22.
//

import UIKit

final class DetailHeaderDescriptionView: UICollectionReusableView {
    
    static let identifier = "DetailHeaderDescriptionView"
    
    struct Metric {
        static let leftPadding: CGFloat = 10
        static let topPadding: CGFloat = 0
        static let bottomPadding: CGFloat = 10
        
        static let textSpacing: CGFloat = 5
    }
    
    struct Color {
        static let titleLabel = UIColor(red: 48, green: 48, blue: 48)
        static let descriptionLabel = UIColor(red: 91, green: 91, blue: 91)
    }
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 20, weight: .bold)
        static let descriptionLabel = UIFont.systemFont(ofSize: 14)
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = Color.titleLabel
        $0.font = Font.titleLabel
    }
    
    let spacingView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let descriptionLabel = UILabel().then {
        $0.textColor = Color.descriptionLabel
        $0.font = Font.descriptionLabel
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func fittingSize(availableWidth: CGFloat) -> CGSize {
        let cell = DetailHeaderDescriptionView()
        cell.configure()
        
        let targetSize = CGSize(width: availableWidth, height: UIView.layoutFittingCompressedSize.height)
        return cell.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func configure() {
        titleLabel.text = "체감 온도"
        descriptionLabel.text = "체감 온도 최대 34도.\n어제보다 2도 더 높으며, 건강에 위협적인 수준이에요."
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(spacingView)
        addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.leftPadding)
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(Metric.topPadding)
        }
        
        spacingView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(Metric.textSpacing)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.leftPadding)
            make.right.equalToSuperview()
            make.top.equalTo(spacingView.snp.bottom)
            make.bottom.equalToSuperview().offset(-Metric.bottomPadding)
        }
    }
}
