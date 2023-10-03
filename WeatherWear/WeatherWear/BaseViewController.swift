//
//  BaseViewController.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/16.
//

import UIKit
import SnapKit

class BaseViewController<T: UIView>: UIViewController {
    var contentView: T!
    
    override func loadView() {
        contentView = T(frame: UIScreen.main.bounds)
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
