//
//  MiniTemperatureView.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/04.
//

import UIKit

final class MiniTemperatureView: UIView {
    
    struct Metric {
        static let temperatureLabelLeftPadding: CGFloat = 5
        static let weatherStackViewSpacing: CGFloat = 5
        static let temperatureStackViewBottomPadding: CGFloat = 0
    }
    
    struct Font {
        static let temperatureLabel = UIFont.systemFont(ofSize: 40, weight: .bold)
        static let miniTemperatureLabel = UIFont.systemFont(ofSize: 18, weight: .semibold)
        static let weatherTitleLabel = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    let temperatureLabel = UILabel().then {
        $0.textColor = AppColor.text(.primaryDarkText).color
        $0.font = Font.temperatureLabel
    }
    
    let highestTemperatureLabel = UILabel().then {
        $0.textColor = AppColor.intensity(.intensity1).color
        $0.font = Font.miniTemperatureLabel
    }
    
    let lowestTemperatureLabel = UILabel().then {
        $0.textColor = AppColor.intensity(.intensity5).color
        $0.font = Font.miniTemperatureLabel
    }

    let weatherTitleLabel = UILabel().then {
        $0.font = Font.weatherTitleLabel
        $0.textColor = AppColor.text(.primaryDarkText).color
    }
    
    let weatherImageView = UIImageView()
    
    lazy var temperatureRangeStackView = UIStackView().then {
        $0.addArrangedSubview(highestTemperatureLabel)
        $0.addArrangedSubview(lowestTemperatureLabel)

        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    lazy var temperatureStackView = UIStackView().then {
        $0.addArrangedSubview(temperatureLabel)
        $0.addArrangedSubview(temperatureRangeStackView)

        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = Metric.temperatureLabelLeftPadding
    }
    
    lazy var weatherStackView = UIStackView().then {
        $0.addArrangedSubview(weatherTitleLabel)
        $0.addArrangedSubview(weatherImageView)

        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = Metric.weatherStackViewSpacing
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(temperature: String, highestTemperature: String, lowestTemperature: String, weather: String, weatherImage: String) {
        temperatureLabel.text = temperature
        highestTemperatureLabel.text = highestTemperature
        lowestTemperatureLabel.text = lowestTemperature
        weatherTitleLabel.text = weather
        weatherImageView.image = UIImage(named: weatherImage)
    }
    
    private func addSubviews() {
        addSubview(temperatureStackView)
        addSubview(weatherStackView)
    }
    
    private func setupConstraints() {
        temperatureStackView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }

        weatherStackView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(temperatureStackView.snp.bottom).offset(Metric.temperatureStackViewBottomPadding)
            make.bottom.equalToSuperview()
        }
    }
}
