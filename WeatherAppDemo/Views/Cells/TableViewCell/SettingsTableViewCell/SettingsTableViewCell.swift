//
//  SettingsTableViewCell.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 6.12.2020.
//

import UIKit

// MARK: - Class Bone
class SettingsTableViewCell: UITableViewCell {
    // MARK: Properties
    public static let identifier = "SettingsTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension SettingsTableViewCell {
    private func setUI() {
        self.textLabel?.font = .boldSystemFont(ofSize: 14)
        self.textLabel?.textColor = .label
        self.detailTextLabel?.textColor = .systemGray2
        self.detailTextLabel?.font = .systemFont(ofSize: 12)
    }
}

// MARK: - Utils
extension SettingsTableViewCell {
    func configureCell(_ model: SettingsCellBaseModel) {
        self.textLabel?.text = model.title
        self.detailTextLabel?.text = model.value.value
        self.accessoryType = model.accessoryType
    }
}
