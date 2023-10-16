//
//  BriefingCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/06.
//

import UIKit

final class BriefingCell: UICollectionViewCell {
    
    var weather: Weather? 
    
    static let identifier = "BriefingCell"
    
    struct Metric {
        static let cellPadding: CGFloat = 15
        static let cornerRadius: CGFloat = 20
        static let redirectionArrowPadding: CGFloat = 5
        static let stateStackViewSpacing: CGFloat = 1
        static let graphStackViewSpacing: CGFloat = 5
        static let iconStackViewSpacing: CGFloat = 10
        static let briefingBlockStackViewSpacing: CGFloat = 20
        static let temperatureBarWidth: CGFloat = 80
        static let temperatureBarHeight: CGFloat = 13
        static let descriptionLabelWidth: CGFloat = 180
    }
    
    struct Color {
        static let titleLabel = UIColor(red: 95, green: 95, blue: 95)
        static let descriptionLabel = UIColor(red: 48, green: 48, blue: 48)
        static let redirectionArrowImageView = UIColor.gray
    }
    
    struct Font {
        static let iconLabel = UIFont.systemFont(ofSize: 28)
        static let titleLabel = UIFont.systemFont(ofSize: 13, weight: .semibold)
        static let stateLabel = UIFont.systemFont(ofSize: 20, weight: .semibold)
        static let descriptionLabel = UIFont.systemFont(ofSize: 13)
    }
    
    let iconLabel = UILabel().then {
        $0.font = Font.iconLabel
    }
    
    let titleLabel = UILabel().then {
        $0.font = Font.titleLabel
        $0.textColor = Color.titleLabel
    }
    
    let stateLabel = UILabel().then {
        $0.font = Font.stateLabel
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = Font.descriptionLabel
        $0.textColor = Color.descriptionLabel
        $0.numberOfLines = 0
    }
    
    let temperatureColorView = TemperatureColorView()
    
    let redirectionArrowImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = Color.redirectionArrowImageView
    }
    
    lazy var stateStackView = UIStackView().then {
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(stateLabel)
        
        $0.alignment = .leading
        $0.distribution = .fillProportionally
        $0.axis = .vertical
        $0.spacing = Metric.stateStackViewSpacing
    }
    
    lazy var graphStackView = UIStackView().then {
        $0.addArrangedSubview(stateStackView)
        $0.addArrangedSubview(temperatureColorView)
        
        $0.alignment = .leading
        $0.distribution = .fill
        $0.axis = .vertical
        $0.spacing = Metric.graphStackViewSpacing
    }
    
    lazy var iconStackView = UIStackView().then {
        $0.addArrangedSubview(iconLabel)
        $0.addArrangedSubview(graphStackView)
        
        $0.alignment = .center
        $0.distribution = .fillProportionally
        $0.axis = .horizontal
        $0.spacing = Metric.iconStackViewSpacing
    }
    
    lazy var briefingBlockStackView = UIStackView().then {
        $0.addArrangedSubview(iconStackView)
        $0.addArrangedSubview(descriptionLabel)
        
        $0.alignment = .center
        $0.distribution = .fill
        $0.axis = .horizontal
        $0.spacing = Metric.briefingBlockStackViewSpacing
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
    
    func configureData(with weather: Weather) {
        self.weather = weather
        self.temperatureColorView.configureData(with: weather)
    }
    
    private func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = Metric.cornerRadius
        self.layer.masksToBounds = true
    }
    
    private func addSubviews() {
        addSubview(briefingBlockStackView)
        addSubview(redirectionArrowImageView)
    }
    
    private func setupConstraints() {
        redirectionArrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-Metric.cellPadding)
            make.centerY.equalToSuperview()
        }
        
        briefingBlockStackView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(Metric.cellPadding)
            make.bottom.equalToSuperview().offset(-Metric.cellPadding)
            make.right.equalTo(redirectionArrowImageView.snp.left).offset(-Metric.redirectionArrowPadding)
        }
        
        temperatureColorView.snp.makeConstraints { make in
            make.width.equalTo(Metric.temperatureBarWidth)
            make.height.equalTo(Metric.temperatureBarHeight)
        }
    }
}
