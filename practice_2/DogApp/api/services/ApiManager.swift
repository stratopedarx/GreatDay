import Foundation

let numberOfImages = 12  // the value must be a multiple of 6
let defaultTimeInterval = 15
let defaultSleep: UInt32 = 1

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
        configuration.timeoutIntervalForRequest = TimeInterval(defaultTimeInterval)
        configuration.timeoutIntervalForResource = TimeInterval(defaultTimeInterval)
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
            if let images = self.parseJSON(type: RandomImage.self, from: data) {
                completion(images)
            }
        }
        task.resume()
        sleep(defaultSleep) // it helps to get result from webserver. Fix it later
    }
}

// MARK: Parse JSON and handle errors
extension ApiManager {
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
