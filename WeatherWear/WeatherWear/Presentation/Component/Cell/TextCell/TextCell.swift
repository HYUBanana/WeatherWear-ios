//
//  TextCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/31.
//

import UIKit

class TextCell: BaseCell {
    
    let label = UILabel().then {
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String?, font: AppFont, color: AppColor) {
        label.text = text
        label.font = font.font
        label.textColor = color.color
    }
}

extension TextCell: Bindable {
    func bind(with model: ViewModel) {
        guard let model = model as? TextCellViewModel else { return }
        configure(text: model.text, font: model.font, color: model.color)
    }
}
