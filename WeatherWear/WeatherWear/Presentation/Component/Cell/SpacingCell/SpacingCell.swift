//
//  SpacingCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/31.
//

import UIKit

final class SpacingCell: BaseCell {
    
    let view = UIView().then {
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(spacing: CGFloat) {
        view.snp.updateConstraints { make in
            make.height.equalTo(spacing)
        }
    }
}

extension SpacingCell: Bindable {
    func bind(with model: ViewModel) {
        guard let model = model as? SpacingCellViewModel else { return }
        configure(spacing: model.spacing)
    }
}
