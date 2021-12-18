//
//  APIManager.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 1.12.2020.
//

import Foundation
import Combine

// MARK: - Class Bone
public class APIManager: NSObject {
    // Public
    public static let shared = APIManager()
    public var timeout: TimeInterval

    // Private
    private var weatherToken: String?
    private var baseURL: URL?
    private var disposables = Set<AnyCancellable>()

    private override init() {
        // Singleton object
        let config = FileAccessManager.shared.readPListInBundle(name: "Secrets")
        self.weatherToken = config["WeatherAPIKey"] as? String
        self.baseURL = URL(string: config["BaseUrl"] as? String ?? "")
        self.timeout = 30.0
    }

    deinit {
        disposables.forEach {
            $0.cancel()
        }
        disposables.removeAll()
    }
}

// MARK: - Utils
extension APIManager {
    public func setWeatherToken(_ token: String) {
        self.weatherToken = token
    }

    private func prepareURLRequest(path: String?, params: [String: Any], extraHeader: [String: String]? = nil, method: APIHTTPMethod = .get) -> URLRequest? {
        guard var url = self.baseURL else { return nil }
        url.appendPathComponent("data/2.5")
        if let endpoint = path {
            url.appendPathComponent(endpoint)
        }
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: self.timeout
        )
        request.httpMethod = method.headerValue
        var query = URLComponents(url: url, resolvingAgainstBaseURL: false)
        // Add API Key
        var items: [URLQueryItem] = [URLQueryItem(name: "appid", value: self.weatherToken)]
        params.forEach {
            let qKey = $0.key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let qValue = String(describing: $0.value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let safeQueryKey = qKey {
                let item = URLQueryItem(name: safeQueryKey, value: qValue)
                items.append(item)
            }
        }
        query?.queryItems = items
        request.url = query?.url
        if let addableHeader = extraHeader {
            addableHeader.forEach {
                request.setValue($0.value, forHTTPHeaderField: $0.key)
            }
        }
        return request
    }

    /// 5-day forecast is available at any location or city. It includes weather forecast data with 3-hour step. Forecast is available in JSON or XML format.
    /// - Parameter parameters: Query parameter dictionary
    ///     - mode: Response format. JSON by default, XML can be used
    ///     - cnt: A number of timestamps, which will be returned in the API response.
    ///     - unit: Units of measurement. **standard**, **metric** and **imperial** units are available. **standard** by default.
    ///     - lang: You can use the lang parameter to get the output in your language.
    /// - Returns: Future model contains response and error model
    /// - Note: Available upon by city name, ID, geographic coordinates and ZIP code
    ///     - q(name): City name, state code and country code divided by comma, use ISO 3166 country codes.
    ///     - id(id): City ID, one of the id in the list of 'city.list.json.gz'
    ///     - lat(geo): Latitude
    ///     - lon(geo): Longitude
    ///     - zip(zip): by zip code
    private func getForecast(parameters: [String: Any]) -> Future<WeatherResponseModel, WeatherResponseError> {
        return Future<WeatherResponseModel, WeatherResponseError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.reference))
                return
            }
            if let request = self.prepareURLRequest(path: "forecast", params: parameters, extraHeader: nil, method: .get) {
                URLSession.shared
                    .dataTaskPublisher(for: request)
                    .tryMap() { element -> Data in
                        guard let httpResponse = element.response as? HTTPURLResponse,
                              httpResponse.statusCode == 200 else {
                            promise(.failure(.badResponse))
                            throw URLError(.badServerResponse)
                        }
                        return element.data
                    }
                    .decode(type: WeatherResponseModel.self, decoder: JSONDecoder())
                    .receive(on: DispatchQueue.main)
                    .sink { receive in
                        switch receive {
                        case .failure(let err):
                            promise(.failure(.init(error: err)))
                        default:
                            break
                        }
                    } receiveValue: { result in
                        promise(.success(result))
                    }
                    .store(in: &self.disposables)
            } else {
                promise(.failure(.requestNotPrepare))
            }
        }
    }

    private func appendOptionalParams(params: inout [String: Any]) {
        let optionalParams = OptionalForecastParams.allCases
        let optionalParamKeys = optionalParams.map { $0.rawValue }
        let preDefinedParamCondition = params.keys.allSatisfy { return optionalParamKeys.contains($0) }
        guard !preDefinedParamCondition else { return }
        optionalParams.forEach { param in
            switch param {
            case .units:
                params[param.rawValue] = PersistentSettings.getForecastUnits().rawValue
            case .count:
                params[param.rawValue] = PersistentSettings.getForecastCount()
            case .responseMode:
                params[param.rawValue] = PersistentSettings.getForecastResponseMode().rawValue
            case .language:
                params[param.rawValue] = PersistentSettings.getForecastLanguage()
            }
        }
    }
}

// MARK: - Weather APIs
extension APIManager {
    func getForecastsByCity(name: String, stateCode: String? = nil, countryCode: String? = nil) -> AnyPublisher<WeatherResponseModel, WeatherResponseError> {
        var params: [String: Any] = [:]
        var cityValue = name
        if let state = stateCode {
            cityValue.append(",\(state)")
        }
        if let country = countryCode {
            cityValue.append(",\(country)")
        }
        params["q"] = cityValue
        self.appendOptionalParams(params: &params)
        return getForecast(parameters: params).eraseToAnyPublisher()
    }

    func getWeatherIconData(name: String) -> Future<Data?, Never> {
        return Future<Data?, Never> { [weak self] promise in
            guard let self = self, var url = self.baseURL else {
                promise(.success(nil))
                return
            }
            url.appendPathComponent("/img/w/\(name).png")
            URLSession.shared
                .dataTaskPublisher(for: url)
                .compactMap { $0.data }
                .catch { _ in return Just(nil) }
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .sink { data in
                    promise(.success(data))
                }
                .store(in: &self.disposables)
        }
    }
}
