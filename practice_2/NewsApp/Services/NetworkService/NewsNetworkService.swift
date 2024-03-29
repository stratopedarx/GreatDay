import Foundation

let daysInWeek = 7  // news for the last 7 days

protocol NewsNetworkServiceProtocol {
    func fetchTopNews(country: String, completion: @escaping (Result<NewsAPI, Error>) -> Void)
    func fetchArticles(by keyword: String, completion: @escaping (Result<NewsAPI, Error>) -> Void)
    func fetchSourceNews(country: String, completion: @escaping (Result<NewsSourceAPI, Error>) -> Void)
}

enum NewsApiType {
    static let scheme = "https"
    private static let apiKey = "4808c54b823e41a69ac812420555cf96"

    case fetchTopNews
    case fetchArticles
    case fetchSourceNews

    var host: String {
        switch self {
        case .fetchTopNews, .fetchArticles, .fetchSourceNews:
            return "newsapi.org"
        }
    }
    var path: String {
        switch self {
        case .fetchTopNews:
            return "/v2/top-headlines"
        case .fetchArticles:
            return "/v2/everything"
        case .fetchSourceNews:
            return "/v2/top-headlines/sources"
        }
    }

    private func getDate() -> String {
        guard let date = Calendar.current.date(byAdding: .day, value: -daysInWeek, to: Date())
        else { return "2021-01-01" }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        return dateString
    }

    private func createUrl(params: [String: String]?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = NewsApiType.scheme
        urlComponents.host = host
        urlComponents.path = path

        switch self {
        case .fetchTopNews:
            if let country = params?["country"] {
                urlComponents.queryItems = [URLQueryItem(name: "country", value: country)]
            }
        case .fetchArticles:
            if let keyword = params?["keyword"] {
                urlComponents.queryItems = [
                    URLQueryItem(name: "q", value: keyword),
                    URLQueryItem(name: "sortBy", value: "popularity"),
                    URLQueryItem(name: "from", value: getDate())
                ]
            }
        case .fetchSourceNews:
            if let country = params?["country"] {
                urlComponents.queryItems = [
                    URLQueryItem(name: "country", value: country),
                    URLQueryItem(name: "from", value: getDate()),
                    URLQueryItem(name: "category", value: "sports")
                ]
            }
        }

        urlComponents.queryItems?.append(URLQueryItem(name: "apiKey", value: NewsApiType.apiKey))

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
        case .fetchTopNews, .fetchArticles, .fetchSourceNews:
            request.httpMethod = "GET"
            return request
        }
    }
}

class NewsNetworkService: ApiManager, NewsNetworkServiceProtocol {
    static let sharedNews = NewsNetworkService()

    func fetchTopNews(country: String, completion: @escaping (Result<NewsAPI, Error>) -> Void) {
        let params = ["country": country]
        let request = NewsApiType.fetchTopNews.getRequest(params: params)
        let task = URLSession(configuration: configuration).dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let topNews = self.parseJSON(type: NewsAPI.self, from: data) {
                completion(.success(topNews))
            }
        }
        print("requesting fetchTopNews")
        task.resume()
    }

    func fetchArticles(by keyword: String, completion: @escaping (Result<NewsAPI, Error>) -> Void) {
        let params = ["keyword": keyword]
        let request = NewsApiType.fetchArticles.getRequest(params: params)
        let task = URLSession(configuration: configuration).dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let articles = self.parseJSON(type: NewsAPI.self, from: data) {
                completion(.success(articles))
            }
        }
        print("requesting fetchArticles by keyword")
        task.resume()
    }

    func fetchSourceNews(country: String, completion: @escaping (Result<NewsSourceAPI, Error>) -> Void) {
        let params = ["country": country]
        let request = NewsApiType.fetchSourceNews.getRequest(params: params)
        let task = URLSession(configuration: configuration).dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let sources = self.parseJSON(type: NewsSourceAPI.self, from: data) {
                completion(.success(sources))
            }
        }
        print("requesting fetchSourceNews")
        task.resume()
    }
}
