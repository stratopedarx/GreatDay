import Foundation

protocol NetworkServiceProtocol {
    func getAllDogBreeds(completion: @escaping (Result<DogBreeds, Error>) -> Void)
    func getRandomImage(by breed: String, completion: @escaping (Result<DogRamdomImage, Error>) -> Void)
    // func getAllImages(by breed: String, completion: @escaping (DogImages) -> Void)
}

enum AnimalsApiType {
    case getAllDogBreeds
    case getRandomImage
    // case getAllImages(breed: String)

    var baseUrl: String {
        "https://dog.ceo/api/"
    }
    var path: String {
        switch self {
        case .getAllDogBreeds:
            return "breeds/list/all"
        case .getRandomImage:
            return "breed/{BREED}/images/random"
//        case .getAllImages(let breed):
//            return "breed/\(breed)/images"
        }
    }
    func getRequest(urlParams: [String: String]?) -> URLRequest {
        var path = path
        if let breed = urlParams?["breed"] {
            path = path.replacingOccurrences(of: "{BREED}", with: breed)
        }

        let url = URL(string: path, relativeTo: URL(string: baseUrl)!)!
        var request = URLRequest(url: url)

        switch self {
        case .getAllDogBreeds, .getRandomImage:
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

    func getRandomImage(by breed: String, completion: @escaping (Result<DogRamdomImage, Error>) -> Void) {
        let request = AnimalsApiType.getRandomImage.getRequest(urlParams: ["breed": breed])
        let task = URLSession(configuration: configuration).dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data, let dogRandomImage = try? JSONDecoder().decode(DogRamdomImage.self, from: data) {
                completion(.success(dogRandomImage))
            }
        }
        task.resume()
    }
}
