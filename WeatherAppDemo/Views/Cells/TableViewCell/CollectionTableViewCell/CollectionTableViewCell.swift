//
//  CollectionTableViewCell.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 3.12.2020.
//

import UIKit
import Combine

// MARK: - Class Bone
class CollectionTableViewCell: UITableViewCell {
    // MARK: UI
    private var collectionView: UICollectionView!
    private var collectionLayout: UICollectionViewFlowLayout!

    // MARK: Properties
    public static let identifier = "CollectionTableViewCell"
    private var viewModel = CollectionTableViewCellViewModel()
    private var disposables = Set<AnyCancellable>()

    deinit {
        clearDisposeBag()
    }
}

// MARK: - Life Cycle
extension CollectionTableViewCell {
    override func layoutSubviews() {
        createLayout()
        createCollectionView()
    }
}

// MARK: - Utils
extension CollectionTableViewCell {
    private func createLayout() {
        if collectionLayout == nil {
            collectionLayout = UICollectionViewFlowLayout()
            collectionLayout.scrollDirection = .horizontal
            collectionLayout.itemSize = .init(width: frame.width / 3.75, height: frame.height)
            collectionLayout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 8)
        }
    }

    private func createCollectionView() {
        if collectionView == nil {
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
            collectionView.fit(contentView)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.contentInset = .zero
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.backgroundColor = .clear
            collectionView.register(UINib(nibName: ForecastItemCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: ForecastItemCollectionViewCell.identifier)
        }
    }

    func configureCell(items: [ForecastData]) {
        self.viewModel.setItemList(items)
        reloadItems()
    }

    private func reloadItems() {
        guard self.collectionView != nil else { return }
//        self.collectionView.performBatchUpdates {
//            self.collectionView.reloadSections(IndexSet(0..<self.collectionView.numberOfSections))
//        } completion: { _ in}
        self.collectionView.reloadData()
    }

    private func clearDisposeBag() {
        if !self.disposables.isEmpty {
            self.disposables.forEach {
                $0.cancel()
            }
            self.disposables.removeAll()
        }
    }
}

// MARK: - Collection View
extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastItemCollectionViewCell.identifier, for: indexPath) as? ForecastItemCollectionViewCell {
            let item = self.viewModel.items[indexPath.row]
            let model = ForecastItemCollectionViewCellModel(item)
            cell.configureCell(with: model)
            return cell
        }
        return UICollectionViewCell()
    }
}
