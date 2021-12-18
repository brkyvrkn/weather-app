//
//  ForecastData.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 2.12.2020.
//

import Foundation

public struct ForecastData: Codable {
    var dt: Int
    var main: WeatherInfoData
    var weather: [WeatherData]
    var wind: WeatherWind
}
