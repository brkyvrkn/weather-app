//
//  Network.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 1.12.2020.
//

import Foundation

public enum APIHTTPMethod {
    case get
    case post
    case put
    case delete

    var headerValue: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        }
    }
}

public enum OptionalForecastParams: String, CaseIterable {
    case responseMode = "mode"
    case count = "cnt"
    case units
    case language = "lang"
}
