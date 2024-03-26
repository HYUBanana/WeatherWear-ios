//
//  BaseViewController.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/16.
//

import UIKit
import SnapKit

class BaseViewController<T: UIView>: UIViewController {
    var contentView: T
    
    init(contentView: T = T()) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        self.view = contentView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
