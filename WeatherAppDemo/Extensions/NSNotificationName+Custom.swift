//
//  NSNotificationName+Custom.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 6.12.2020.
//

import Foundation

extension NSNotification.Name {
    public static let settingsDidUpdate: NSNotification.Name = {
        return NSNotification.Name("ForecastSettingsDidUpdate")
    }()
}
