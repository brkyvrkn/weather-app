//
//  ForecastItemCollectionViewCell.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 3.12.2020.
//

import UIKit
import Combine

// MARK: - Class Bone
class ForecastItemCollectionViewCell: UICollectionViewCell {
    // MARK: UI
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: Properties
    public static let identifier = "ForecastItemCollectionViewCell"
    public static let nibName = "ForecastItemCollectionViewCell"
    private var disposables = Set<AnyCancellable>()

    deinit {
        self.disposables.forEach {
            $0.cancel()
        }
        self.disposables.removeAll()
    }
}

// MARK: - Life Cycle
extension ForecastItemCollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.iconImageView.image = nil
        self.temperatureLabel.text = ""
        self.timeLabel.text = ""
    }
}

// MARK: - UI
extension ForecastItemCollectionViewCell {
    private func setUI() {
        self.innerView.backgroundColor = .clear
        self.iconImageView.contentMode = .scaleAspectFill
        self.temperatureLabel.textColor = .systemGray
        self.temperatureLabel.font = .boldSystemFont(ofSize: 12)
        self.timeLabel.textColor = .systemGray2
        self.timeLabel.font = .systemFont(ofSize: 10)
    }
}

// MARK: - Utils
extension ForecastItemCollectionViewCell {
    func configureCell(with model: ForecastItemCollectionViewCellModel) {
        setTemparature(from: model)
        setTime(from: model)
        setIcon(from: model)
    }

    private func setTemparature(from: ForecastItemCollectionViewCellModel) {
        guard self.temperatureLabel != nil else { return }
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        formatter.numberFormatter = numberFormatter
        let relativeValue = Measurement(
            value: Double(from.temperature),
            unit: PersistentSettings.getForecastUnits().toTempUnit
        )
        self.temperatureLabel.text = formatter.string(from: relativeValue)
    }

    private func setTime(from: ForecastItemCollectionViewCellModel) {
        guard self.timeLabel != nil else { return }
        let relativeValue = DateFormatter.dateTime.string(from: from.dateTime)
        self.timeLabel.text = relativeValue
    }

    private func setIcon(from: ForecastItemCollectionViewCellModel) {
        guard self.iconImageView != nil, self.iconImageView.image == nil else { return }
        APIManager.shared.getWeatherIconData(name: from.weatherIcon)
            .receive(on: DispatchQueue.main)
            .sink { imgData in
                //TODO: cache by NSCache
                if let data = imgData, let imgContent = UIImage(data: data) {
                    self.iconImageView.image = imgContent
                }
            }
            .store(in: &self.disposables)
    }
}
