//
//  SettingsTableViewCellModel.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 6.12.2020.
//

import Foundation
import UIKit

// MARK: - Base
public protocol SettingsCellBaseModel {
    var title: String { get }
    var value: SettingsDataType { get set }
    var inputType: SettingsTableItemInputType { get }
    var accessoryType: UITableViewCell.AccessoryType { get }
    var options: [SettingsDataType] { get }
    var description: String? { get set }
}

// MARK: - Unit
public struct SettingsUnitCellModel: SettingsCellBaseModel {
    public var title: String
    public var value: SettingsDataType
    public var inputType: SettingsTableItemInputType
    public var accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator
    public var options: [SettingsDataType]
    public var description: String?

    init(value: ForecastUnit) {
        self.title = NSLocalizedString("Unit", comment: "")
        self.value = value
        self.inputType = .alert
        self.options = ForecastUnit.allCases
        self.description = NSLocalizedString("Units of measurement. standard, metric and imperial units are available. If you do not use the units parameter, standard units will be applied by default.", comment: "")
    }
}

// MARK: - Language
public struct SettingsLanguageCellModel: SettingsCellBaseModel {
    public var title: String
    public var value: SettingsDataType
    public var inputType: SettingsTableItemInputType
    public var accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator
    public var options: [SettingsDataType]
    public var description: String?

    init(value: ForecastLanguage) {
        self.title = NSLocalizedString("Language", comment: "")
        self.value = value
        self.inputType = .alert
        self.options = ForecastLanguage.allCases
        self.description = NSLocalizedString("You can use the lang parameter to get the output in your language.", comment: "")
    }
}

// MARK: - Number
public struct SettingsNumberCellModel: SettingsCellBaseModel {
    public var title: String
    public var value: SettingsDataType
    public var inputType: SettingsTableItemInputType = .picker
    public var accessoryType: UITableViewCell.AccessoryType = .none
    public var options: [SettingsDataType]
    public var description: String?

    init(title: String, value: Int, options: [Int], description: String?) {
        self.title = title
        self.value = value
        self.options = options
        self.description = description
    }

    /// Constructor for forecaast data count
    /// - Parameter value: Amount of data will be retrieved from API
    init(value: Int) {
        self.title = NSLocalizedString("Count", comment: "")
        self.value = value
        self.options = Array(1...40)
        self.description = NSLocalizedString("A number of timestamps, which will be returned in the API response.", comment: "")
    }
}
