//
//  CustomView.swift
//  WeatherWear
//
//  Created by 디해 on 2024/01/19.
//

import UIKit
import Lottie

class AnimatedRefreshControl: UIRefreshControl {
    let animationView = LottieAnimationView(name: "loading").then {
        $0.loopMode = .loop
    }
    
    override init() {
        super.init()
        
        setup()
        addSubviews()
        setupConstraints()
        
        animationView.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .clear
        self.tintColor = .clear
    }
    
    private func addSubviews() {
        addSubview(animationView)
    }
    
    private func setupConstraints() {
        animationView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
