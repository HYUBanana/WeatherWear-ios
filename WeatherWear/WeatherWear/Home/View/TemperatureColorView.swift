//
//  TemperatureBar.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/06.
//

import UIKit
import SnapKit

class TemperatureColorView: UIView {
    
    var weather: Weather?
    
    struct Metric {
        static let lowestTemperature: CGFloat = -10
        static let highestTemperature: CGFloat = 40
        
        static let temperatureBarHeight: CGFloat = 4
        static let triangleArrowCornerRadius: CGFloat = 1
        static let triangleArrowSize: CGFloat = 9
        static let barArrowPadding: CGFloat = 2
    }
    
    let temperatureBar = TemperatureBar()
    
    lazy var triangleArrow = TriangleView(cornerRadius: Metric.triangleArrowCornerRadius)
    
    override init(frame: CGRect){
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
        setArrowPosition()
        setArrowColor()
    }
    
    func configureData(with weather: Weather) {
        self.weather = weather
    }
    
    private func setup() {
    }
    
    private func addSubviews() {
        addSubview(temperatureBar)
        addSubview(triangleArrow)
    }
    
    private func setupConstraints() {
        temperatureBar.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(Metric.temperatureBarHeight)
        }
    }
    
    private func setArrowPosition() {
        guard let weather = self.weather else { return }
        
        let temperature = weather.briefingDatas[0].value
        
        let ratio = (CGFloat(temperature) - Metric.lowestTemperature) / (Metric.highestTemperature - Metric.lowestTemperature)
        let positionX = temperatureBar.frame.width * ratio - Metric.triangleArrowSize / 2
        
        triangleArrow.snp.makeConstraints { make in
            make.top.equalTo(temperatureBar.snp.bottom)
            make.centerX.equalTo(temperatureBar.snp.leading).offset(positionX)
            make.width.height.equalTo(Metric.triangleArrowSize)
        }
    }
    
    private func setArrowColor() {
        guard let weather = self.weather else { return }
        
        triangleArrow.color = weather.briefingDatas[0].color
    }
}
