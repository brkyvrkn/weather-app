//
//  SettingsViewModel.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 3.12.2020.
//

import Foundation
import Combine

// MARK: - Class Bone
public class SettingsViewModel {
    // MARK: Attributes
    // Shared
    @Published var items: [SettingsCellBaseModel]
    var settingsWillReload = PassthroughSubject<Bool, Never>()
    // Private
    private var disposables: Set<AnyCancellable>
    
    // MARK: Cons & Decons
    init() {
        self.disposables = Set<AnyCancellable>()
        self.items = []
    }

    deinit {
        self.disposables.forEach {
            $0.cancel()
        }
        self.disposables.removeAll()
    }
}

// MARK: - Utils
extension SettingsViewModel {
    func prepareItems() {
        self.items = [
            SettingsUnitCellModel(value: PersistentSettings.getForecastUnits()),
            SettingsLanguageCellModel(value: PersistentSettings.getForecastLanguage()),
            SettingsNumberCellModel(value: PersistentSettings.getForecastCount())
        ]
    }

    func actionSheetHandler(item: SettingsCellBaseModel, selectedId: Int) {
        if let unitModel = item as? SettingsUnitCellModel {
            self.unitUpdateHandler(model: unitModel, selectedId: selectedId)
        } else if let languageModel = item as? SettingsLanguageCellModel, selectedId < languageModel.options.count {
            self.languageUpdateHandler(model: languageModel, selectedId: selectedId)
        }
        prepareItems()
    }

    private func unitUpdateHandler(model: SettingsUnitCellModel, selectedId: Int) {
        guard selectedId < model.options.count else { return }
        if let updatedUnit = model.options[selectedId] as? ForecastUnit {
            PersistentSettings.setForecastUnits(updatedUnit)
            NotificationCenter.default.post(name: .settingsDidUpdate, object: nil)
        }
    }

    private func languageUpdateHandler(model: SettingsLanguageCellModel, selectedId: Int) {
        guard selectedId < model.options.count else { return }
        if let updatedLanguage = model.options[selectedId] as? ForecastLanguage {
            PersistentSettings.setForecastLanguage(updatedLanguage)
            NotificationCenter.default.post(name: .settingsDidUpdate, object: nil)
        }
    }
}
