//
//  OutingTimeCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/23.
//

import UIKit
import Then

protocol OutingTimeCellDelegate: AnyObject {
    func outingTimeViewTapped(cell: OutingTimeCell)
    func outingTimeViewLongPressed(cell: OutingTimeCell, gesture: UILongPressGestureRecognizer)
}

final class OutingTimeCell: UICollectionViewCell {
    
    weak var delegate: OutingTimeCellDelegate?
    
    struct Metric {
        static let cellPadding: CGFloat = 17
        static let cornerRadius: CGFloat = 20
    }
    
    struct Font {
        static let outingTimeLabel = UIFont.systemFont(ofSize: 16)
        static let totalTimeLabel = UIFont.systemFont(ofSize: 12)
    }
    
    struct Color {
        static let outingTimeLabel = UIColor(red: 48, green: 48, blue: 48)
        static let totalTimeLabel = UIColor(red: 91, green: 91, blue: 91)
        static let blueColor = UIColor(red: 36, green: 160, blue: 237)
    }
    
    let departureTimeLabel = UILabel().then {
        $0.font = Font.outingTimeLabel
    }
    
    let arrivalTimeLabel = UILabel().then {
        $0.font = Font.outingTimeLabel
        $0.textColor = Color.outingTimeLabel
    }
    
    let totalTimeLabel = UILabel().then {
        $0.font = Font.totalTimeLabel
        $0.textColor = Color.totalTimeLabel
    }
    
    let arrowImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = .gray
    }
    
    lazy var outingStackView = UIStackView().then {
        $0.addArrangedSubview(departureTimeLabel)
        $0.addArrangedSubview(arrivalTimeLabel)
        $0.distribution = .fillEqually
        $0.axis = .vertical
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
        contentView.addSubview(outingStackView)
        contentView.addSubview(totalTimeLabel)
        contentView.addSubview(arrowImageView)
    }
    
    private func setupConstraints() {
        outingStackView.snp.makeConstraints { make in
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
    
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(viewLongPressed))
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc func viewTapped() {
        delegate?.outingTimeViewTapped(cell: self)
    }
    
    @objc func viewLongPressed(_ gesture: UILongPressGestureRecognizer) {
        delegate?.outingTimeViewLongPressed(cell: self, gesture: gesture)
    }
}
