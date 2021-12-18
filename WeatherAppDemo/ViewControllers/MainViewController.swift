//
//  MainViewController.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 30.11.2020.
//

import UIKit
import Combine

// MARK: - Class Bone
class MainViewController: UIViewController {
    // MARK: UI
    @IBOutlet weak var dailyTableView: UITableView!

    // MARK: Properties
    private var disposables = Set<AnyCancellable>()
    var viewModel = MainViewModel()

    deinit {
        self.disposables.forEach {
            $0.cancel()
        }
        self.disposables.removeAll()
    }
}

// MARK: - Life Cycle
extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        prepareBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let pageTitle = NSLocalizedString("home", comment: "")
        self.title = pageTitle
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.titleView = modifyBanner(based: pageTitle)
    }
}

// MARK: - Utils
extension MainViewController {
    private func prepareTableView() {
        self.dailyTableView.delegate = self
        self.dailyTableView.dataSource = self
        self.dailyTableView.tableFooterView = UIView(frame: .zero)
        self.dailyTableView.separatorStyle = .none
        self.dailyTableView.allowsSelection = false
        self.dailyTableView.estimatedRowHeight = 120
        self.dailyTableView.estimatedSectionHeaderHeight = 60
        self.dailyTableView.indicatorStyle = .black
        self.dailyTableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        let refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(
            string: NSLocalizedString("Forecasts are fetching", comment: ""),
            attributes: [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.systemGray,
                .kern: 1.2
            ]
        )
        refresher.addTarget(self, action: #selector(refresherHandler(_:)), for: .valueChanged)
        self.dailyTableView.refreshControl = refresher
    }

    private func prepareBindings() {
        self.viewModel.pageMode
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] mode in
                switch mode {
                case .live:
                    self.viewModel.fetchForecasts()
                case .fixed:
                    self.viewModel.feedFromFixedFile()
                }
            }
            .store(in: &self.disposables)

        self.viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                self.viewModel.tableWillReload.send(true)
            }
            .store(in: &self.disposables)

        self.viewModel.tableWillReload
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in
                if $0 {
                    self.dailyTableView.reloadData()
                }
            }
            .store(in: &self.disposables)

        self.viewModel.fetchInProgress
            .receive(on: DispatchQueue.main)
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [unowned self] inProgress in
                if let refresher = self.dailyTableView.refreshControl {
                    if inProgress && !refresher.isRefreshing {
                        refresher.beginRefreshing()
                    } else if !inProgress && refresher.isRefreshing {
                        refresher.endRefreshing()
                    }
                }
            }
            .store(in: &self.disposables)

        NotificationCenter.default
            .publisher(for: .settingsDidUpdate)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                self.viewModel.itemsWillRefresh.send(true)
            }
            .store(in: &self.disposables)
    }

    private func modifyHeaderView(text: String) -> UIView {
        let header = UIView(frame: .zero)
        header.backgroundColor = .systemBackground
        let title = UILabel(frame: .zero)
        title.fitVertically(header, left: 16, right: nil)     // Default inset value for labels
        title.text = text
        title.font = .boldSystemFont(ofSize: 24)
        title.textColor = .label
        title.textAlignment = .left
        return header
    }

    private func modifyBanner(based title: String) -> UIView {
        let banner = UIView(frame: .init(origin: .zero, size: CGSize(width: 100, height: 30)))
        let segmentedControl = UISegmentedControl(items: HomePageMode.allCases.map { $0.rawValue })
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        segmentedControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        segmentedControl.fit(banner)
        return banner
    }
}

// MARK: - Actions
extension MainViewController {
    @objc private func refresherHandler(_ sender: UIRefreshControl) {
        self.viewModel.itemsWillRefresh.send(true)
    }

    @objc private func segmentValueChanged(_ sender: UISegmentedControl) {
        // just toggle for now due to 2 case exits for UI type
        self.viewModel.pageMode.value.toggle()
    }
}

// MARK: - TableView
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell {
            let item = self.viewModel.items[indexPath.section]
            cell.configureCell(items: item.items)
            return cell
        }
        return UITableViewCell()
    }

    // Sizing
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let item = self.viewModel.items.first(where: { $0.sectionId == section }) {
            return modifyHeaderView(text: item.sectionTitle)
        }
        return nil
    }
}
