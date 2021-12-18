//
//  City.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 1.12.2020.
//

import Foundation

public struct Location: Codable {
    var latitude: Float?
    var longitude: Float?
}

public struct City: Codable {
    var id: Int
    var name: String
    var location: Location
    var country: String
    var timezone: Int16
    var sunrise: Date
    var sunset: Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case location = "coord"
        case country
        case timezone
        case sunrise
        case sunset
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.country = try container.decode(String.self, forKey: .country)
        self.timezone = try container.decode(Int16.self, forKey: .timezone)
        self.location = try container.decode(Location.self, forKey: .location)
        self.sunrise = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .sunrise))
        self.sunset = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .sunset))
    }
}
