import Foundation

enum SWApiType {
    case search

    var baseUrl: String {
        "https://swapi.dev/api/people/"
    }
    func getRequestWithParams(_ params: [String: String]) -> URLRequest {
        var components = URLComponents(string: baseUrl)!
        components.queryItems = params.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        var request = URLRequest(url: components.url!)

        switch self {
        case .search:
            request.httpMethod = "GET"
            return request
        }
    }
}

class SWApiManager: ApiManager {
    static let sharedSW = SWApiManager()

    func searchHero(by name: String, completion: @escaping (SWHero) -> Void) {
        let request = SWApiType.search.getRequestWithParams(["search": name])
        let task = URLSession(configuration: configuration).dataTask(with: request) { data, response, error in
            if self.hasError(error) || !self.isValidStatusCode(response) {
                return
            }
            if let data = data, let hero = try? JSONDecoder().decode(SWHero.self, from: data) {
                completion(hero)
            }
        }
        task.resume()
    }
}
