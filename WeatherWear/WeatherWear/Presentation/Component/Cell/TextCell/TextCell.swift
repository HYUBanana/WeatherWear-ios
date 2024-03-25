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
    
    func configure(text: String, font: AppFont, color: AppColor) {
        label.text = text
        label.font = font.font
        label.textColor = color.color
    }
}

extension TextCell: Sizeable {
    func fittingSize(availableWidth: CGFloat, with viewModel: CellViewModelType) -> CGSize {
        
        let cell = TextCell()
        viewModel.bind(to: cell)
        
        let targetSize = CGSize(width: availableWidth, height: UIView.layoutFittingCompressedSize.height)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}
