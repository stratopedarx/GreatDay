import Foundation


let numberOfImages = 6


enum ApiType {
    case getRandom
    
    var baseUrl: String {
        "https://dog.ceo/api/breeds/"
    }
    var path: String {
        switch self {
        case .getRandom: return "image/random/6"
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
    
    func getRandom(completion: @escaping (RandomImage) -> Void) {
        let request = ApiType.getRandom.request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let images = try? JSONDecoder().decode(RandomImage.self, from: data) {
                completion(images)
            } else {
                // no results
            }
        }
        task.resume()
    }
}
