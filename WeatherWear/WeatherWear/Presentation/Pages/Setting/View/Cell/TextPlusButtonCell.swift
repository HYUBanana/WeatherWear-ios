//
//  TextPlusButtonCell.swift
//  WeatherWear
//
//  Created by 디해 on 2023/11/03.
//

import UIKit
import RxSwift

final class TextPlusButtonCell: TextCell {
    let plusButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.tintColor = AppColor.component(.defaultGray).color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextPlusButtonCell: ContainsButton {
    var buttonTap: Observable<Void> {
        return plusButton.rx.tap
            .asObservable()
    }
}
