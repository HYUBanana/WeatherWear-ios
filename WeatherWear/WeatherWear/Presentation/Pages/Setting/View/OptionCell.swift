//
//  DegreeCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/23.
//

import UIKit
import RxSwift

final class OptionCell: UICollectionViewCell {
    
    static let identifier = "OptionCell"
    
    private let viewModel: OptionCellViewModel = OptionCellViewModel()
    var disposeBag = DisposeBag()
    
    struct Metric {
        static let cellPadding: CGFloat = 17
    }
    
    struct Font {
        static let degreeTitle = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    struct Color {
        static let degreeTitle = UIColor(red: 48, green: 48, blue: 48)
    }
    
    let degreeTitle = UILabel().then {
        $0.font = Font.degreeTitle
        $0.textColor = Color.degreeTitle
    }
    
    lazy var segmentControl = SettingSegmentedControl(items: ["자동", "수동"])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.segmentControl.frame.contains(point) {
            return self.segmentControl
        }
        return super.hitTest(point, with: event)
    }
    
    func bind() {
        let input = OptionCellViewModel.Input(cellInitialized: Observable.just(()))
        let output = viewModel.transform(input)
        
        output.title
            .drive(degreeTitle.rx.text)
            .disposed(by: disposeBag)
    }
    
    static func fittingSize(availableWidth: CGFloat) -> CGSize {
        let cell = OptionCell()
        cell.bind()
        
        let targetSize = CGSize(width: availableWidth, height: UIView.layoutFittingCompressedSize.height)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    private func setup() {
        self.backgroundColor = .clear
    }
    
    private func addSubviews() {
        contentView.addSubview(degreeTitle)
        contentView.addSubview(segmentControl)
    }
    
    private func setupConstraints() {
        degreeTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        segmentControl.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(150)
        }
    }
}

extension OptionCell {
    final class SettingSegmentedControl: UISegmentedControl {
        
        struct Color {
            static let blueColor = UIColor(red: 36, green: 160, blue: 237)
        }
        
        override init(items: [Any]?) {
            super.init(items: items)
            setup()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setup() {
            self.setDividerImage(UIImage(), forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
            
            self.selectedSegmentTintColor = Color.blueColor
            
            let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            self.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        }
    }
}

final class OptionCollectionView: UICollectionViewCell {
    
    struct Metric {
        static let collectionViewPadding: CGFloat = 17
        static let cellSpacing: CGFloat = 15
        static let cornerRadius: CGFloat = 20
    }
    
    var dataSource: UICollectionViewDataSource?
    var delegate: UICollectionViewDelegate?
    
    let layout = UICollectionViewFlowLayout().then {
        $0.sectionInset = UIEdgeInsets(top: Metric.collectionViewPadding,
                                       left: Metric.collectionViewPadding,
                                       bottom: Metric.collectionViewPadding,
                                       right: Metric.collectionViewPadding)
        $0.minimumLineSpacing = Metric.cellSpacing
    }
    
    lazy var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout).then {
        $0.register(OptionCell.self, forCellWithReuseIdentifier: "OptionCell")
        $0.backgroundColor = .clear
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
    
    private func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = Metric.cornerRadius
    }
    
    private func addSubviews() {
        contentView.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
