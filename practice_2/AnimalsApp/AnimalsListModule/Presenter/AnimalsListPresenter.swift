import Foundation

protocol AnimalsListViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol AnimalsListViewPresenterProtocol: AnyObject {
    init(view: AnimalsListViewProtocol, networkService: NetworkServiceProtocol)
    var animals: [Animal] { get set }
    var listOfBreeds: [String] { get set }
    var imageLinks: [String: String] { get set }
    func getAnimals()
}

class AnimalsListPresenter: AnimalsListViewPresenterProtocol {
    weak var view: AnimalsListViewProtocol?
    let networkService: NetworkServiceProtocol!
    var animals: [Animal] = []
    var listOfBreeds: [String] = []
    var imageLinks: [String: String] = [:]

    required init(view: AnimalsListViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        getAnimals()
    }

    func getAnimals() {
        if animals.count == 0 {
            getListOfBreeds()
            getImageLinks()
            createAnimals()
            animals.shuffle()
        }
    }

    private func getListOfBreeds() {
        // https://stackoverflow.com/questions/48869944/wait-response-before-proceeding
        let group = DispatchGroup()
        group.enter()
        networkService.getAllDogBreeds { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let dogBreeds):
                self.parseListOfBreeds(dogBreeds)
            case .failure(let error):
                self.view?.failure(error: error)
            }
            group.leave()
        }
        group.wait()
    }

    private func parseListOfBreeds(_ dogBreeds: DogBreeds) {
        if let message = dogBreeds.message {
            for (breed, typeBreeds) in message {
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

    private func getImageLinks() {
        var count = 0
        let group = DispatchGroup()
        group.enter()
        for breed in listOfBreeds {
            if count > 6 {
                group.leave()
                return
            } // DELETE LATER
            count += 1
            networkService.getRandomImage(by: breed) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let dogRandomImage):
                    self.parseImageLinks(for: breed, in: dogRandomImage)
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
        group.wait()
    }

    private func parseImageLinks(for breed: String, in dogRandomImage: DogRamdomImage) {
        if let imageLink = dogRandomImage.message {
            imageLinks[breed] = imageLink
        }
    }

    private func createAnimals() {
        for (breed, imageLink) in imageLinks {
            animals.append(Animal(breed, imageLink))
        }
    }
}
