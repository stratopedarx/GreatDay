import Foundation

protocol NewsNetworkServiceProtocol {
    func fetchTopNews(country: String, completion: @escaping (Result<TopNewsAPI, Error>) -> Void)
}

enum NewsApiType {
    static let scheme = "https"
    private static let apiKey = "4808c54b823e41a69ac812420555cf96"

    case fetchTopNews
//    case fetchForecast

    var host: String {
        switch self {
        case .fetchTopNews:
            return "newsapi.org"
        }
    }
    var path: String {
        switch self {
        case .fetchTopNews:
            return "/v2/top-headlines"
//        case .fetchForecast:
//            return "/data/2.5/onecall"
        }
    }

    private func createUrl(params: [String: String]?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = NewsApiType.scheme
        urlComponents.host = host
        urlComponents.path = path

        if let country = params?["country"] {
            urlComponents.queryItems = [
                URLQueryItem(name: "country", value: country),
                URLQueryItem(name: "apiKey", value: NewsApiType.apiKey)
            ]
        }
//
//        if self == .fetchForecast {
//            if let exclude = params?["exclude"] {
//                urlComponents.queryItems?.append(URLQueryItem(name: "exclude", value: exclude))
//            } else {
//                urlComponents.queryItems?.append(
//                    URLQueryItem(name: "exclude", value: "current,minutely,hourly,alerts"))
//            }
//        }

        if let url = urlComponents.url {
            return URL(string: url.absoluteString)
        }
        return nil
    }

    private func makeURLRequest(params: [String: String]?) -> URLRequest {
        if let url = createUrl(params: params) {
                return URLRequest(url: url)
            } else {
                let urlString = "\(NewsApiType.scheme)://\(host)\(path)"
                return URLRequest(url: URL(string: urlString)!)
        }
    }

    func getRequest(params: [String: String]?) -> URLRequest {
        var request = makeURLRequest(params: params)
        switch self {
        case .fetchTopNews:
            request.httpMethod = "GET"
            return request
        }
    }
}

class NewsNetworkService: ApiManager, NewsNetworkServiceProtocol {
    static let sharedNews = NewsNetworkService()

    func fetchTopNews(country: String, completion: @escaping (Result<TopNewsAPI, Error>) -> Void) {
        let params = ["country": country]
        let request = NewsApiType.fetchTopNews.getRequest(params: params)
        let task = URLSession(configuration: configuration).dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data, let topNews = try? JSONDecoder().decode(TopNewsAPI.self, from: data) {
                completion(.success(topNews))
            }
        }
        print("requesting fetchTopNews")
        task.resume()
    }
}
