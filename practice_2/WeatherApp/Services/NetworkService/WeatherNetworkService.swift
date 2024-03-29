import Foundation
import CoreLocation

protocol WeatherNetworkServiceProtocol {
    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees, units: String,
                      completion: @escaping (Result<WeatherApiModel, Error>) -> Void)
    func fetchForecast(latitude: CLLocationDegrees, longtitude: CLLocationDegrees, units: String,
                       completion: @escaping (Result<ForecastApiModel, Error>) -> Void)
}

enum WeatherApiType {
    static let scheme = "https"
    private static let apiKey = "c64b9be891024003e21d85eb99c06ba0"

    case fetchWeather
    case fetchForecast

    var host: String {
        switch self {
        case .fetchWeather, .fetchForecast:
            return "api.openweathermap.org"
        }
    }
    var path: String {
        switch self {
        case .fetchWeather:
            return "/data/2.5/weather"
        case .fetchForecast:
            return "/data/2.5/onecall"
        }
    }

    private func createUrl(params: [String: String]?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = WeatherApiType.scheme
        urlComponents.host = host
        urlComponents.path = path

        if let lat = params?["latitude"], let lon = params?["longtitude"], let units = params?["units"] {
            urlComponents.queryItems = [
                URLQueryItem(name: "lat", value: lat),
                URLQueryItem(name: "lon", value: lon),
                URLQueryItem(name: "units", value: units),
                URLQueryItem(name: "appid", value: WeatherApiType.apiKey)
            ]
        }

        if self == .fetchForecast {
            if let exclude = params?["exclude"] {
                urlComponents.queryItems?.append(URLQueryItem(name: "exclude", value: exclude))
            } else {
                urlComponents.queryItems?.append(
                    URLQueryItem(name: "exclude", value: "current,minutely,hourly,alerts"))
            }
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
        case .fetchWeather, .fetchForecast:
            request.httpMethod = "GET"
            return request
        }
    }
}

class WeatherNetworkService: ApiManager, WeatherNetworkServiceProtocol {
    static let sharedWeather = WeatherNetworkService()

    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees, units: String,
                      completion: @escaping (Result<WeatherApiModel, Error>) -> Void) {
        let params = ["latitude": String(latitude), "longtitude": String(longtitude), "units": units]
        let request = WeatherApiType.fetchWeather.getRequest(params: params)
        let task = URLSession(configuration: configuration).dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let weather = self.parseJSON(type: WeatherApiModel.self, from: data) {
                completion(.success(weather))
            }
        }
        print("requesting fetchWeather")
        task.resume()
    }

    func fetchForecast(latitude: CLLocationDegrees, longtitude: CLLocationDegrees, units: String,
                       completion: @escaping (Result<ForecastApiModel, Error>) -> Void) {
        let params = ["latitude": String(latitude), "longtitude": String(longtitude), "units": units]
        let request = WeatherApiType.fetchForecast.getRequest(params: params)
        let task = URLSession(configuration: configuration).dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let forecast = self.parseJSON(type: ForecastApiModel.self, from: data) {
                completion(.success(forecast))
            }
        }
        print("requesting fetchForecast")
        task.resume()
    }
}

// MARK: Parse JSON and handle errors
extension WeatherNetworkService {
    func parseJSON<T>(type: T.Type, from data: Data?) -> T? where T: Decodable {
        if let data = data {
            do {
                let result = try JSONDecoder().decode(type, from: data)
                return result
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
        return nil
    }
}
