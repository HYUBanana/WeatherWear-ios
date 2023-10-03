//
//  DegreeCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/23.
//

import UIKit

final class OptionCell: UICollectionViewCell {
    
    struct Metric {
        static let cellPadding: CGFloat = 17
    }
    
    struct Font {
        static let degreeTitle = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    struct Color {
        static let degreeTitle = UIColor(red: 48.0 / 255.0,
                                         green: 48.0 / 255.0,
                                         blue: 48.0 / 255.0,
                                         alpha: 1.0)
    }
    
    let degreeTitle = UILabel().then {
        $0.font = Font.degreeTitle
        $0.textColor = Color.degreeTitle
    }
    
    lazy var segmentControl = SettingSegmentedControl(items: [])
    
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
    
    private func setup() {
        self.backgroundColor = .clear
    }
    
    private func addSubviews() {
        addSubview(degreeTitle)
        addSubview(segmentControl)
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
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
