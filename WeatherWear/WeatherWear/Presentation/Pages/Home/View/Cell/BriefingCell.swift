//
//  BriefingCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/06.
//

import UIKit
import RxSwift

final class BriefingCell: UICollectionViewCell {

    struct Metric {
        static let cellHorizontalPadding: CGFloat = 25
        static let cellVerticalPadding: CGFloat = 20
        static let innerIconStatePadding: CGFloat = 15
        static let innerStateDescriptionPadding: CGFloat = 20
        static let cornerRadius: CGFloat = 20
        
        static let stateStackViewSpacing: CGFloat = 5
        static let stateLabelsStackViewSpacing: CGFloat = 1
    }

    let iconLabel = UILabel().then {
        $0.font = AppFont.header(.H2(.regular)).font
    }

    let titleLabel = UILabel().then {
        $0.font = AppFont.description(.D3(.semibold)).font
        $0.textColor = AppColor.text(.secondaryDarkText).color
    }

    let stateLabel = UILabel().then {
        $0.font = AppFont.header(.H3(.bold)).font
    }

    let descriptionLabel = UILabel().then {
        $0.font = AppFont.description(.D4(.regular)).font
        $0.textColor = AppColor.text(.primaryDarkText).color
        $0.numberOfLines = 0
    }

    let temperatureColorView = TemperatureColorView()

    lazy var stateLabelsStackView = UIStackView().then {
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(stateLabel)

        $0.alignment = .leading
        $0.distribution = .fillProportionally
        $0.axis = .vertical
        $0.spacing = Metric.stateLabelsStackViewSpacing
    }
    
    lazy var stateStackView = UIStackView().then {
        $0.addArrangedSubview(stateLabelsStackView)
        $0.addArrangedSubview(temperatureColorView)
        
        $0.alignment = .leading
        $0.distribution = .fillProportionally
        $0.axis = .vertical
        $0.spacing = Metric.stateStackViewSpacing
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

    func configure(icon: String, highestValue: Int, lowestValue: Int, title: String, state: String, stateColor: AppColor, description: String) {
        iconLabel.text = icon
        titleLabel.text = title
        stateLabel.text = state
        stateLabel.textColor = stateColor.color
        descriptionLabel.text = description
        temperatureColorView.configure(highestValue: highestValue, lowestValue: lowestValue)
    }
    
    private func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = Metric.cornerRadius
        self.layer.masksToBounds = true
    }

    private func addSubviews() {
        contentView.addSubview(iconLabel)
        contentView.addSubview(stateStackView)
        contentView.addSubview(descriptionLabel)
    }

    private func setupConstraints() {
        iconLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Metric.cellHorizontalPadding)
        }
        
        stateStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconLabel.snp.right).offset(Metric.innerIconStatePadding)
            make.top.equalToSuperview().offset(Metric.cellVerticalPadding)
            make.bottom.equalToSuperview().offset(-Metric.cellVerticalPadding)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(stateStackView.snp.right).offset(Metric.innerStateDescriptionPadding)
        }
    }
}

extension BriefingCell: Sizeable {
    func fittingSize(availableWidth: CGFloat, with viewModel: CellViewModelType) -> CGSize {
        
        let cell = BriefingCell()
        viewModel.bind(to: cell)
        
        let targetSize = CGSize(width: availableWidth, height: UIView.layoutFittingCompressedSize.height)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

extension BriefingCell {
    final class TemperatureColorView: UIView {

        struct Metric {
            static let lowestTemperature: Int = -10
            static let highestTemperature: Int = 40

            static let cornerRadius: CGFloat = 4
            static let barHeight: CGFloat = 6
            static let barWidth: CGFloat = 80
        }

        let temperatureBar = TemperatureBar()
        
        lazy var temperatureColorBar = UIView().then {
            $0.addSubview(temperatureBar)
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = Metric.cornerRadius
            $0.layer.masksToBounds = true
            $0.clipsToBounds = true
        }
        
        lazy var backgroundBar = UIView().then {
            $0.backgroundColor = AppColor.component(.lightGray).color
            $0.layer.cornerRadius = Metric.cornerRadius
            $0.layer.masksToBounds = true
        }

        override init(frame: CGRect){
            super.init(frame: frame)

            setup()
            addSubviews()
            setupConstraints()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func configure(highestValue: Int, lowestValue: Int) {
            let percentageWidth = (Metric.barWidth) / CGFloat(Metric.highestTemperature - Metric.lowestTemperature)
            let startX = CGFloat(lowestValue - Metric.lowestTemperature) * percentageWidth
            let width = CGFloat(highestValue - lowestValue) * percentageWidth
            temperatureColorBar.snp.updateConstraints { make in
                make.left.equalTo(backgroundBar.snp.left).offset(startX)
                make.width.equalTo(width)
            }
        }
        
        private func setup() {
            
        }

        private func addSubviews() {
            addSubview(backgroundBar)
            addSubview(temperatureColorBar)
        }

        private func setupConstraints() {
            backgroundBar.snp.makeConstraints { make in
                make.height.equalTo(Metric.barHeight)
                make.width.equalTo(Metric.barWidth)
                make.edges.equalToSuperview()
            }
            
            temperatureColorBar.snp.makeConstraints { make in
                make.height.equalTo(Metric.barHeight)
                make.left.equalTo(backgroundBar.snp.left)
                make.width.equalTo(0)
            }
            
            temperatureBar.snp.makeConstraints { make in
                make.height.equalTo(Metric.barHeight)
                make.width.equalTo(Metric.barWidth)
                make.edges.equalTo(backgroundBar.snp.edges)
            }
        }
    }
}

extension BriefingCell {
    final class TemperatureBar: UIView {

        let gradientLayer = CAGradientLayer().then {
            $0.colors = [
                AppColor.Gradient.blue.color.cgColor,
                AppColor.Gradient.green.color.cgColor,
                AppColor.Gradient.yellow.color.cgColor,
                AppColor.Gradient.red.color.cgColor
                    ]
            $0.startPoint = CGPoint(x: 0, y: 0.5)
            $0.endPoint = CGPoint(x: 1, y: 0.5)
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            self.layer.addSublayer(gradientLayer)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            gradientLayer.frame = self.bounds
        }
    }
}
