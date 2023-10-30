//
//  TabBarController.swift
//  WeatherWear
//
//  Created by 디해 on 2023/10/04.
//

import UIKit

class TabBarController: UITabBarController {
    
    let provider: ServiceProviderType
    
    lazy var shadowView = UIView().then {
        $0.frame = tabBar.frame
        $0.layer.shadowColor = Color.shadowColor.cgColor
        $0.layer.shadowOpacity = Metric.shadowOpacity
        $0.layer.shadowOffset = Metric.shadowOffset
        $0.layer.shadowRadius = Metric.shadowRadius
        $0.layer.shadowPath = UIBezierPath(roundedRect: tabBar.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: Metric.tabBarRadius, height: Metric.tabBarRadius)).cgPath
    }
    
    struct Metric {
        static let imageInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 2, bottom: 0, right: 2)
        static let tabBarHeight: CGFloat = 90
        static let tabBarRadius: CGFloat = 20
        static let shadowOpacity: Float = 0.05
        static let shadowOffset: CGSize = CGSize(width: 0, height: -3)
        static let shadowRadius: CGFloat = 4.0
    }
    
    struct Font {
        static let tabBarItemTitle = UIFont.systemFont(ofSize: 11, weight: .semibold)
    }
    
    struct Color {
        static let normalColor = UIColor(red: 143, green: 143, blue: 143)
        static let selectedColor = UIColor(red: 48, green: 48, blue: 48)
        static let shadowColor = UIColor.black
    }
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViewControllers()
        customizeTabBar()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = Metric.tabBarHeight
        tabFrame.origin.y = self.view.frame.size.height - Metric.tabBarHeight
        self.tabBar.frame = tabFrame
        self.shadowView.frame = tabFrame
    }
    
    private func addViewControllers() {
        let homeViewController = HomeViewController(provider: provider)
        configureTabBarItem(viewController: homeViewController, with: .home)
        
        let detailViewController = DetailViewController()
        configureTabBarItem(viewController: detailViewController, with: .detail)
        
        let weekViewController = ViewController()
        configureTabBarItem(viewController: weekViewController, with: .week)
        
        let settingViewController = SettingViewController()
        configureTabBarItem(viewController: settingViewController, with: .setting)
        
        self.viewControllers = [homeViewController, detailViewController, weekViewController, settingViewController]
    }
    
    private func configureTabBarItem(viewController: UIViewController, with item: TabBarItem) {
        let normalImage = item.normalImage?.withRenderingMode(.alwaysOriginal)
        let selectedImage = item.selectedImage?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem = UITabBarItem(title: item.title, image: normalImage, selectedImage: selectedImage)
        viewController.tabBarItem.imageInsets = Metric.imageInsets
    }
    
    private func customizeTabBar() {
        let systemFontAttributes = [NSAttributedString.Key.font: Font.tabBarItemTitle]
        UITabBarItem.appearance().setTitleTextAttributes(systemFontAttributes, for: .normal)
        
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        self.tabBar.unselectedItemTintColor = Color.normalColor
        self.tabBar.tintColor = Color.selectedColor
        
        self.tabBar.layer.cornerRadius = Metric.tabBarRadius
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.clipsToBounds = true
        
        view.insertSubview(shadowView, belowSubview: tabBar)
        
    }
}
