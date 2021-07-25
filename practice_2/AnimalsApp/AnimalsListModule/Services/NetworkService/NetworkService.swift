import Foundation

protocol NetworkServiceProtocol {
    func getAllDogBreeds(completion: @escaping (Result<DogBreeds, Error>) -> Void)
    //func getAllImages(by breed: String, completion: @escaping (DogImages) -> Void)
}

enum AnimalsApiType {
    case getAllDogBreeds
    //case getAllImages(breed: String)

    var baseUrl: String {
        "https://dog.ceo/api/"
    }
    var path: String {
        switch self {
        case .getAllDogBreeds:
            return "breeds/list/all"
//        case .getAllImages(let breed):
//            return "breed/\(breed)/images"
        }
    }
    func getRequest(urlParams: [String]?) -> URLRequest {
        //let breed = urlParams?.joined(separator: "/")

        let url = URL(string: path, relativeTo: URL(string: baseUrl)!)!
        var request = URLRequest(url: url)

        switch self {
        case .getAllDogBreeds:
            request.httpMethod = "GET"
            return request
        }
    }
}

class NetworkService: ApiManager, NetworkServiceProtocol {
    static let sharedAnimals = NetworkService()

    func getAllDogBreeds(completion: @escaping (Result<DogBreeds, Error>) -> Void) {
        let request = AnimalsApiType.getAllDogBreeds.getRequest(urlParams: nil)
        let task = URLSession(configuration: configuration).dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data, let dogBreeds = try? JSONDecoder().decode(DogBreeds.self, from: data) {
                completion(.success(dogBreeds))
            }
        }
        task.resume()
    }
}
