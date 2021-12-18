//
//  DateFormatter+Custom.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 5.12.2020.
//

import Foundation

extension DateFormatter {
    /// MMM d, yyyy
    public static let classic: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()

    /// hh:mm
    public static let dateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    /// Epoch
    public static let epoch: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX"
        return formatter
    }()
}
