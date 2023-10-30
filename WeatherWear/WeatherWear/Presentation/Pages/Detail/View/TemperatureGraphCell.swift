//
//  TemperatureGraphView.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/13.
//

import UIKit

class TemperatureGraphCell: UICollectionViewCell {
    
    static let identifier = "TemperatureGraphCell"
    
    struct Metric {
        static let cornerRadius: CGFloat = 20
        static let spacing: CGFloat = 15
    }
    
    struct Color {
        static let headerLabel = UIColor(red: 48, green: 48, blue: 48)
    }
    
    struct Font {
        static let headerLabel = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    let headerLabel = UILabel().then {
        $0.text = "온도와 강수량"
        $0.font = Font.headerLabel
        $0.textColor = Color.headerLabel
    }
    
    let spacingView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let graphContainerView = GraphContainerView()
    
    lazy var graphScrollView = UIScrollView().then {
        $0.addSubview(graphContainerView)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = Metric.cornerRadius
        $0.layer.masksToBounds = true
        $0.showsHorizontalScrollIndicator = false
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
        addSubview(headerLabel)
        addSubview(spacingView)
        addSubview(graphScrollView)
    }
    
    private func setupConstraints() {
        
        headerLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        spacingView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(Metric.spacing)
        }
        
        graphScrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(spacingView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        graphContainerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}

extension TemperatureGraphCell {
    class GraphContainerView: UIView {
        var lastCell: GraphBarView? = nil
        
        struct Metric {
            static let barCount: Int = 14
            static let barWidth: CGFloat = 36
            static let barheight: CGFloat = 260
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
            addSubviews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setup() {
        }
        
        private func addSubviews() {
            var backgroundToggle = true
            
            for _ in 0 ..< Metric.barCount {
                let cell = GraphBarView(weatherCondition: "ClearIcon", cloudCover: 94, temperature: 27, humidity: 7.1, date: 12, isLightBackground: backgroundToggle)
                self.addSubview(cell)
                
                cell.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.width.equalTo(Metric.barWidth)
                    
                    if let lastCell = lastCell {
                        make.left.equalTo(lastCell.snp.right).offset(2)
                    } else {
                        make.left.equalToSuperview()
                    }
                }
                backgroundToggle.toggle()
                lastCell = cell
            }
            
            if let lastCell = lastCell {
                lastCell.snp.makeConstraints { make in
                    make.right.equalToSuperview()
                }
            }
        }
        
        override var intrinsicContentSize: CGSize {
            return CGSize(width: CGFloat(Metric.barCount) * Metric.barWidth, height: Metric.barheight)
        }
    }
}

extension TemperatureGraphCell {
    class GraphBarView: UIView {
        
        let weatherCondition: String
        let cloudCover: Int
        let temperature: Int
        let humidity: Float
        let date: Int
        let isLightBackground: Bool
        
        private var didNotLayoutSetup = true
        
        struct Metric {
            static let totalPadding: CGFloat = 8
            static let cornerRadius: CGFloat = 20
            static let humidityBarCornerRadius: CGFloat = 3
            
            static let iconSize: CGFloat = 24
            static let dotSize: CGFloat = 5
            static let iconBottomPadding: CGFloat = 5
            static let humidityBarBottomPadding: CGFloat = 7
            static let humidityBarWidth: CGFloat = 6
            static let humidityLabelBottomPadding: CGFloat = 4
            static let dotLabelPadding: CGFloat = 2
        }
        
        struct Color {
            static let lightBackgroundColor = UIColor(red: 255, green: 255, blue: 255)
            static let darkBackgroundColor = UIColor(red: 243, green: 243, blue: 243)
            
            static let cloudCoverLabel = UIColor(red: 48, green: 88, blue: 125)
            static let temperatureLabel = UIColor(red: 91, green: 91, blue: 91)
            static let humidityLabel = UIColor(red: 36, green: 160, blue: 237)
            static let dateLabel = UIColor(red: 91, green: 91, blue: 91)
        }
        
        struct Font {
            static let cloudCoverLabel = UIFont.systemFont(ofSize: 12)
            static let temperatureLabel = UIFont.systemFont(ofSize: 13, weight: .semibold)
            static let humidityLabel = UIFont.systemFont(ofSize: 13, weight: .semibold)
            static let dateLabel = UIFont.systemFont(ofSize: 14, weight: .bold)
        }
        
        lazy var weatherConditionIconImageView = UIImageView(image: UIImage(named: weatherCondition))
        
        let cloudCoverLabel = UILabel().then {
            $0.textColor = Color.cloudCoverLabel
            $0.font = Font.cloudCoverLabel
        }
        
        let temperatureLabel = UILabel().then {
            $0.textColor = Color.temperatureLabel
            $0.font = Font.temperatureLabel
        }
        
        let temperatureDot = CircleView(color: .black)
        
        let humidityLabel = UILabel().then {
            $0.textColor = Color.humidityLabel
            $0.font = Font.humidityLabel
        }
        
        lazy var humidityBar = UIView().then {
            $0.backgroundColor = Color.humidityLabel
            $0.layer.cornerRadius = Metric.humidityBarCornerRadius
            $0.layer.masksToBounds = true
        }
        
        let dateLabel = UILabel().then {
            $0.textColor = Color.dateLabel
            $0.font = Font.dateLabel
        }
        
        init(frame: CGRect = CGRectZero, weatherCondition: String, cloudCover: Int, temperature: Int, humidity: Float, date: Int, isLightBackground: Bool) {
            self.weatherCondition = weatherCondition
            self.cloudCover = cloudCover
            self.temperature = temperature
            self.humidity = humidity
            self.date = date
            self.isLightBackground = isLightBackground
            
            super.init(frame: frame)
            
            setup()
            addSubviews()
            setupConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            if (didNotLayoutSetup) {
                setDotPosition()
                setHumidityBarHeight()
                
                didNotLayoutSetup = true
            }
        }
        
        private func setHumidityBarHeight() {
            let distanceBetweenLabels = dateLabel.frame.origin.y - cloudCoverLabel.frame.maxY
            let humidityBarHeight = distanceBetweenLabels * CGFloat(humidity) / 30.0
            humidityLabel.text = "\(humidity)"
            
            UIView.animate(withDuration: 0.5) {
                self.humidityBar.snp.updateConstraints { make in
                    make.height.equalTo(humidityBarHeight)
                }
                self.layoutIfNeeded()
            }
        }
        
        private func setDotPosition() {
            let distanceBetweenLabels = dateLabel.frame.origin.y - cloudCoverLabel.frame.maxY
            let dotHeight = CGFloat(temperature + 10) * distanceBetweenLabels / 50.0
            let dotYPosition = dateLabel.frame.origin.y - dotHeight
            temperatureDot.snp.makeConstraints { make in
                make.centerY.equalTo(dotYPosition)
            }
            self.layoutIfNeeded()
        }
        
        private func setup() {
            self.backgroundColor = isLightBackground ? Color.lightBackgroundColor : Color.darkBackgroundColor
            self.layer.cornerRadius = Metric.cornerRadius
            self.layer.masksToBounds = true
            
            self.cloudCoverLabel.text = String(cloudCover) + "%"
            self.temperatureLabel.text = String(temperature)
            self.humidityLabel.text = String(humidity)
            self.dateLabel.text = String(date)
        }
        
        private func addSubviews() {
            addSubview(weatherConditionIconImageView)
            addSubview(cloudCoverLabel)
            addSubview(temperatureDot)
            addSubview(temperatureLabel)
            addSubview(humidityLabel)
            addSubview(humidityBar)
            addSubview(dateLabel)
        }
        
        private func setupConstraints() {
            weatherConditionIconImageView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(Metric.totalPadding)
                make.width.height.equalTo(Metric.iconSize)
            }
            
            cloudCoverLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(weatherConditionIconImageView.snp.bottom).offset(Metric.iconBottomPadding)
            }
            
            temperatureDot.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.height.equalTo(Metric.dotSize)
            }
            
            temperatureLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(temperatureDot.snp.top).offset(-Metric.dotLabelPadding)
            }
            
            dateLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-Metric.totalPadding)
            }
            
            humidityBar.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(dateLabel.snp.top).offset(-Metric.humidityBarBottomPadding)
                make.width.equalTo(Metric.humidityBarWidth)
                make.height.equalTo(0)
            }
            
            humidityLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(humidityBar.snp.top).offset(-Metric.humidityLabelBottomPadding)
            }
        }
    }
}
