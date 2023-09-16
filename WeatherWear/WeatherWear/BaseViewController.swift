//
//  BaseViewController.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/16.
//

import UIKit
import SnapKit

class BaseViewController<T: UIView>: UIViewController {
    var contentView: UIView { self.view }
    
    override func loadView() {
        self.view = T()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
