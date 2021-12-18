//
//  WeatherData.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 2.12.2020.
//

import Foundation

public struct WeatherInfoData: Codable {
    var temp: Float
    var feels: Float
    var tempMin: Float
    var tempMax: Float
    var pressure: Float
    var seaLevel: Float
    var groundLevel: Float
    var humidity: Float
    var tempKf: Float

    enum CodingKeys: String, CodingKey {
        case temp
        case feels = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = try container.decode(Float.self, forKey: .temp)
        self.feels = try container.decode(Float.self, forKey: .feels)
        self.tempMin = try container.decode(Float.self, forKey: .tempMin)
        self.tempMax = try container.decode(Float.self, forKey: .tempMax)
        self.pressure = try container.decode(Float.self, forKey: .pressure)
        self.seaLevel = try container.decode(Float.self, forKey: .seaLevel)
        self.groundLevel = try container.decode(Float.self, forKey: .groundLevel)
        self.humidity = try container.decode(Float.self, forKey: .humidity)
        self.tempKf = try container.decode(Float.self, forKey: .tempKf)
    }
}

public struct WeatherData: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

public struct WeatherWind: Codable {
    var speed: Float
    var deg: Float
}
