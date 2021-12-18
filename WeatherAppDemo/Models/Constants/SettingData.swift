//
//  SettingData.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 3.12.2020.
//

import Foundation

public protocol SettingsDataType {
    var value: String { get }
}

public enum SettingsTableItemInputType {
    case alert
    case picker
}

extension Int: SettingsDataType {
    public var value: String {
        return String(self)
    }
}

public enum ForecastUnit: String, CaseIterable, SettingsDataType {
    case standard
    case metric
    case imperial

    var toTempUnit: Unit {
        switch self {
        case .metric:
            return UnitTemperature.celsius
        case .imperial:
            return UnitTemperature.fahrenheit
        default:
            return UnitTemperature.kelvin
        }
    }

    public var value: String {
        return self.rawValue.capitalized
    }
}

public enum ForecastResponseMode: String, CaseIterable, SettingsDataType {
    case json
    case xml

    public var value: String {
        return self.rawValue.uppercased()
    }
}

public enum ForecastLanguage: String, CaseIterable, SettingsDataType {
    case english = "en"
    case german = "de"
    case turkish = "tr"

    public init(rawValue: String) {
        let pruned = rawValue.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch pruned {
        case "en", "english", "en-US", "en-UK":
            self = .english
        case "de", "german":
            self = .german
        case "tr", "turkish":
            self = .turkish
        default:
            self = .english
        }
    }

    public var value: String {
        switch self {
        case .german:
            return NSLocalizedString("german", comment: "").capitalized
        case .turkish:
            return NSLocalizedString("turkish", comment: "").capitalized
        default:
            return NSLocalizedString("english", comment: "").capitalized
        }
    }
}
