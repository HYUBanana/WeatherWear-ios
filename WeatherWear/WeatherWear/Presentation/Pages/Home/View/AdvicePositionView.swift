//
//  AdvicePositionView.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/11.
//

import UIKit

final class AdvicePositionView: UIView {
    let faceAdvice = AdviceView()
    let clothesAdvice = AdviceView()
    let itemAdvice = AdviceView()
    
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
        addSubview(faceAdvice)
        addSubview(clothesAdvice)
        addSubview(itemAdvice)
    }
    
    private func setupConstraints() {
        faceAdvice.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(100)
            make.centerY.equalToSuperview().offset(-60)
        }
        
        clothesAdvice.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(105)
            make.centerY.equalToSuperview().offset(30)
        }
        
        itemAdvice.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-100)
            make.centerY.equalToSuperview().offset(70)
        }
    }
}
