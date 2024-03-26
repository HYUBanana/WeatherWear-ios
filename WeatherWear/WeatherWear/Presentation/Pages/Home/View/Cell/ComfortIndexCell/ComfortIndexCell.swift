//
//  ComfortIndexCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/06.
//

import UIKit
import Then
import RxSwift

final class ComfortIndexCell: BaseCell {

    struct Metric {
        static let cellSpacing: CGFloat = 15
        
        static let cellVerticalPadding: CGFloat = 20
        static let cellHorizontalPadding: CGFloat = 15
        static let innerIndexIconPadding: CGFloat = 10
        static let innerIndexPadding: CGFloat = 2
        static let cornerRadius: CGFloat = 20
    }
    
    let iconView = ComfortIconView()

    let titleLabel = UILabel().then {
        $0.font = AppFont.description(.D3(.semibold)).font
        $0.textColor = AppColor.text(.secondaryDarkText).color
    }

    let stateLabel = UILabel().then {
        $0.font = AppFont.header(.H4(.bold)).font
    }

    lazy var indexStackView = UIStackView().then {
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(stateLabel)

        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fill
        $0.spacing = Metric.innerIndexPadding
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

    func configure(data: ComfortIndexCellData) {
        guard let intensity = data.intensity else { return }
        titleLabel.text = data.name
        stateLabel.text = intensity.state
        stateLabel.textColor = intensity.color.color
        
        iconView.configure(data: data)
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
        contentView.addSubview(iconView)
        contentView.addSubview(indexStackView)
    }

    private func setupConstraints() {
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Metric.cellHorizontalPadding)
            make.top.equalToSuperview().offset(Metric.cellVerticalPadding)
            make.bottom.equalToSuperview().offset(-Metric.cellVerticalPadding)
        }
        
        indexStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconView.snp.right).offset(Metric.innerIndexIconPadding)
        }
    }
}

extension ComfortIndexCell {
    final class ComfortIconView: UIView {
        struct Metric {
            static let iconViewSize: CGFloat = 50
            
            static let highestDegree: Int = 50
            static let lowestDegree: Int = 0
        }
        
        let iconLabel = UILabel().then {
            $0.font = AppFont.header(.H2(.regular)).font
        }
        
        let degreeColorView = UIView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
            addSubviews()
            setupConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            layer.cornerRadius = frame.size.width / 2
        }
        
        func configure(data: ComfortIndexCellData) {
            guard let value = data.value, let intensity = data.intensity else { return }
            iconLabel.text = data.icon
            degreeColorView.backgroundColor = intensity.color.color.withAlphaComponent(0.4)
            
            let percentageWidth = (Metric.iconViewSize) / CGFloat(Metric.highestDegree - Metric.lowestDegree)
            let height = CGFloat(value) * percentageWidth
            
            degreeColorView.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
        }
        
        private func setup() {
            backgroundColor = AppColor.component(.lightGray).color
            clipsToBounds = true
        }
        
        private func addSubviews() {
            addSubview(degreeColorView)
            addSubview(iconLabel)
        }
        
        private func setupConstraints() {
            self.snp.makeConstraints { make in
                make.height.width.equalTo(Metric.iconViewSize)
            }
            
            iconLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            
            degreeColorView.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(0)
            }
        }
    }
}

extension ComfortIndexCell: Bindable {
    func bind(with model: ViewModel) {
        guard let model = model as? ComfortIndexCellViewModel else { return }
        configure(data: model.data)
    }
}
