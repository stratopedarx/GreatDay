import Foundation


enum ApiType {
    case getRandom
    
    var baseUrl: String {
        "https://dog.ceo/api/breeds/"
    }
    var path: String {
        switch self {
        case .getRandom: return "image/random"
        }
    }
    var request: URLRequest {
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
    
    func getRandom(completion: @escaping (_ message: String) -> Void) {
        let request = ApiType.getRandom.request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let randomImage = try? JSONDecoder().decode(RandomImage.self, from: data),
               randomImage.status == "success", let message = randomImage.message {
                completion(message)
            } else {
                completion("")
            }
        }
        task.resume()
    }
}
