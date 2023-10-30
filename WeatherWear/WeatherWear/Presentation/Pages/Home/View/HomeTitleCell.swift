//
//  MainTextCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/05.
//

import UIKit
import RxSwift

final class HomeTitleCell: UICollectionViewCell {
    
    static let identifier = "HomeTitleCell"
    
    private let viewModel: HomeTitleCellViewModel = HomeTitleCellViewModel()
    var disposeBag = DisposeBag()
    
    struct Metric {
        static let spacing1: CGFloat = 30
        static let spacing2: CGFloat = 5
        static let spacing3: CGFloat = 10
        
        static let leftPadding: CGFloat = 5
    }
    
    struct Color {
        static let dateLabel = UIColor(red: 91, green: 91, blue: 91)
        static let mainLabel = UIColor(red: 48, green: 48, blue: 48)
        static let descriptionLabel = UIColor(red: 48, green: 48, blue: 48)
    }
    
    struct Font {
        static let dateLabel = UIFont.systemFont(ofSize: 18, weight: .semibold)
        static let mainLabel = UIFont.systemFont(ofSize: 36, weight: .black)
        static let descriptionLabel = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    let spacing1 = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let dateLabel = UILabel().then {
        $0.textColor = Color.dateLabel
        $0.font = Font.dateLabel
    }
    
    let spacing2 = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let mainLabel = UILabel().then {
        $0.textColor = Color.mainLabel
        $0.font = Font.mainLabel
        $0.numberOfLines = 0
    }
    
    let spacing3 = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let descriptionLabel = UILabel().then {
        $0.textColor = Color.descriptionLabel
        $0.font = Font.descriptionLabel
        $0.numberOfLines = 0
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
    
    func bind() {
        let input = HomeTitleCellViewModel.Input(cellInitialized: Observable.just(()))
        let output = viewModel.transform(input)
        
        output.date
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.mainText
            .drive(mainLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.description
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    static func fittingSize(availableWidth: CGFloat) -> CGSize {
        let cell = HomeTitleCell()
        
        cell.bind()
        
        let targetSize = CGSize(width: availableWidth, height: UIView.layoutFittingCompressedSize.height)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    private func setup() {
        self.backgroundColor = .clear
    }
    
    private func addSubviews() {
        contentView.addSubview(spacing1)
        contentView.addSubview(dateLabel)
        contentView.addSubview(spacing2)
        contentView.addSubview(mainLabel)
        contentView.addSubview(spacing3)
        contentView.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        spacing1.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(Metric.spacing1)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(spacing1.snp.bottom)
            make.left.equalToSuperview().offset(Metric.leftPadding)
            make.right.equalToSuperview()
        }
        
        spacing2.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(Metric.spacing2)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(spacing2.snp.bottom)
            make.left.equalToSuperview().offset(Metric.leftPadding)
            make.right.equalToSuperview()
        }
        
        spacing3.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(Metric.spacing3)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(spacing3.snp.bottom)
            make.left.equalToSuperview().offset(Metric.leftPadding)
            make.right.bottom.equalToSuperview()
        }
    }
}
