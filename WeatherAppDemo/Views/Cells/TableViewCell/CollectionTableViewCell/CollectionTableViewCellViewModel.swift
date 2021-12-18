//
//  CollectionTableViewCellViewModel.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 4.12.2020.
//

import Foundation
import Combine

// MARK: - Class Bone
public class CollectionTableViewCellViewModel {
    // MARK: Attributes
    // Observables
    @Published var items: [ForecastData]
    var collectionWillReload = PassthroughSubject<Bool, Never>()
    // Private
    private var disposables: Set<AnyCancellable>

    // MARK: Cons & Decons
    init() {
        self.items = []
        self.disposables = Set<AnyCancellable>()
    }

    init(_ list: [ForecastData]) {
        self.items = list
        self.disposables = Set<AnyCancellable>()
    }

    deinit {
        self.disposables.forEach {
            $0.cancel()
        }
        self.disposables.removeAll()
    }
}

// MARK: - Utils
extension CollectionTableViewCellViewModel {
    func setItemList(_ list: [ForecastData]) {
        self.items = list
    }
}
