//
//  DateOperator.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 5.12.2020.
//

import Foundation

public enum ChunkType {
    case daily
    case hourly
}

// MARK: - Class Bone
public class DateOperator: NSObject {
    // MARK: Attributes
    private var forecasts: [ForecastData]

    // MARK: Cons & Decons
    public init(_ data: [ForecastData]) {
        self.forecasts = data
    }

    public override init() {
        self.forecasts = []
    }
}

// MARK: - Utils
extension DateOperator {
    func prepareDailyForecastData() -> [DailyTableItemModel] {
        return self.forecasts.reduce(into: [DailyTableItemModel]()) { (res, current) in
            let currDateObj = Date(timeIntervalSince1970: TimeInterval(current.dt))
            let key = DateFormatter.classic.string(from: currDateObj)   // specific date
            if let existedIdx = res.firstIndex(where: { $0.sectionTitle == key }) {
                res[existedIdx].items.append(current)
            } else {
                let pivotID = res.max { $0.sectionId < $1.sectionId }?.sectionId ?? -1
                let item = DailyTableItemModel(
                    sectionId: pivotID + 1,
                    sectionTitle: key,
                    items: [current]
                )
                res.append(item)
            }
        }.sorted {
            $0.sectionId < $1.sectionId
        }
    }

    private static func getHumanReadableDate(_ time: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: time)
        let dayComponent = Calendar.current.component(.weekday, from: date)
        let todayComponent = Calendar.current.component(.weekday, from: Date())
        let daySymbols = DateFormatter().weekdaySymbols ?? []
        if dayComponent == todayComponent {
            return NSLocalizedString("today", comment: "").capitalized
        } else if daySymbols.count >= dayComponent && dayComponent > 0 {
            return daySymbols[dayComponent - 1].capitalized
        }
        return "-"
    }

    /// Convert formatted text by classic to human-readable text
    /// - Parameter classicText: Text format should be **"MM/dd/YYYY"** declared in DateFormatter+Custom.swift
    /// - Returns: Pretty date text
    static func getHumanReadableDate(_ classicText: String) -> String {
        if let date = DateFormatter.classic.date(from: classicText) {
            return getHumanReadableDate(date.timeIntervalSince1970)
        }
        return "-"
    }
}

// MARK: - Set & Get
extension DateOperator {
    func setData(_ data: [ForecastData]) {
        self.forecasts = data
    }

    func getData() -> [ForecastData] {
        return self.forecasts
    }
}
