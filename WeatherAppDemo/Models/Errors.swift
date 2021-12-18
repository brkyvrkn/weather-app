//
//  Errors.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 1.12.2020.
//

import Foundation

public enum FileAccessErrors: Error {
    case notContain
    case writeFail
}

public enum WeatherResponseError: LocalizedError {
    case unknown
    case reference
    case requestNotPrepare
    case badResponse
    case decode
    case custom(message: String)

    init(error: Error) {
        if error is DecodingError {
            self = .decode
        } else {
            self = .custom(message: error.localizedDescription)
        }
    }
}
