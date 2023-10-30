//
//  TitleView.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/13.
//

import UIKit

class DetailTitleCell: UICollectionViewCell {
    
    static let identifier = "DetailTitleCell"
    
    struct Metric {
        static let spacing1: CGFloat = 30
        static let spacing2: CGFloat = 5
        
        static let leftPadding: CGFloat = 5
    }
    
    struct Color {
        static let dateLabel = UIColor(red: 91, green: 91, blue: 91)
        static let mainLabel = UIColor(red: 48, green: 48, blue: 48)
    }
    
    struct Font {
        static let dateLabel = UIFont.systemFont(ofSize: 18, weight: .semibold)
        static let mainLabel = UIFont.systemFont(ofSize: 36, weight: .black)
    }
    
    let spacing1 = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let dateLabel = UILabel().then {
        $0.text = "7월 24일 월요일,"
        $0.font = Font.dateLabel
        $0.textColor = Color.dateLabel
    }
    
    let spacing2 = UIView().then {
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
    
    static func fittingSize(availableWidth: CGFloat) -> CGSize {
        let cell = DetailTitleCell()
        cell.configure()
        
        let targetSize = CGSize(width: availableWidth, height: UIView.layoutFittingCompressedSize.height)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func configure() {
    }
    
    private func setup() {
        self.backgroundColor = .clear
    }
    
    private func addSubviews() {
        contentView.addSubview(spacing1)
        contentView.addSubview(dateLabel)
        contentView.addSubview(spacing2)
        contentView.addSubview(mainLabel)
    }
    
    private func setupConstraints() {
        
        spacing1.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(Metric.spacing1)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(spacing1.snp.bottom)
            make.left.equalToSuperview().offset(Metric.leftPadding)
            make.right.equalToSuperview()
        }
        
        spacing2.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(Metric.spacing2)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.leftPadding)
            make.right.equalToSuperview()
            make.top.equalTo(spacing2.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}
