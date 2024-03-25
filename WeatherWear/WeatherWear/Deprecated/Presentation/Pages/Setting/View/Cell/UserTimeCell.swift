//
//  OutingTimeCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/23.
//

import UIKit
import RxSwift

final class UserTimeCell: BaseCell, Sizeable {

    var numberOfColumns: CGFloat = 1

    struct Metric {
        static let cellPadding: CGFloat = 17
        static let cornerRadius: CGFloat = 20
    }

    let timeScheduleLabel = UILabel().then {
        $0.font = AppFont.description(.D1(.regular)).font
        $0.textColor = AppColor.text(.primaryDarkText).color
        $0.numberOfLines = 0
    }

    let totalTimeLabel = UILabel().then {
        $0.font = AppFont.description(.D3(.regular)).font
        $0.textColor = AppColor.text(.tertiaryDarkText).color
    }

    let arrowImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = AppColor.component(.defaultGray).color
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

    func configure(timeSchedule: String, totalTime: String) {
        timeScheduleLabel.text = timeSchedule
        totalTimeLabel.text = totalTime
    }

    private func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = Metric.cornerRadius
    }

    private func addSubviews() {
        contentView.addSubview(timeScheduleLabel)
        contentView.addSubview(totalTimeLabel)
        contentView.addSubview(arrowImageView)
    }

    private func setupConstraints() {
        timeScheduleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(Metric.cellPadding)
            make.bottom.equalToSuperview().offset(-Metric.cellPadding)
        }

        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Metric.cellPadding)
            make.centerY.equalToSuperview()
        }

        totalTimeLabel.snp.makeConstraints { make in
            make.right.equalTo(arrowImageView.snp.left).offset(-5)
            make.centerY.equalToSuperview()
        }
    }
}

extension UserTimeCell: Touchable {
    var touch: Observable<Void> {
        return self.rx.tapGesture()
            .when(.recognized)
            .asObservable()
            .map { _ in }
    }
}

extension UserTimeCell {
    func showAlert(to viewController: UIViewController) {
        let alertController = UIAlertController(title: "", message: "대충 시간 설정하는 화면", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alertController, animated: true)
    }
}
