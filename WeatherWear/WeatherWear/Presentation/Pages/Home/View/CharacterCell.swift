//
//  CharacterCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/05.
//

import UIKit

protocol CharacterCellDelegate: AnyObject {
    func downloadButtonTapped()
}

final class CharacterCell: UICollectionViewCell {
    
    static let identifier = "CharacterCell"
    
    weak var delegate: CharacterCellDelegate?
    
    var isVisible: Bool = true
    
    struct Metric {
        static let temperatureStackViewTopPadding: CGFloat = 10
        static let temperatureStackViewLeadingPadding: CGFloat = 20
        static let weatherStackViewTopPadding: CGFloat = 0
        static let weatherStackViewLeadingPadding: CGFloat = 20
        static let weatherStackViewSpacing: CGFloat = 5
        static let locationUpdateStackViewTopPadding: CGFloat = 20
        static let locationUpdateStackViewTrailingPadding: CGFloat = 20
        static let downloadCharacterButtonBottomPadding: CGFloat = 20
        static let downloadCharacterButtonTrailingPadding: CGFloat = 20
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
    
    let characterImageView = UIImageView(image: UIImage(named: "Character"))
    
    let backgroundImageView = UIImageView(image: UIImage(named: "CharacterBackground")).then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    lazy var downloadButton = UIButton().then {
        var newImage = UIImage(systemName: "arrow.down.square.fill")?.resizedImage(Size: CGSize(width: 30, height: 27))
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
        $0.spacing = 5
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
    
    private func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
    
    private func addSubviews() {
        addSubview(characterImageView)
        addSubview(temperatureStackView)
        addSubview(weatherStackView)
        addSubview(locationUpdateStackView)
        addSubview(backgroundImageView)
        addSubview(advicePositionView)
        addSubview(downloadButton)
        
        self.sendSubviewToBack(backgroundImageView)
    }
    
    private func setupConstraints() {
        characterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        temperatureStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.temperatureStackViewLeadingPadding)
            make.top.equalToSuperview().offset(Metric.temperatureStackViewTopPadding)
        }
        
        weatherStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.weatherStackViewLeadingPadding)
            make.top.equalTo(temperatureStackView.snp.bottom).offset(Metric.weatherStackViewTopPadding)
        }
        
        locationUpdateStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Metric.locationUpdateStackViewTrailingPadding)
            make.top.equalToSuperview().offset(Metric.locationUpdateStackViewTopPadding)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Metric.downloadCharacterButtonTrailingPadding)
            make.bottom.equalToSuperview().offset(-Metric.downloadCharacterButtonBottomPadding)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        advicePositionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
