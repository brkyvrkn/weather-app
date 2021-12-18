//
//  MainViewModel.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 3.12.2020.
//

import Foundation
import Combine

public enum HomePageMode: String, CaseIterable {
    case live = "Live"
    case fixed = "Fixed"

    var segmentIndex: Int {
        return self == .live ? 0 : 1
    }

    mutating func toggle() {
        self = self == .live ? .fixed : .live
    }
}

public struct DailyTableItemModel {
    var sectionId: Int
    var sectionTitle: String
    var items: [ForecastData]
}

// MARK: - Class Bone
public class MainViewModel {
    // MARK: Attributes
    // Shared
    @Published var items: [DailyTableItemModel]
    @Published var city: City?
    var tableWillReload = PassthroughSubject<Bool, Never>()
    var itemsWillRefresh = PassthroughSubject<Bool, Never>()
    var fetchInProgress = PassthroughSubject<Bool, Never>()
    var pageMode = CurrentValueSubject<HomePageMode, Never>(.live)
    // Private
    private var disposables: Set<AnyCancellable>
    private var manager: DateOperator

    // MARK: Cons & Decons
    init() {
        self.disposables = Set<AnyCancellable>()
        self.items = []
        self.manager = DateOperator()
        prepareBindings()
    }

    deinit {
        self.disposables.forEach {
            $0.cancel()
        }
        self.disposables.removeAll()
    }
}

// MARK: - Utils
extension MainViewModel {
    func fetchForecasts() {
        self.fetchInProgress.send(true)
        APIManager.shared.getForecastsByCity(name: "izmir")
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] result in
                switch result {
                case .failure(let err):
                    // Do action in error
                    print("\(String(describing: self))=====\(#function)> ", err.localizedDescription)
                case .finished:
                    self.items = self.prepareDataSource()
                    self.fetchInProgress.send(false)
                }
            } receiveValue: { [unowned self] response in
                self.manager.setData(response.list)
                self.city = response.city
            }
            .store(in: &self.disposables)
    }

    func feedFromFixedFile() {
        if let fixedResponse = FileAccessManager.shared.readJSON(name: "FixedWeather", type: WeatherResponseModel.self) {
            self.manager.setData(fixedResponse.list)
            self.city = fixedResponse.city
            self.items = self.prepareDataSource()
        }
    }

    private func prepareBindings() {
        self.itemsWillRefresh
            .subscribe(on: DispatchQueue.main)
            .handleEvents()
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] willRefresh in
                if willRefresh {
                    switch self.pageMode.value {
                    case .live:
                        self.fetchForecasts()
                    case .fixed:
                        self.feedFromFixedFile()
                    }
                }
            }
            .store(in: &self.disposables)
    }

    private func prepareDataSource() -> [DailyTableItemModel] {
        let response = self.manager.getData()
        guard !response.isEmpty else { return [] }
        var itemList = self.manager.prepareDailyForecastData()
        if pageMode.value == .live {
            for counter in 0..<itemList.count {
                itemList[counter].sectionTitle = DateOperator.getHumanReadableDate(itemList[counter].sectionTitle)
            }
        }
        return itemList
    }
}
