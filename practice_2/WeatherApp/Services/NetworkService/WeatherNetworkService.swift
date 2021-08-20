import Foundation
import CoreLocation

protocol WeatherNetworkServiceProtocol {
    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees, units: String,
                      completion: @escaping (Result<Weather, Error>) -> Void)
}

enum WeatherApiType {
    static let scheme = "https"
    case fetchWeather

    var host: String {
        switch self {
        case .fetchWeather:
            return "api.openweathermap.org"
        }
    }
    var path: String {
        switch self {
        case .fetchWeather:
            return "/data/2.5/weather"
        }
    }

    private func createUrl(params: [String: String]?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = WeatherApiType.scheme
        urlComponents.host = host
        urlComponents.path = path

        if let lat = params?["latitude"], let lon = params?["longtitude"], let units = params?["units"] {
            urlComponents.queryItems = [
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)"),
                URLQueryItem(name: "units", value: "\(units)")
            ]
        }
        if let url = urlComponents.url {
            return URL(string: url.absoluteString)
        }
        return nil
    }

    private func makeURLRequest(params: [String: String]?) -> URLRequest {
        if let url = createUrl(params: params) {
                return URLRequest(url: url)
            } else {
                let urlString = "\(WeatherApiType.scheme)://\(host)\(path)"
                return URLRequest(url: URL(string: urlString)!)
        }
    }

    func getRequest(params: [String: String]?) -> URLRequest {
        var request = makeURLRequest(params: params)
        switch self {
        case .fetchWeather:
            request.httpMethod = "GET"
            return request
        }
    }
}

class WeatherNetworkService: ApiManager, WeatherNetworkServiceProtocol {
    static let sharedWeather = WeatherNetworkService()
    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees, units: String,
                      completion: @escaping (Result<Weather, Error>) -> Void) {
        return
    }
}
