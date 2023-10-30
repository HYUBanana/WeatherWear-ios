//
//  UserLocationView.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/22.
//

import UIKit
import Then

protocol UserLocationCellDelegate: AnyObject {
    func radioButtonTapped(cell: UserLocationCell)
    func radioButtonLongPressed(cell: UserLocationCell, gesture: UILongPressGestureRecognizer)
}

class UserLocationCell: UICollectionViewCell {
    
    weak var delegate: UserLocationCellDelegate?
    
    struct Metric {
        static let cellPadding: CGFloat = 17
        static let cornerRadius: CGFloat = 20
    }
    
    struct Font {
        static let locationLabel = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let timeLabel = UIFont.systemFont(ofSize: 12)
        static let temperatureLabel = UIFont.systemFont(ofSize: 16)
        static let weatherLabel = UIFont.systemFont(ofSize: 12)
    }
    
    struct Color {
        static let locationLabel = UIColor(red: 48, green: 48, blue: 48)
        static let timeLabel = UIColor(red: 91, green: 91, blue: 91)
        static let temperatureLabel = UIColor(red: 91, green: 91, blue: 91)
        static let weatherLabel = UIColor(red: 91, green: 91, blue: 91)
        static let blueColor = UIColor(red: 36, green: 160, blue: 237)
        static let buttonTappedColor = UIColor(red: 250, green: 250, blue: 250)
    }
    
    lazy var radioButton = UIButton().then {
        $0.setImage(UIImage(systemName: "circle")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.circle.fill")?.withTintColor(Color.blueColor, renderingMode: .alwaysOriginal), for: .selected)
    }
    
    let locationLabel = UILabel().then {
        $0.font = Font.locationLabel
        $0.textColor = Color.locationLabel
    }
    
    let timeLabel = UILabel().then {
        $0.font = Font.timeLabel
        $0.textColor = Color.timeLabel
    }
    
    let temperatureLabel = UILabel().then {
        $0.font = Font.temperatureLabel
        $0.textColor = Color.temperatureLabel
    }
    
    let weatherLabel = UILabel().then {
        $0.font = Font.weatherLabel
        $0.textColor = Color.weatherLabel
    }
    
    lazy var frontStackView = UIStackView().then {
        $0.addArrangedSubview(locationLabel)
        $0.addArrangedSubview(timeLabel)
        $0.axis = .vertical
        $0.distribution = .equalSpacing
    }
    
    lazy var backStackView = UIStackView().then {
        $0.addArrangedSubview(temperatureLabel)
        $0.addArrangedSubview(weatherLabel)
        $0.axis = .vertical
        $0.alignment = .trailing
        $0.distribution = .equalSpacing
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
        self.layer.cornerRadius = Metric.cornerRadius
    }
    
    private func addSubviews() {
        contentView.addSubview(radioButton)
        contentView.addSubview(frontStackView)
        contentView.addSubview(backStackView)
    }
    
    private func setupConstraints() {
        
        radioButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.cellPadding)
            make.centerY.equalToSuperview()
        }
        
        frontStackView.snp.makeConstraints { make in
            make.left.equalTo(radioButton.snp.right).offset(Metric.cellPadding)
            make.top.equalToSuperview().offset(Metric.cellPadding)
            make.bottom.equalToSuperview().offset(-Metric.cellPadding)
        }
        
        backStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Metric.cellPadding)
            make.top.equalToSuperview().offset(Metric.cellPadding)
            make.bottom.equalToSuperview().offset(-Metric.cellPadding)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
    }
    
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(radioButtonTapped))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(radioButtonLongPressed))
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc func radioButtonTapped() {
        delegate?.radioButtonTapped(cell: self)
    }
    
    @objc func radioButtonLongPressed(_ gesture: UILongPressGestureRecognizer) {
        delegate?.radioButtonLongPressed(cell: self, gesture: gesture)
    }
}
