//
//  ComfortIndexCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/06.
//

import UIKit
import RxSwift

final class ComfortIndexCell: UICollectionViewCell {

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
        $0.font = AppFont.header(.H3(.bold)).font
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

    func configure(icon: String, title: String, value: Int, state: String, degreeColor: AppColor) {
        titleLabel.text = title
        stateLabel.text = state
        stateLabel.textColor = degreeColor.color
        iconView.configure(icon: icon, value: value, degreeColor: degreeColor)
    }
    
    private func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = Metric.cornerRadius
        self.clipsToBounds = true
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

extension ComfortIndexCell: Sizeable {
    func fittingSize(availableWidth: CGFloat, with viewModel: CellViewModelType) -> CGSize {
        let cell = ComfortIndexCell()
        viewModel.bind(to: cell)
        
        let targetSize = CGSize(width: availableWidth / 2 - 8, height: UIView.layoutFittingCompressedSize.height)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
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
        
        func configure(icon: String, value: Int, degreeColor: AppColor) {
            iconLabel.text = icon
            degreeColorView.backgroundColor = degreeColor.color.withAlphaComponent(0.4)
            
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
