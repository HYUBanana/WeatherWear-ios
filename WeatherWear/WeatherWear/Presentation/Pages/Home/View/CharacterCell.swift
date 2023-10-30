//
//  CharacterCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/05.
//

import UIKit
import RxSwift

protocol CharacterCellDelegate: AnyObject {
    func downloadButtonTapped()
}

final class CharacterCell: UICollectionViewCell {
    
    static let identifier = "CharacterCell"
    
    weak var delegate: CharacterCellDelegate?
    
    var isVisible: Bool = true
    
    private let viewModel: CharacterCellViewModel = CharacterCellViewModel()
    var disposeBag = DisposeBag()
    
    struct Metric {
        static let cornerRadius: CGFloat = 20
        static let cellHeight: CGFloat = 430
        
        static let verticalPadding: CGFloat = 20
        static let horizontalPadding: CGFloat = 20
        static let smallVerticalPadding: CGFloat = 10
        
        static let weatherStackViewTopPadding: CGFloat = 0
        static let weatherStackViewSpacing: CGFloat = 5
        
        static let temperatureRangePadding: CGFloat = 5
        
        static let downloadButtonWidth: CGFloat = 30
        static let downloadButtonHeight: CGFloat = 27
    }
    
    struct Color {
        static let temperatureLabel = UIColor(red: 91, green: 91, blue: 91)
        static let highestTemperatureLabel = UIColor(red: 244, green: 86, blue: 86)
        static let lowestTemperatureLabel = UIColor(red: 36, green: 160, blue: 237)
        static let weatherLabel = UIColor(red: 34, green: 34, blue: 34)
        static let locationLabel = UIColor(red: 143, green: 143, blue: 143)
        static let lastUpdateDateLabel = UIColor(red: 143, green: 143, blue: 143)
        static let downloadCharacterButton = UIColor.lightGray
    }
    
    struct Font {
        static let temperatureLabel = UIFont.systemFont(ofSize: 48, weight: .bold)
        static let highestTemperatureLabel = UIFont.systemFont(ofSize: 18, weight: .semibold)
        static let lowestTemperatureLabel = UIFont.systemFont(ofSize: 18, weight: .semibold)
        static let weatherLabel = UIFont.systemFont(ofSize: 16)
        static let locationLabel = UIFont.systemFont(ofSize: 11)
        static let lastUpdateDateLabel = UIFont.systemFont(ofSize: 9)
    }
    
    let temperatureLabel = UILabel().then {
        $0.textColor = Color.temperatureLabel
        $0.font = Font.temperatureLabel
    }
    
    let highestTemperatureLabel = UILabel().then {
        $0.textColor = Color.highestTemperatureLabel
        $0.font = Font.highestTemperatureLabel
    }
    
    let lowestTemperatureLabel = UILabel().then {
        $0.textColor = Color.lowestTemperatureLabel
        $0.font = Font.lowestTemperatureLabel
    }
    
    let weatherLabel = UILabel().then {
        $0.font = Font.weatherLabel
        $0.textColor = Color.weatherLabel
    }
    
    let locationLabel = UILabel().then {
        $0.font = Font.locationLabel
        $0.textColor = Color.locationLabel
    }
    
    let lastUpdateDateLabel = UILabel().then {
        $0.font = Font.lastUpdateDateLabel
        $0.textColor = Color.lastUpdateDateLabel
    }
    
    let advicePositionView = AdvicePositionView(frame: CGRectZero)
    
    let weatherImageView = UIImageView()
    
    let characterImageView = UIImageView(image: UIImage(named: "Character")).then {
        $0.contentMode = .scaleAspectFill
    }
    
    let backgroundImageView = UIImageView(image: UIImage(named: "CharacterBackground")).then {
        $0.alpha = 0.6
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    lazy var downloadButton = UIButton().then {
        var newImage = UIImage(systemName: "arrow.down.square.fill")?.resizedImage(Size: CGSize(width: Metric.downloadButtonWidth, height: Metric.downloadButtonHeight))
        newImage = newImage?.withRenderingMode(.alwaysTemplate)
        $0.setImage(newImage, for: .normal)
        $0.tintColor = Color.downloadCharacterButton
        $0.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
    }
    
    lazy var weatherStackView = UIStackView().then {
        $0.addArrangedSubview(weatherLabel)
        $0.addArrangedSubview(weatherImageView)
        
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = Metric.weatherStackViewSpacing
    }
    
    lazy var locationUpdateStackView = UIStackView().then {
        $0.addArrangedSubview(locationLabel)
        $0.addArrangedSubview(lastUpdateDateLabel)
        
        $0.axis = .vertical
        $0.alignment = .trailing
        $0.distribution = .fill
    }
    
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
        $0.spacing = Metric.temperatureRangePadding
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addSubviews()
        setupConstraints()
        
        addGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        let input = CharacterCellViewModel.Input(cellInitialized: Observable.just(()))
        let output = viewModel.transform(input)
        
        output.temperature
            .drive(temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.highestTemperature
            .drive(highestTemperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.lowestTemperature
            .drive(lowestTemperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.weatherCondition
            .drive(weatherLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.weatherConditionImage
            .drive(weatherImageView.rx.image)
            .disposed(by: disposeBag)
        
        output.location
            .drive(locationLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.lastUpdateDate
            .drive(lastUpdateDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.faceAdvice.drive(advicePositionView.faceAdvice.titleAdviceLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.faceDescription
            .drive(advicePositionView.faceAdvice.subAdviceLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.clothesAdvice
            .drive(advicePositionView.clothesAdvice.titleAdviceLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.clothesDescription
            .drive(advicePositionView.clothesAdvice.subAdviceLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.itemAdvice
            .drive(advicePositionView.itemAdvice.titleAdviceLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.itemDescription
            .drive(advicePositionView.itemAdvice.subAdviceLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    static func fittingSize(availableWidth: CGFloat) -> CGSize {
        let cell = CharacterCell()
        cell.bind()
        
        let targetSize = CGSize(width: availableWidth, height: UIView.layoutFittingCompressedSize.height)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    private func setup() {
        self.layer.cornerRadius = Metric.cornerRadius
        self.layer.masksToBounds = true
    }
    
    private func addSubviews() {
        contentView.addSubview(characterImageView)
        contentView.addSubview(temperatureStackView)
        contentView.addSubview(weatherStackView)
        contentView.addSubview(locationUpdateStackView)
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(advicePositionView)
        contentView.addSubview(downloadButton)
        
        contentView.sendSubviewToBack(backgroundImageView)
    }
    
    private func setupConstraints() {
        characterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(Metric.cellHeight)
        }
        
        temperatureStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.horizontalPadding)
            make.top.equalToSuperview().offset(Metric.smallVerticalPadding)
        }
        
        weatherStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.horizontalPadding)
            make.top.equalTo(temperatureStackView.snp.bottom).offset(Metric.weatherStackViewTopPadding)
        }
        
        locationUpdateStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Metric.horizontalPadding)
            make.top.equalToSuperview().offset(Metric.verticalPadding)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Metric.horizontalPadding)
            make.bottom.equalToSuperview().offset(-Metric.verticalPadding)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(Metric.cellHeight)
        }
        
        advicePositionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(Metric.cellHeight)
        }
    }
    
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped() {
        if isVisible {
            hideViewWithAnimation()
        } else {
            showViewWithAnimation()
        }
        isVisible.toggle()
    }
    
    @objc func downloadButtonTapped() {
        delegate?.downloadButtonTapped()
    }
    
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
        
        struct Color {
            static let titleAdviceLabel = UIColor(red: 48, green: 48, blue: 48)
            static let subAdviceLabel = UIColor(red: 91, green: 91, blue: 91)
            static let backgroundView = UIColor(red: 255, green: 255, blue: 255, alpha: 0.8)
        }
        
        struct Font {
            static let titleAdviceLabel = UIFont.systemFont(ofSize: 17, weight: .bold)
            static let subAdviceLabel = UIFont.systemFont(ofSize: 13, weight: .semibold)
        }
        
        let titleAdviceLabel = UILabel().then {
            $0.textColor = Color.titleAdviceLabel
            $0.font = Font.titleAdviceLabel
        }
        
        let subAdviceLabel = UILabel().then {
            $0.textColor = Color.subAdviceLabel
            $0.font = Font.subAdviceLabel
        }
        
        lazy var stackView = UIStackView().then {
            $0.addArrangedSubview(titleAdviceLabel)
            $0.addArrangedSubview(subAdviceLabel)
            $0.axis = .vertical
            $0.alignment = .leading
            $0.distribution = .fill
            $0.spacing = Metric.adviceSpacing
        }
        
        lazy var backgroundView = UIView().then {
            $0.backgroundColor = Color.backgroundView
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
