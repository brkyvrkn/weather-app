//
//  PersistentSettings.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 3.12.2020.
//

import Foundation

// MARK: - Class Bone
public class PersistentSettings {
    private static let cntKey = "kCnt"
    private static let modeKey = "kMode"
    private static let langKey = "kLang"
    private static let unitKey = "kUnits"
    public class func bindDefaultSettings() {
        let settingsDict = FileAccessManager.shared.readPListInBundle(name: "AppSettings") as! Dictionary<String, Any>
        UserDefaults.standard.setValuesForKeys(settingsDict)
    }
}

// MARK: - Getters
extension PersistentSettings {
    public class func getForecastCount() -> Int {
        return UserDefaults.standard.value(forKey: cntKey) as? Int ?? 40
    }
    public class func getForecastResponseMode() -> ForecastResponseMode {
        return ForecastResponseMode(rawValue: UserDefaults.standard.string(forKey: modeKey) ?? "") ?? .json
    }
    public class func getForecastLanguage() -> ForecastLanguage {
        return ForecastLanguage(rawValue: UserDefaults.standard.string(forKey: langKey) ?? "en")
    }
    public class func getForecastUnits() -> ForecastUnit {
        return ForecastUnit(rawValue: UserDefaults.standard.string(forKey: unitKey) ?? "") ?? .standard
    }
}

// MARK: - Setters
extension PersistentSettings {
    public class func setCnt(_ value: Int?) {
        UserDefaults.standard.setValue(value, forKey: cntKey)
    }
    public class func setForecastResponseMode(_ value: ForecastResponseMode?) {
        if let mode = value {
            UserDefaults.standard.setValue(mode.rawValue, forKey: modeKey)
        }
    }
    public class func setForecastLanguage(_ value: ForecastLanguage) {
        UserDefaults.standard.setValue(value.rawValue, forKey: langKey)
    }
    public class func setForecastUnits(_ value: ForecastUnit?) {
        if let unit = value {
            UserDefaults.standard.setValue(unit.rawValue, forKey: unitKey)
        }
    }
}
