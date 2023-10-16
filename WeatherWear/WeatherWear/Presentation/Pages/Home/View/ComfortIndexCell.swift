//
//  ComfortIndexCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/06.
//

import UIKit

final class ComfortIndexCell: UICollectionViewCell {
    
    static let identifier = "ComfortIndexCell"
    
    struct Metric {
        static let cellPadding: CGFloat = 20
        static let indexIconPadding: CGFloat = 10
        static let indexSpacing: CGFloat = 0
        static let cornerRadius: CGFloat = 20
    }
    
    struct Color {
        static let valueLabel = UIColor(red: 95, green: 95, blue: 95)
    }
    
    struct Font {
        static let iconLabel = UIFont.systemFont(ofSize: 28)
        static let valueLabel = UIFont.systemFont(ofSize: 13, weight: .semibold)
        static let stateLabel = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    let iconLabel = UILabel().then {
        $0.font = Font.iconLabel
    }
    
    let valueLabel = UILabel().then {
        $0.font = Font.valueLabel
        $0.textColor = Color.valueLabel
    }
    
    let stateLabel = UILabel().then {
        $0.font = Font.stateLabel
    }
    
    lazy var indexStackView = UIStackView().then {
        $0.addArrangedSubview(valueLabel)
        $0.addArrangedSubview(stateLabel)
        
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fill
        $0.spacing = Metric.indexSpacing
    }
    
    lazy var indexIconStackView = UIStackView().then {
        $0.addArrangedSubview(iconLabel)
        $0.addArrangedSubview(indexStackView)
        
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = Metric.indexIconPadding
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
        self.backgroundColor = .white
        self.layer.cornerRadius = Metric.cornerRadius
        self.clipsToBounds = true
    }
    
    private func addSubviews() {
        addSubview(indexIconStackView)
    }
    
    private func setupConstraints() {
        indexIconStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
