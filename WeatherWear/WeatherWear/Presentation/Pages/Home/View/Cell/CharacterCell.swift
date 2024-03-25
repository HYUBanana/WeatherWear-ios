//
//  CharacterCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/05.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class CharacterCell: BaseCell {
    
    struct Metric {
        static let cornerRadius: CGFloat = 20
        static let imageHeight: CGFloat = 430

        static let verticalInnerPadding: CGFloat = 20
        static let horizontalInnerPadding: CGFloat = 20
    }
    
    let miniTemperatureView = MiniTemperatureView(frame: CGRectZero)
    
    let locationLabel = UILabel().then {
        $0.font = AppFont.description(.D3(.regular)).font
        $0.textColor = AppColor.text(.lightText).color
    }

    let lastUpdateTimeLabel = UILabel().then {
        $0.font = AppFont.description(.D4(.regular)).font
        $0.textColor = AppColor.text(.lightText).color
    }
    
    lazy var advicePositionView = AdvicePositionView(frame: CGRectZero)

    let characterImageView = UIImageView(image: UIImage(named: "Character")).then {
        $0.contentMode = .scaleAspectFill
    }

    let backgroundImageView = UIImageView(image: UIImage(named: "CharacterBackground")).then {
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
    
    func configure(temperature: String, highestTemperature: String, lowestTemperature: String, weather: String, weatherImage: String, location: String, lastUpdateTime: String, faceAdviceTitle: String, faceAdviceDescription: String, clothesAdviceTitle: String, clothesAdviceDescription: String, itemAdviceTitle: String, itemAdviceDescription: String, showAdvice: Bool) {
        locationLabel.text = location
        lastUpdateTimeLabel.text = lastUpdateTime
        advicePositionView.configure(faceAdviceTitle: faceAdviceTitle, faceAdviceDescription: faceAdviceDescription, clothesAdviceTitle: clothesAdviceTitle, clothesAdviceDescription: clothesAdviceDescription, itemAdviceTitle: itemAdviceTitle, itemAdviceDescription: itemAdviceDescription)
        miniTemperatureView.configure(temperature: temperature, highestTemperature: highestTemperature, lowestTemperature: lowestTemperature, weather: weather, weatherImage: weatherImage)
        
        if showAdvice {
            showViewWithAnimation()
        } else {
            hideViewWithAnimation()
        }
    }
    
    private func setup() {
        self.layer.cornerRadius = Metric.cornerRadius
        self.layer.masksToBounds = true
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
        characterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(Metric.imageHeight)
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
            make.height.equalTo(Metric.imageHeight)
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
            self.advicePositionView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

extension CharacterCell: Sizeable {
    func fittingSize(availableWidth: CGFloat, with viewModel: CellViewModelType) -> CGSize {
        
        viewModel.bind(to: self)
        
        let targetSize = CGSize(width: availableWidth, height: UIView.layoutFittingCompressedSize.height)
        return self.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
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
        
        func configure(faceAdviceTitle: String, faceAdviceDescription: String, clothesAdviceTitle: String, clothesAdviceDescription: String, itemAdviceTitle: String, itemAdviceDescription: String) {
            faceAdvice.configure(title: faceAdviceTitle, description: faceAdviceDescription)
            clothesAdvice.configure(title: clothesAdviceTitle, description: clothesAdviceDescription)
            itemAdvice.configure(title: itemAdviceTitle, description: itemAdviceDescription)
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

        lazy var backgroundView = UIView().then {
            $0.backgroundColor = AppColor.background(.white).color.withAlphaComponent(0.8)
            $0.layer.cornerRadius = Metric.cornerRadius
            $0.layer.masksToBounds = true
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubviews()
            setupConstraints()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(title: String, description: String) {
            titleLabel.text = title
            descriptionLabel.text = description
        }

        private func addSubviews() {
            addSubview(backgroundView)
            addSubview(stackView)
        }

        private func setupConstraints() {
            stackView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }

            backgroundView.snp.makeConstraints { make in
                make.edges.equalTo(stackView).inset(UIEdgeInsets(top: -Metric.cellPadding, left: -Metric.cellPadding, bottom: -Metric.cellPadding, right: -Metric.cellPadding))
            }
        }
    }
}
