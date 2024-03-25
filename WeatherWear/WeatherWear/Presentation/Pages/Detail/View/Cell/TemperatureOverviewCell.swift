//
//  TemperatureOverviewCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/04.
//

import UIKit

final class TemperatureOverviewCell: UICollectionViewCell {
    struct Metric {
        static let timeLocationBottomPadding: CGFloat = 10
    }
    
    let miniTemperatureView = MiniTemperatureView(frame: CGRectZero)
    
    let timeLocationLabel = UILabel().then {
        $0.font = AppFont.description(.D2(.semibold)).font
        $0.textColor = AppColor.text(.primaryDarkText).color
        $0.numberOfLines = 0
        $0.textAlignment = .right
    }
    
    let lastUpdateTimeLabel = UILabel().then {
        $0.font = AppFont.description(.D4(.regular)).font
        $0.textColor = AppColor.text(.primaryDarkText).color
    }
    
    lazy var timeStackView = UIStackView().then {
        $0.addArrangedSubview(timeLocationLabel)
        $0.addArrangedSubview(lastUpdateTimeLabel)
        $0.axis = .vertical
        $0.alignment = .trailing
        $0.distribution = .fill
        $0.spacing = Metric.timeLocationBottomPadding
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(temperature: String, highestTemperature: String, lowestTemperature: String, weather: String, weatherImage: String, timeLocation: String, lastUpdateTime: String) {
        timeLocationLabel.text = timeLocation
        lastUpdateTimeLabel.text = lastUpdateTime
        miniTemperatureView.configure(temperature: temperature, highestTemperature: highestTemperature, lowestTemperature: lowestTemperature, weather: weather, weatherImage: weatherImage)
    }
    
    private func addSubviews() {
        contentView.addSubview(miniTemperatureView)
        contentView.addSubview(timeStackView)
    }
    
    private func setupConstraints() {
        miniTemperatureView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        
        timeStackView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

extension TemperatureOverviewCell: Sizeable {
    func fittingSize(availableWidth: CGFloat, with viewModel: CellViewModelType) -> CGSize {
        let cell = TemperatureOverviewCell()
        
        viewModel.bind(to: cell)
        
        let targetSize = CGSize(width: availableWidth, height: UIView.layoutFittingCompressedSize.height)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}
