//
//  CharacterCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/05.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import RxGesture

final class CharacterCell: BaseCell {
    
    struct Metric {
        static let cornerRadius: CGFloat = 20
        static let imageHeight: CGFloat = 430

        static let verticalInnerPadding: CGFloat = 23
        static let horizontalInnerPadding: CGFloat = 23
    }
    
    let miniTemperatureView = MiniTemperatureView(frame: CGRectZero)
    
    let locationLabel = UILabel().then {
        $0.font = AppFont.description(.D3(.regular)).font
        $0.textColor = AppColor.text(.mediumLightText).color
    }

    let lastUpdateTimeLabel = UILabel().then {
        $0.font = AppFont.description(.D4(.regular)).font
        $0.textColor = AppColor.text(.mediumLightText).color
    }
    
    lazy var advicePositionView = AdvicePositionView(frame: CGRectZero)

    let characterImageView = UIImageView(image: UIImage(named: "Character")).then {
        $0.contentMode = .scaleAspectFill
    }

    let backgroundImageView = UIImageView(image: UIImage()).then {
        $0.alpha = 0.6
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    lazy var locationUpdateStackView = UIStackView().then {
        $0.addArrangedSubview(locationLabel)
        $0.addArrangedSubview(lastUpdateTimeLabel)

        $0.axis = .vertical
        $0.alignment = .trailing
        $0.distribution = .fill
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
    
    func configure(data: CharacterCellData, showAdvice: Bool) {
        
        backgroundImageView.image = UIImage(named: data.backgroundImage)
        
        locationLabel.text = data.location
        lastUpdateTimeLabel.text = data.lastUpdateTime
        advicePositionView.configure(data: data)
        miniTemperatureView.configure(data: data)
        
        if showAdvice {
            showViewWithAnimation()
        } else {
            hideViewWithAnimation()
        }
    }
    
    private func setup() {
        contentView.layer.cornerRadius = Metric.cornerRadius
        contentView.layer.masksToBounds = true
    }

    private func addSubviews() {
        contentView.addSubview(miniTemperatureView)
        contentView.addSubview(characterImageView)
        contentView.addSubview(locationUpdateStackView)
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(advicePositionView)

        contentView.sendSubviewToBack(backgroundImageView)
    }

    private func setupConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(Metric.imageHeight)
        }
        
        characterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        miniTemperatureView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.horizontalInnerPadding)
            make.top.equalToSuperview()
                .offset(Metric.verticalInnerPadding)
        }

        locationUpdateStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Metric.horizontalInnerPadding)
            make.top.equalToSuperview().offset(Metric.verticalInnerPadding)
        }

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(Metric.imageHeight)
        }

        advicePositionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension CharacterCell {
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
        
        func configure(data: CharacterCellData) {
            faceAdvice.configure(title: data.faceAdvice.title,
                                 description: data.faceAdvice.description)
            clothesAdvice.configure(title: data.clothesAdvice.title,
                                    description: data.clothesAdvice.description)
            itemAdvice.configure(title: data.clothesAdvice.title,
                                 description: data.clothesAdvice.description)
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
}

extension CharacterCell {
    final class AdviceView: UIView {

        struct Metric {
            static let cornerRadius: CGFloat = 20
            static let cellPadding: CGFloat = 12
            static let adviceSpacing: CGFloat = 0
        }

        let titleLabel = UILabel().then {
            $0.textColor = AppColor.text(.primaryDarkText).color
            $0.font = AppFont.description(.D1(.bold)).font
        }

        let descriptionLabel = UILabel().then {
            $0.textColor = AppColor.text(.tertiaryDarkText).color
            $0.font = AppFont.description(.D3(.semibold)).font
        }

        lazy var stackView = UIStackView().then {
            $0.addArrangedSubview(titleLabel)
            $0.addArrangedSubview(descriptionLabel)
            $0.axis = .vertical
            $0.alignment = .leading
            $0.distribution = .fill
            $0.spacing = Metric.adviceSpacing
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
        
        func setup() {
            self.backgroundColor = .white.withAlphaComponent(0.8)
            self.layer.cornerRadius = Metric.cornerRadius
        }
        
        func configure(title: String, description: String) {
            titleLabel.text = title
            descriptionLabel.text = description
        }

        private func addSubviews() {
            addSubview(stackView)
        }

        private func setupConstraints() {
            stackView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.edges.equalToSuperview().inset(Metric.cellPadding)
            }
        }
    }
}

extension CharacterCell {
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
        
        func configure(data: CharacterCellData) {
            temperatureLabel.text = data.temperature
            highestTemperatureLabel.text = data.highestTemperature
            lowestTemperatureLabel.text = data.lowestTemperature
            weatherTitleLabel.text = data.weatherName
            weatherImageView.image = UIImage(systemName: data.weatherIcon)
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
}

extension CharacterCell {
    func hideViewWithAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.advicePositionView.alpha = 0.0
            self.advicePositionView.transform = CGAffineTransform(translationX: 0, y: 10)
        }, completion: nil)
    }
    
    func showViewWithAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.advicePositionView.alpha = 1.0
            self.advicePositionView.transform = CGAffineTransform(translationX: 0, y: -10)
        }, completion: nil)
    }
}

extension CharacterCell: Bindable {
    func bind(with model: ViewModel) {
        guard let model = model as? CharacterCellViewModel else { return }
        configure(data: model.data,
                  showAdvice: model.showAdvice)
    }
}

extension CharacterCell: Touchable {
    var touch: Observable<Void> {
        return self.rx.tapGesture()
            .when(.recognized)
            .asObservable()
            .map { _ in }
    }
}
