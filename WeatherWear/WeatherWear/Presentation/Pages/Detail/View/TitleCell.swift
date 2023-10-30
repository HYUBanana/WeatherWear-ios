//
//  TitleView.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/13.
//

import UIKit

class TitleCell: UICollectionViewCell {
    
    static let identifier = "TitleCell"
    
    struct Metric {
        static let leadingPadding: CGFloat = 5
        static let textSpacing: CGFloat = 8
    }
    
    struct Color {
        static let dateLabel = UIColor(red: 91, green: 91, blue: 91)
        static let mainLabel = UIColor(red: 48, green: 48, blue: 48)
    }
    
    struct Font {
        static let dateLabel = UIFont.systemFont(ofSize: 18, weight: .semibold)
        static let mainLabel = UIFont.systemFont(ofSize: 36, weight: .black)
    }
    
    let dateLabel = UILabel().then {
        $0.text = "7월 24일 월요일,"
        $0.font = Font.dateLabel
        $0.textColor = Color.dateLabel
    }
    
    let spacingView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let mainLabel = UILabel().then {
        $0.text = "성동구는 지금."
        $0.font = Font.mainLabel
        $0.textColor = Color.mainLabel
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
        addSubview(dateLabel)
        addSubview(spacingView)
        addSubview(mainLabel)
    }
    
    private func setupConstraints() {
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(Metric.leadingPadding)
            make.right.equalToSuperview()
        }
        
        spacingView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.left.equalToSuperview().offset(Metric.leadingPadding)
            make.right.equalToSuperview()
            make.height.equalTo(Metric.textSpacing)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.leadingPadding)
            make.right.equalToSuperview()
            make.top.equalTo(spacingView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}
