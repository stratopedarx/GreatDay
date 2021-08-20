import Foundation

protocol DetailsBreedViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol DetailsBreedPresenterProtocol: AnyObject {
    init(view: DetailsBreedViewProtocol, networkService: NetworkServiceProtocol, breed: String, breedId: String?)
    var breed: String { get set }
    var breedId: String? { get set }  // used only for cat
    var animals: [Animal] { get set }
}

class DetailsBreedPresenter: DetailsBreedPresenterProtocol {
    weak var view: DetailsBreedViewProtocol?
    let networkService: NetworkServiceProtocol!
    var breed: String
    var breedId: String?  // used only for cat
    var animals = [Animal]()

    required init(view: DetailsBreedViewProtocol, networkService: NetworkServiceProtocol,
                  breed: String, breedId: String?) {
        self.view = view
        self.networkService = networkService
        self.breed = breed.replacingOccurrences(of: " ", with: "/")
        self.breedId = breedId
        self.getAnimals()
        self.animals.shuffle()
    }

    private func getAnimals() {
        let group = DispatchGroup()
        group.enter()
        if let breedId = self.breedId {
            networkService.getCatImages(by: breedId, in: maxApiLimitCatImages) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let catImages):
                    self.parseCatImages(catImages)
                case .failure(let error):
                    self.view?.failure(error: error)
                }
                group.leave()
            }
        } else {
            networkService.getAllDogImages(by: self.breed) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let dogImages):
                    self.parseDogImages(dogImages)
                case .failure(let error):
                    self.view?.failure(error: error)
                }
                group.leave()
            }
        }
        group.wait()
    }

    // Parses http response and creates Animal objects
    private func parseDogImages(_ dogImages: DogImages) {
        if let imageLinks = dogImages.message {
            for imageLink in imageLinks {
                animals.append(Animal(breed: breed, breedId: nil, imageLink: imageLink))
            }
        }
    }

    private func parseCatImages(_ catImages: CatImages) {
        for cat in catImages {
            animals.append(Animal(breed: self.breed, breedId: self.breedId, imageLink: cat.url!))
        }
    }
}
