//
//  SettingHeader.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/22.
//

import UIKit
import Then

protocol SettingHeaderDelegate: AnyObject {
    func plusButtonTapped()
}

final class SettingHeader: UICollectionReusableView {
    
    weak var delegate: SettingHeaderDelegate?
    
    struct Metric {
        static let headerPadding: CGFloat = 25
    }
    
    struct Color {
        static let titleLabel = UIColor(red: 48.0 / 255.0,
                                        green: 48.0 / 255.0,
                                        blue: 48.0 / 255.0,
                                        alpha: 1.0)
        static let plusButton = UIColor(red: 48.0 / 255.0,
                                        green: 48.0 / 255.0,
                                        blue: 48.0 / 255.0,
                                        alpha: 1.0)
    }
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 20, weight: .bold)
        static let plusButton = UIFont.systemFont(ofSize: 30)
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = Color.titleLabel
        $0.font = Font.titleLabel
    }
    
    lazy var plusButton = UIButton().then {
        $0.setTitle("+", for: .normal)
        $0.titleLabel?.font = Font.plusButton
        $0.setTitleColor(Color.plusButton, for: .normal)
        $0.isHidden = true
        $0.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
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
        addSubview(plusButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Metric.headerPadding)
        }
        
        plusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-Metric.headerPadding)
        }
    }
    
    @objc func plusButtonTapped() {
        delegate?.plusButtonTapped()
    }
}
