import Foundation


let numberOfImages = 6


enum ApiType {
    case getRandom
    
    var baseUrl: String {
        "https://dog.ceo/api/breeds/"
    }
    var path: String {
        switch self {
        case .getRandom: return "image/random/\(numberOfImages)"
        }
    }
    var request: URLRequest {
        print(path)
        let url = URL(string: path, relativeTo: URL(string: baseUrl)!)!
        var request = URLRequest(url: url)
        
        switch self {
        case .getRandom:
            request.httpMethod = "GET"
            return request
        }
    }
    
    
}

class ApiManager {
    static let shared = ApiManager()

    var configuration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(15)
        configuration.timeoutIntervalForResource = TimeInterval(15)
        return configuration
    }
    
    func hasError(_ error: Error?) -> Bool {
        if error != nil {
            print("Error!")
            return true
        }
        return false
    }
    
    func isValidStatusCode(_ response: URLResponse?) -> Bool {
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            print("Server error!")
            return false
        }
        return true
    }
    
    func getRandom(completion: @escaping (RandomImage) -> Void) {
        let request = ApiType.getRandom.request
        let task = URLSession(configuration: configuration).dataTask(with: request) { data, response, error in
            if self.hasError(error) || !self.isValidStatusCode(response) {
                return
            }
            if let data = data, let images = try? JSONDecoder().decode(RandomImage.self, from: data) {
                completion(images)
            }
        }
        task.resume()
        sleep(1) // it helps to get result from webserver
    }
}
