//
//  AppDelegate.swift
//  WeatherWear
//
//  Created by 디해 on 2023/09/16.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        
        LocationService.shared.updateLocation()
        
//        let encoder = JSONEncoder()
//        let defaultUnitsData = UserUnits(temperatureUnit: "°C",
//                                         windUnit: "m/s")
//        let defaultOptionsData = UserOptions(todayBriefing: "자동",
//                                             detail: "자동")
//        guard let encodedDefaultUnitsData = try? encoder.encode(defaultUnitsData) else { return false }
//        guard let encodedDefaultOptionsData = try? encoder.encode(defaultOptionsData) else { return false }
//
//        let defaults = [UserDefaultsKeys.units._kvcKeyPathString!: encodedDefaultUnitsData, UserDefaultsKeys.options._kvcKeyPathString!: encodedDefaultOptionsData]
//
//        UserDefaults.standard.register(defaults: defaults)
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

