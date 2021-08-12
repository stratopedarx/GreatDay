import Foundation

enum AnimalType {
    case cat
    case dog
}

protocol AnimalsListViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol AnimalsListViewPresenterProtocol: AnyObject {
    init(view: AnimalsListViewProtocol, networkService: NetworkServiceProtocol)
    var animals: [Animal] { get set }
    var animalsInfo: [(animalType: AnimalType, breed: String, breedId: String?)] { get set }
    func fetchAnimals(in quantity: Int) -> [Animal]
}

class AnimalsListPresenter: AnimalsListViewPresenterProtocol {
    weak var view: AnimalsListViewProtocol?
    let networkService: NetworkServiceProtocol!
    var animals: [Animal] = []
    var animalsInfo: [(animalType: AnimalType, breed: String, breedId: String?)] = []

    required init(view: AnimalsListViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        getAnimals()
    }

    // Returns a list of unused animals in an amount equal to the parameter `quantity`
    func fetchAnimals(in quantity: Int) -> [Animal] {
        var resultAnimals = [Animal]()
        var count = 0
        for animal in animals where !animal.isUsed {
            resultAnimals.append(animal)
            animal.isUsed = true
            count += 1
            if count == quantity {
                return resultAnimals
            }
        }
        return resultAnimals
    }

    private func getAnimals() {
        if animals.count == 0 {
            getAnimalsInfo()
            animalsInfo.shuffle()
            createAnimals()
        }
    }

    private func getAnimalsInfo() {
        getDogInfo()
        getCatInfo()
    }

    // This func takes image links from api, parse them and create Animal object
    private func createAnimals() {
        var numberOfRequests = 0
        for info in animalsInfo {
            let group = DispatchGroup()
            group.enter()
            if numberOfRequests >= 6 {
                return
            } // DELETE LATER
            switch info.animalType {
            case .dog:
                networkService.getRandomDogImage(by: info.breed) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let dogRandomImage):
                        self.createDog(info.breed, dogRandomImage)
                    case .failure(let error):
                        self.view?.failure(error: error)
                    }
                    group.leave()
                }
            case .cat:
                networkService.getCatImages(by: info.breedId!, in: 1) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let catImage):
                        self.createCat(info.breed, info.breedId!, catImage)
                    case .failure(let error):
                        self.view?.failure(error: error)
                    }
                    group.leave()
                }
            }
            numberOfRequests += 1
            group.wait()
        }
    }
}

// MARK: Dog Api
extension AnimalsListPresenter {
    private func getDogInfo() {
        // https://stackoverflow.com/questions/48869944/wait-response-before-proceeding
        let group = DispatchGroup()
        group.enter()
        networkService.getAllDogBreeds { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let dogBreeds):
                self.parseDogInfo(dogBreeds)
            case .failure(let error):
                self.view?.failure(error: error)
            }
            group.leave()
        }
        group.wait()
    }

    private func parseDogInfo(_ dogBreeds: DogBreeds) {
        if let message = dogBreeds.message {
            for (breed, typeBreeds) in message {
                if typeBreeds.count == 0 {
                    self.animalsInfo.append((animalType: AnimalType.dog, breed: breed, breedId: nil))
                } else {
                    for typeBreed in typeBreeds {
                        let breedName = breed + "/" + typeBreed
                        self.animalsInfo.append((animalType: AnimalType.dog, breed: breedName, breedId: nil))
                    }
                }
            }
        }
    }

    private func createDog(_ breed: String, _ dogRandomImage: DogRamdomImage) {
        if let imageLink = dogRandomImage.message {
            animals.append(Animal(breed: breed, breedId: nil, imageLink: imageLink))
        }
    }
}

// MARK: Cat Api
extension AnimalsListPresenter {
    private func getCatInfo() {
        let group = DispatchGroup()
        group.enter()
        networkService.getAllCatBreeds { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let catBreeds):
                self.parseCatInfo(catBreeds)
            case .failure(let error):
                self.view?.failure(error: error)
            }
            group.leave()
        }
        group.wait()
    }

    private func parseCatInfo(_ catBreeds: CatBreeds) {
        for cat in catBreeds {
            self.animalsInfo.append((animalType: AnimalType.cat, breed: cat.name!, breedId: cat.id!))
        }
    }

    private func createCat(_ breed: String, _ breedId: String, _ catImages: CatImages) {
        if let catImage = catImages.first {
            animals.append(Animal(breed: breed, breedId: breedId, imageLink: catImage.url!))
        }
    }
}
