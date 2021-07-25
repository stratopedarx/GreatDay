import Foundation

protocol AnimalsListViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol AnimalsListViewPresenterProtocol: AnyObject {
    init(view: AnimalsListViewProtocol, networkService: NetworkServiceProtocol)
    var animals: [Animal]? { get set }
    var listOfBreeds: [String] { get set }
    func getAnimals()
}

class AnimalsListPresenter: AnimalsListViewPresenterProtocol {
    weak var view: AnimalsListViewProtocol?
    let networkService: NetworkServiceProtocol!
    var animals: [Animal]?
    var listOfBreeds: [String] = []

    required init(view: AnimalsListViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        getAnimals()
    }

    func getAnimals() {
        getListOfBreeds()
    }

    private func getListOfBreeds() {
        networkService.getAllDogBreeds { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let dogBreeds):
                    self.parseListOfBreeds(dogBreeds)
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }

    private func parseListOfBreeds(_ dogBreeds: DogBreeds) {
        for row in dogBreeds.message! {
            let breed: String = row.key
            let typeBreeds: [String] = row.value
            if typeBreeds.count == 0 {
                self.listOfBreeds.append(breed)
            } else {
                for typeBreed in typeBreeds {
                    self.listOfBreeds.append(breed + "/" + typeBreed)
                }
            }
        }
    }
}
