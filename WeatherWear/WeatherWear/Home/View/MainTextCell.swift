//
//  MainTextCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/05.
//

import UIKit

final class MainTextCell: UICollectionViewCell {
    
    static let identifier = "MainTextCell"
    
    struct Metric {
        static let mainStackViewSpacing: CGFloat = 5
        static let mainStackViewLeftPadding: CGFloat = 5
    }
    
    struct Color {
        static let dateLabel = UIColor(red: 91, green: 91, blue: 91)
        static let mainLabel = UIColor(red: 48, green: 48, blue: 48)
        static let descriptionLabel = UIColor(red: 48, green: 48, blue: 48)
    }
    
    struct Font {
        static let dateLabel = UIFont.systemFont(ofSize: 18, weight: .semibold)
        static let mainLabel = UIFont.systemFont(ofSize: 36, weight: .black)
        static let descriptionLabel = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    let dateLabel = UILabel().then {
        $0.textColor = Color.dateLabel
        $0.font = Font.dateLabel
    }
    
    let mainLabel = UILabel().then {
        $0.textColor = Color.mainLabel
        $0.font = Font.mainLabel
        $0.numberOfLines = 0
    }
    
    let descriptionLabel = UILabel().then {
        $0.textColor = Color.descriptionLabel
        $0.font = Font.descriptionLabel
        $0.numberOfLines = 0
    }
    
    lazy var mainStackView = UIStackView().then {
        $0.addArrangedSubview(dateLabel)
        $0.addArrangedSubview(mainLabel)
        $0.addArrangedSubview(descriptionLabel)
        
        $0.alignment = .fill
        $0.distribution = .fillProportionally
        $0.axis = .vertical
        $0.spacing = Metric.mainStackViewSpacing
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
        self.backgroundColor = .clear
    }
    
    private func addSubviews() {
        addSubview(mainStackView)
    }
    
    private func setupConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.mainStackViewLeftPadding)
            make.right.top.bottom.equalToSuperview()
        }
    }
}
