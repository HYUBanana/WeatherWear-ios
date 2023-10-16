//
//  AdviceView.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/11.
//

import UIKit

final class AdviceView: UIView {
    
    struct Metric {
        static let cornerRadius: CGFloat = 20
        static let cellPadding: CGFloat = 12
        static let adviceSpacing: CGFloat = 0
    }
    
    struct Color {
        static let titleAdviceLabel = UIColor(red: 48, green: 48, blue: 48)
        static let subAdviceLabel = UIColor(red: 91, green: 91, blue: 91)
        static let backgroundView = UIColor(red: 255, green: 255, blue: 255, alpha: 0.8)
    }
    
    struct Font {
        static let titleAdviceLabel = UIFont.systemFont(ofSize: 17, weight: .bold)
        static let subAdviceLabel = UIFont.systemFont(ofSize: 13, weight: .semibold)
    }
    
    let titleAdviceLabel = UILabel().then {
        $0.textColor = Color.titleAdviceLabel
        $0.font = Font.titleAdviceLabel
    }
    
    let subAdviceLabel = UILabel().then {
        $0.textColor = Color.subAdviceLabel
        $0.font = Font.subAdviceLabel
    }
    
    lazy var stackView = UIStackView().then {
        $0.addArrangedSubview(titleAdviceLabel)
        $0.addArrangedSubview(subAdviceLabel)
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fill
        $0.spacing = Metric.adviceSpacing
    }
    
    lazy var backgroundView = UIView().then {
        $0.backgroundColor = Color.backgroundView
        $0.layer.cornerRadius = Metric.cornerRadius
        $0.layer.masksToBounds = true
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
        addSubview(backgroundView)
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(stackView).inset(UIEdgeInsets(top: -Metric.cellPadding, left: -Metric.cellPadding, bottom: -Metric.cellPadding, right: -Metric.cellPadding))
        }
    }
}
