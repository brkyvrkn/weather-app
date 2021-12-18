//
//  Response.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 1.12.2020.
//

import Foundation

public struct WeatherResponseModel: Codable {
    var cod: String
    var message: Int
    var cnt: Int
    var list: [ForecastData]
    var city: City
}
