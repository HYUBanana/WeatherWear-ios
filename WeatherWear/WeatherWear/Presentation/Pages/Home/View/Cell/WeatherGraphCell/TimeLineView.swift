//
//  TimeLineView.swift
//  WeatherWear
//
//  Created by 디해 on 2024/01/30.
//

import UIKit

extension WeatherGraphCell {
    final class TimeLineView: UIView {
        struct Metric {
            static let dotSize: CGFloat = 8
            static let lineWidth: CGFloat = 2
            static let timeLabelPadding: CGFloat = 5
            static let timeLabelTopPadding: CGFloat = 10
        }
        
        let lineView = UIView().then {
            $0.backgroundColor = AppColor.Component.red.color
        }
        
        let dotView = UIView().then {
            $0.backgroundColor = AppColor.Component.red.color
        }
        
        let timeLabel = UILabel().then {
            $0.font = AppFont.description(.D3(.semibold)).font
            $0.textColor = AppColor.Component.red.color
            $0.backgroundColor = .white
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
        
        func configure(time: String?) {
            timeLabel.text = time
        }
        
        private func setup() {
            self.dotView.layer.cornerRadius = Metric.dotSize / 2
        }
        
        private func addSubviews() {
            addSubview(lineView)
            addSubview(dotView)
            addSubview(timeLabel)
        }
        
        private func setupConstraints() {
            dotView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
                make.width.height.equalTo(Metric.dotSize)
            }
            
            timeLabel.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            
            lineView.snp.makeConstraints { make in
                make.top.equalTo(dotView.snp.bottom)
                make.bottom.equalTo(timeLabel.snp.top).inset(Metric.timeLabelTopPadding)
                make.centerX.equalToSuperview()
                make.width.equalTo(Metric.lineWidth)
            }
        }
    }
}
