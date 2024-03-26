//
//  LogoCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/02.
//

import UIKit

final class ImageCell: BaseCell {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: String) {
        imageView.image = UIImage(named: image)
        imageView.contentMode = .scaleAspectFit
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

extension ImageCell: Bindable {
    func bind(with model: ViewModel) {
        guard let model = model as? ImageCellViewModel else { return }
        configure(image: model.image)
    }
}
