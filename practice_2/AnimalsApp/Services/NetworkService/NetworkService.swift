import Foundation

protocol NetworkServiceProtocol {
    // Dog Api https://dog.ceo/dog-api/
    func getAllDogBreeds(completion: @escaping (Result<DogBreeds, Error>) -> Void)
    func getRandomDogImage(by breed: String, completion: @escaping (Result<DogRamdomImage, Error>) -> Void)
    func getAllDogImages(by breed: String, completion: @escaping (Result<DogImages, Error>) -> Void)

    // Cat Api https://dog.ceo/dog-api/
    func getAllCatBreeds(completion: @escaping (Result<CatBreeds, Error>) -> Void)
    func getCatImages(by breedId: String, in quantity: Int, completion: @escaping (Result<CatImages, Error>) -> Void)
}

enum AnimalsApiType {
    static let scheme = "https"
    // Dog Api
    case getAllDogBreeds
    case getRandomDogImage
    case getAllDogImages

    // Cat Api
    case getAllCatBreeds
    case getCatImages

    var host: String {
        switch self {
        case .getAllDogBreeds, .getRandomDogImage, .getAllDogImages:
            return "dog.ceo"
        case .getAllCatBreeds, .getCatImages:
            return "api.thecatapi.com"
        }
    }
    var path: String {
        switch self {
        case .getAllDogBreeds:
            return "/api/breeds/list/all"
        case .getRandomDogImage:
            return "/api/breed/{BREED}/images/random"
        case .getAllDogImages:
            return "/api/breed/{BREED}/images"
        case .getAllCatBreeds:
            return "/v1/breeds"
        case .getCatImages:
            return "/v1/images/search"
        }
    }

    private func createUrl(urlParams: [String: String]?) -> URL {
        var path = path
        if let breed = urlParams?["breed"] {
            path = path.replacingOccurrences(of: "{BREED}", with: breed)
        }

        var urlComponents = URLComponents()
        urlComponents.scheme = AnimalsApiType.scheme
        urlComponents.host = host
        urlComponents.path = path

        if let breedId = urlParams?["breedId"], let limit = urlParams?["limit"] {
            urlComponents.queryItems = [
                URLQueryItem(name: "size", value: "small"),
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "breed_id", value: "\(breedId)")
            ]
        }

        print("url: \(urlComponents.url!.absoluteString)")
        return URL(string: urlComponents.url!.absoluteString)!
    }

    func getRequest(urlParams: [String: String]?) -> URLRequest {
        let url = createUrl(urlParams: urlParams)
        var request = URLRequest(url: url)

        switch self {
        case .getAllDogBreeds, .getRandomDogImage, .getAllDogImages:
            request.httpMethod = "GET"
            return request
        case .getAllCatBreeds, .getCatImages:
            request.httpMethod = "GET"
            request.setValue("394c2aa6-1085-4c97-9bc1-e8ccd60050da", forHTTPHeaderField: "x-api-key")
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
        print("requesting getAllDogBreeds")
        task.resume()
    }

    func getRandomDogImage(by breed: String, completion: @escaping (Result<DogRamdomImage, Error>) -> Void) {
        let request = AnimalsApiType.getRandomDogImage.getRequest(urlParams: ["breed": breed])
        let task = URLSession(configuration: configuration).dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data, let dogRandomImage = try? JSONDecoder().decode(DogRamdomImage.self, from: data) {
                completion(.success(dogRandomImage))
            }
        }
        print("requesting getRandomDogImage")
        task.resume()
    }

    func getAllDogImages(by breed: String, completion: @escaping (Result<DogImages, Error>) -> Void) {
        let request = AnimalsApiType.getAllDogImages.getRequest(urlParams: ["breed": breed])
        let task = URLSession(configuration: configuration).dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data, let dogImages = try? JSONDecoder().decode(DogImages.self, from: data) {
                completion(.success(dogImages))
            }
        }
        print("requesting getAllDogImages")
        task.resume()
    }
}

// Cat Api
extension NetworkService {
    func getAllCatBreeds(completion: @escaping (Result<CatBreeds, Error>) -> Void) {
        let request = AnimalsApiType.getAllCatBreeds.getRequest(urlParams: nil)
        let task = URLSession(configuration: configuration).dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data, let catBreeds = try? JSONDecoder().decode(CatBreeds.self, from: data) {
                completion(.success(catBreeds))
            }
        }
        print("requesting getAllCatBreeds")
        task.resume()
    }

    func getCatImages(by breedId: String, in quantity: Int, completion: @escaping (Result<CatImages, Error>) -> Void) {
        let urlParams = ["breedId": breedId, "limit": "\(quantity)"]
        let request = AnimalsApiType.getCatImages.getRequest(urlParams: urlParams)
        let task = URLSession(configuration: configuration).dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data, let catImages = try? JSONDecoder().decode(CatImages.self, from: data) {
                completion(.success(catImages))
            }
        }
        print("requesting getCatImages")
        task.resume()
    }
}
