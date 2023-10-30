//
//  BriefingCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/06.
//

import UIKit
import RxSwift

final class BriefingCell: UICollectionViewCell {
    
    static let identifier = "BriefingCell"
    
    private let viewModel: BriefingCellViewModel = BriefingCellViewModel()
    var disposeBag = DisposeBag()
    
    struct Metric {
        static let cellPadding: CGFloat = 15
        static let cornerRadius: CGFloat = 20
        static let redirectionArrowPadding: CGFloat = 5
        static let stateStackViewSpacing: CGFloat = 1
        static let graphStackViewSpacing: CGFloat = 5
        static let iconStackViewSpacing: CGFloat = 10
        static let briefingBlockStackViewSpacing: CGFloat = 20
        static let temperatureBarWidth: CGFloat = 80
        static let temperatureBarHeight: CGFloat = 13
        static let descriptionLabelWidth: CGFloat = 180
    }
    
    struct Color {
        static let titleLabel = UIColor(red: 95, green: 95, blue: 95)
        static let descriptionLabel = UIColor(red: 48, green: 48, blue: 48)
        static let redirectionArrowImageView = UIColor.gray
    }
    
    struct Font {
        static let iconLabel = UIFont.systemFont(ofSize: 28)
        static let titleLabel = UIFont.systemFont(ofSize: 13, weight: .semibold)
        static let stateLabel = UIFont.systemFont(ofSize: 20, weight: .semibold)
        static let descriptionLabel = UIFont.systemFont(ofSize: 13)
    }
    
    let iconLabel = UILabel().then {
        $0.font = Font.iconLabel
    }
    
    let titleLabel = UILabel().then {
        $0.font = Font.titleLabel
        $0.textColor = Color.titleLabel
    }
    
    let stateLabel = UILabel().then {
        $0.font = Font.stateLabel
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = Font.descriptionLabel
        $0.textColor = Color.descriptionLabel
        $0.numberOfLines = 0
    }
    
    let temperatureColorView = TemperatureColorView()
    
    let redirectionArrowImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = Color.redirectionArrowImageView
    }
    
    lazy var stateStackView = UIStackView().then {
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(stateLabel)
        
        $0.alignment = .leading
        $0.distribution = .fillProportionally
        $0.axis = .vertical
        $0.spacing = Metric.stateStackViewSpacing
    }
    
    lazy var graphStackView = UIStackView().then {
        $0.addArrangedSubview(stateStackView)
        $0.addArrangedSubview(temperatureColorView)
        
        $0.alignment = .leading
        $0.distribution = .fill
        $0.axis = .vertical
        $0.spacing = Metric.graphStackViewSpacing
    }
    
    lazy var iconStackView = UIStackView().then {
        $0.addArrangedSubview(iconLabel)
        $0.addArrangedSubview(graphStackView)
        
        $0.alignment = .center
        $0.distribution = .fillProportionally
        $0.axis = .horizontal
        $0.spacing = Metric.iconStackViewSpacing
    }
    
    lazy var briefingBlockStackView = UIStackView().then {
        $0.addArrangedSubview(iconStackView)
        $0.addArrangedSubview(descriptionLabel)
        
        $0.alignment = .center
        $0.distribution = .fill
        $0.axis = .horizontal
        $0.spacing = Metric.briefingBlockStackViewSpacing
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
    
    func bind() {
        let input = BriefingCellViewModel.Input(cellInitialized: Observable.just(()))
        let output = viewModel.transform(input)
        
        output.icon
            .drive(iconLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.state
            .drive(stateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.color
            .drive(stateLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        output.description
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    static func fittingSize(availableWidth: CGFloat) -> CGSize {
        let cell = BriefingCell()
        cell.bind()
        
        let targetSize = CGSize(width: availableWidth, height: UIView.layoutFittingCompressedSize.height)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    private func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = Metric.cornerRadius
        self.layer.masksToBounds = true
    }
    
    private func addSubviews() {
        contentView.addSubview(briefingBlockStackView)
        contentView.addSubview(redirectionArrowImageView)
    }
    
    private func setupConstraints() {
        briefingBlockStackView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(Metric.cellPadding)
            make.bottom.equalToSuperview().offset(-Metric.cellPadding)
        }
        
        redirectionArrowImageView.snp.makeConstraints { make in
//            make.left.equalTo(briefingBlockStackView.snp.right).offset(Metric.redirectionArrowPadding)
            make.right.equalToSuperview().offset(-Metric.cellPadding)
            make.centerY.equalToSuperview()
        }
        
        temperatureColorView.snp.makeConstraints { make in
            make.width.equalTo(Metric.temperatureBarWidth)
            make.height.equalTo(Metric.temperatureBarHeight)
        }
    }
}

extension BriefingCell {
    final class TemperatureColorView: UIView {
        
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
        
        func configure(briefingData: BriefingData) {
            layoutIfNeeded()
            setArrowPosition(briefingData: briefingData)
            setArrowColor(briefingData: briefingData)
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
        
        private func setArrowPosition(briefingData: BriefingData) {
            
            let temperature = briefingData.value
            
            let ratio = (CGFloat(temperature) - Metric.lowestTemperature) / (Metric.highestTemperature - Metric.lowestTemperature)
            let positionX = temperatureBar.frame.width * ratio - Metric.triangleArrowSize / 2
            
            triangleArrow.snp.makeConstraints { make in
                make.top.equalTo(temperatureBar.snp.bottom)
                make.centerX.equalTo(temperatureBar.snp.leading).offset(positionX)
                make.width.height.equalTo(Metric.triangleArrowSize)
            }
        }
        
        private func setArrowColor(briefingData: BriefingData) {
            triangleArrow.color = briefingData.color
        }
    }
}

extension BriefingCell {
    final class TemperatureBar: UIView {
        
        struct Metric {
            static let cornerRadius: CGFloat = 2
        }
        
        let gradientLayer = CAGradientLayer().then {
            $0.colors = [
                UIColor(red: 0, green: 178, blue: 255).cgColor,
                UIColor(red: 143, green: 255, blue: 0).cgColor,
                UIColor(red: 250, green: 255, blue: 0).cgColor,
                UIColor(red: 255, green: 92, blue: 0).cgColor
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
            self.layer.cornerRadius = Metric.cornerRadius
            self.layer.masksToBounds = true
        }
    }

}

extension BriefingCell {
    final class TriangleView: UIView {
        
        var color: UIColor
        var cornerRadius: CGFloat
        
        init(frame: CGRect = CGRectZero, color: UIColor = .black, cornerRadius: CGFloat = 0) {
            self.color = color
            self.cornerRadius = cornerRadius
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func draw(_ rect: CGRect) {
            let triangle = CAShapeLayer()
            triangle.fillColor = color.cgColor
            triangle.path = roundedTriangle()
            triangle.position = CGPoint(x: 0, y: 0)
            
            self.layer.addSublayer(triangle)
        }
        
        func roundedTriangle() -> CGPath {
            let widthHeight = bounds.size.height
            let point1 = CGPoint(x: widthHeight/2, y: 0)
            let point2 = CGPoint(x: widthHeight, y: widthHeight)
            let point3 =  CGPoint(x: 0, y: widthHeight)
            
            let path = CGMutablePath()
            
            path.move(to: CGPoint(x: 0, y: widthHeight))
            path.addArc(tangent1End: point1, tangent2End: point2, radius: cornerRadius)
            path.addArc(tangent1End: point2, tangent2End: point3, radius: cornerRadius)
            path.addArc(tangent1End: point3, tangent2End: point1, radius: cornerRadius)
            path.closeSubpath()
            return path
        }
    }

}
