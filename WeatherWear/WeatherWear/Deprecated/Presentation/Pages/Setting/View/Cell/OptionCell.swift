//
//  DegreeCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/23.
//

import UIKit
import RxSwift

final class OptionCell: UICollectionViewCell, Sizeable {

    var numberOfColumns: CGFloat = 1

    struct Metric {
        static let cornerRadius: CGFloat = 20
        static let cellPadding: CGFloat = 15
        static let optionPadding: CGFloat = 10
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(options: [OptionDisplayModel]) {
        var lastView: UIView? = nil

        options.forEach { option in
            let optionView = OptionView()
            optionView.configure(option: option)
            contentView.addSubview(optionView)

            optionView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(Metric.cellPadding)
                make.right.equalToSuperview().offset(-Metric.cellPadding)

                if let lastView = lastView {
                    make.top.equalTo(lastView.snp.bottom).offset(Metric.optionPadding)
                } else {
                    make.top.equalToSuperview()
                        .offset(Metric.cellPadding)
                }
            }
            lastView = optionView
        }

        if let lastView = lastView {
            lastView.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-Metric.cellPadding)
            }
        }
    }

    private func setup() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Metric.cornerRadius
        contentView.layer.masksToBounds = true
    }
}

extension OptionCell {
    final class OptionView: UIView {

        struct Metric {
            static let cellPadding: CGFloat = 17
        }

        let optionLabel = UILabel().then {
            $0.font = AppFont.description(.D1(.semibold)).font
            $0.textColor = AppColor.text(.primaryDarkText).color
        }

        lazy var segmentControl = SettingSegmentedControl(frame: CGRectZero)

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
            addSubviews()
            setupConstraints()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func configure(option: OptionDisplayModel) {
            optionLabel.text = option.optionName
            segmentControl.configure(cases: option.optionCases, selected: option.selectedOption)
        }

        private func setup() {
            self.backgroundColor = .clear
        }

        private func addSubviews() {
            addSubview(optionLabel)
            addSubview(segmentControl)
        }

        private func setupConstraints() {
            optionLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview()
            }

            segmentControl.snp.makeConstraints { make in
                make.top.right.bottom.equalToSuperview()
            }
        }
    }
}

extension OptionCell {
    final class SettingSegmentedControl: UISegmentedControl {

        struct Metric {
            static let itemWidth: CGFloat = 66
            static let itemHeight: CGFloat = 44
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
            setupConstraints()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func configure(cases: [String], selected: Int) {

            for index in cases.indices {
                self.insertSegment(withTitle: cases[index], at: index, animated: false)
            }

            let totalWidth = Metric.itemWidth * CGFloat(cases.count)
            self.snp.updateConstraints { make in
                make.width.equalTo(totalWidth)
                make.height.equalTo(Metric.itemHeight)
            }

            self.selectedSegmentIndex = selected
        }

        private func setup() {
            self.setDividerImage(UIImage(), forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)

            self.selectedSegmentTintColor = AppColor.component(.highlightBlue).color

            let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            self.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        }

        private func setupConstraints() {
            self.snp.makeConstraints { make in
                make.width.equalTo(0)
                make.height.equalTo(0)
            }
        }
    }
}
