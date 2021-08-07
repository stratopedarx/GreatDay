import Foundation

protocol DetailsBreedViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
    func setAnimals(by breed: String)
}

protocol DetailsBreedPresenterProtocol: AnyObject {
    init(view: DetailsBreedViewProtocol, networkService: NetworkServiceProtocol, breed: String)
    func setAnimals()
    var breed: String! { get set }
}

class DetailsBreedPresenter: DetailsBreedPresenterProtocol {
    weak var view: DetailsBreedViewProtocol?
    let networkService: NetworkServiceProtocol!
    var breed: String!
    var animals = [Animal]()

    required init(view: DetailsBreedViewProtocol, networkService: NetworkServiceProtocol, breed: String) {
        self.view = view
        self.networkService = networkService
        self.breed = breed.replacingOccurrences(of: " ", with: "/")
        self.getAnimals()
        self.animals.shuffle()
    }

    private func getAnimals() {
        let group = DispatchGroup()
        group.enter()
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
        group.wait()
    }

    // Parses http response and creates Animal objects
    private func parseDogImages(_ dogImages: DogImages) {
        if let imageLinks = dogImages.message {
            for imageLink in imageLinks {
                print(imageLinks)
                animals.append(Animal(self.breed, imageLink))
            }
        }
    }

    func setAnimals() {
        self.view?.setAnimals(by: breed)
    }
}
