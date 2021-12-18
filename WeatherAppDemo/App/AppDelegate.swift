//
//  AppDelegate.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 30.11.2020.
//

import UIKit

let kLaunchedBefore = "AppLaunchedBefore"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if !UserDefaults.standard.bool(forKey: kLaunchedBefore) {
            // First launch
            PersistentSettings.bindDefaultSettings()
        }
        // Override point for customization after application launch.
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.setValue(true, forKey: kLaunchedBefore)
        UserDefaults.standard.synchronize()
    }
}
