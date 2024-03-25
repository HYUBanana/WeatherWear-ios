//
//  UserLocationView.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/22.
//

import UIKit
import RxSwift

class LocationCell: UICollectionViewCell {
    
    struct Metric {
        static let cellPadding: CGFloat = 17
        static let cornerRadius: CGFloat = 20
    }
    
    lazy var radioButton = UIButton().then {
        $0.setImage(UIImage(systemName: "circle")?.withTintColor(AppColor.component(.defaultGray).color, renderingMode: .alwaysOriginal), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.circle.fill")?.withTintColor(AppColor.component(.highlightBlue).color, renderingMode: .alwaysOriginal), for: .selected)
    }
    
    let locationLabel = UILabel().then {
        $0.font = AppFont.description(.D1(.semibold)).font
        $0.textColor = AppColor.text(.primaryDarkText).color
    }
    
    let timeLabel = UILabel().then {
        $0.font = AppFont.description(.D3(.medium)).font
        $0.textColor = AppColor.text(.tertiaryDarkText).color
    }
    
    let temperatureLabel = UILabel().then {
        $0.font = AppFont.description(.D1(.regular)).font
        $0.textColor = AppColor.text(.tertiaryDarkText).color
    }
    
    let weatherLabel = UILabel().then {
        $0.font = AppFont.description(.D3(.regular)).font
        $0.textColor = AppColor.text(.tertiaryDarkText).color
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(location: String, time: String, temperature: String, weather: String) {
        locationLabel.text = location
        timeLabel.text = time
        temperatureLabel.text = temperature
        weatherLabel.text = weather
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
    }
}

extension LocationCell: Sizeable {
    func fittingSize(availableWidth: CGFloat, with viewModel: CellViewModelType) -> CGSize {
        let cell = LocationCell()
        
        viewModel.bind(to: cell)
        
        let targetSize = CGSize(width: availableWidth, height: UIView.layoutFittingCompressedSize.height)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

extension LocationCell {
    func toggleSelected() {
        radioButton.isSelected.toggle()
    }
}
