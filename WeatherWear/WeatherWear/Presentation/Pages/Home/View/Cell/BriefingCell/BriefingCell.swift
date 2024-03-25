//
//  BriefingCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/06.
//

import UIKit
import Then
import RxSwift

final class BriefingCell: BaseCell {

    private var graphType: GraphType?
    
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
        $0.font = AppFont.header(.H1(.regular)).font
    }

    let titleLabel = UILabel().then {
        $0.font = AppFont.description(.D3(.semibold)).font
        $0.textColor = AppColor.text(.secondaryDarkText).color
    }

    let stateLabel = UILabel().then {
        $0.font = AppFont.header(.H4(.bold)).font
    }

    let descriptionLabel = UILabel().then {
        $0.font = AppFont.description(.D3(.regular)).font
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
    
    func configure(data: BriefingCellData) {
        guard let intensity = data.intensity else { return }
        
        self.graphType = data.graphType
        
        iconLabel.text = data.icon
        titleLabel.text = data.name
        stateLabel.text = intensity.state
        stateLabel.textColor = intensity.color.color
        descriptionLabel.text = data.description
        temperatureColorView.configure(data: data)
    }
    
    private func setup() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Metric.cornerRadius
        
        contentView.layer.shadowColor = AppColor.component(.black).color.cgColor
        contentView.layer.shadowOpacity = 0.07
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowRadius = 10
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

        func configure(data: BriefingCellData) {
            guard let highestValue = data.highestValue, let lowestValue = data.lowestValue else { return }
            
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
                make.centerY.equalToSuperview()
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

extension BriefingCell: Bindable {
    func bind(with model: ViewModel) {
        guard let model = model as? BriefingCellViewModel else { return }
        configure(data: model.data)
    }
}

extension BriefingCell: Touchable {
    var touch: Observable<Void> {
        return self.rx.tapGesture()
            .when(.recognized)
            .asObservable()
            .map { _ in }
    }
}
