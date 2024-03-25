//
//  LogoCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/02.
//

import UIKit

final class ImageCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: String, contentMode: ImageContentMode) {
        imageView.image = UIImage(named: image)
        imageView.contentMode = contentMode.mode
    }
    
    private func addSubviews() {
        contentView.addSubview(imageView)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ImageCell: Sizeable {
    func fittingSize(availableWidth: CGFloat, with viewModel: CellViewModelType) -> CGSize {
        let cell = ImageCell()
        viewModel.bind(to: cell)
        
        let targetSize = CGSize(width: availableWidth, height: UIView.layoutFittingCompressedSize.height)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

enum ImageContentMode {
    case scaleToFill
    case scaleAspectFit
    case scaleAspectFill

    var mode: UIView.ContentMode {
        switch self {
        case .scaleToFill:
            return .scaleToFill
        case .scaleAspectFit:
            return .scaleAspectFit
        case .scaleAspectFill:
            return .scaleAspectFill
        }
    }
}
