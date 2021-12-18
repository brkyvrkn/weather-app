//
//  SettingsViewController.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 3.12.2020.
//

import UIKit
import Combine

// MARK: - Class Bone
class SettingsViewController: UIViewController {
    // MARK: UI
    @IBOutlet weak var settingsTableView: UITableView!

    // MARK: Properties
    private var disposables = Set<AnyCancellable>()
    var viewModel = SettingsViewModel()

    deinit {
        self.disposables.forEach {
            $0.cancel()
        }
        self.disposables.removeAll()
    }
}

// MARK: - Life Cycle
extension SettingsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        prepareBindings()
        self.viewModel.prepareItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = NSLocalizedString("settings", comment: "").capitalized
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - Utils
extension SettingsViewController {
    private func prepareTableView() {
        self.settingsTableView.delegate = self
        self.settingsTableView.dataSource = self
        self.settingsTableView.tableFooterView = UIView(frame: .zero)
        self.settingsTableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 0)
        self.settingsTableView.separatorColor = UIColor.systemGray5
        self.settingsTableView.estimatedRowHeight = 50
        self.settingsTableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
    }

    private func prepareBindings() {
        self.viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.settingsWillReload.send(true)
            }
            .store(in: &self.disposables)

        self.viewModel.settingsWillReload
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in
                if $0 {
                    self.settingsTableView.reloadData()
                }
            }
            .store(in: &self.disposables)
    }

    private func cellTapHandler(_ model: SettingsCellBaseModel) {
        if model.inputType == .alert {
            self.presentActionSheet(from: model)
        } else if model.inputType == .picker {
            self.presentPicker(from: model)
        }
    }
}

// MARK: - Presenter
extension SettingsViewController {
    private func presentPicker(from item: SettingsCellBaseModel) {
        guard item.inputType == .picker else { return }
    }

    private func presentActionSheet(from item: SettingsCellBaseModel) {
        guard item.inputType == .alert else { return }
        let alertController = UIAlertController(title: item.title, message: item.description, preferredStyle: .alert)
        for optionId in 0..<item.options.count {
            let data = item.options[optionId]
            let action = UIAlertAction(title: data.value, style: .default) { action in
                self.viewModel.actionSheetHandler(item: item, selectedId: optionId)
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - TableView
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell {
            let item = self.viewModel.items[indexPath.row]
            cell.configureCell(item)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = self.viewModel.items[indexPath.row]
        self.cellTapHandler(selectedItem)
    }
}
