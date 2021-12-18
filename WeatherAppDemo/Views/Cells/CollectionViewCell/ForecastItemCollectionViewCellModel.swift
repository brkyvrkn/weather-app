//
//  ForecastItemCollectionViewCellModel.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 4.12.2020.
//

import Foundation
import Combine

// MARK: - Class Bone
public class ForecastItemCollectionViewCellModel {
    // MARK: Properties
    var temperature: Float
    var dateTime: Date
    var weatherIcon: String

    init(temp: Float, dateTime: Date, icon: String) {
        self.temperature = temp
        self.dateTime = dateTime
        self.weatherIcon = icon
    }

    init(_ model: ForecastData?) {
        self.temperature = model?.main.temp ?? 0
        self.dateTime = Date(timeIntervalSince1970: TimeInterval(model?.dt ?? 0))
        self.weatherIcon = model?.weather.first?.icon ?? ""
    }
}
