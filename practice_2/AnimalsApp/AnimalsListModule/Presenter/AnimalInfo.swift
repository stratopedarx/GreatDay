import Foundation

protocol AnimalInfoProtocol {
    func createAnimalWithImage(network: NetworkServiceProtocol, group: DispatchGroup,
                               view: AnimalsListViewProtocol?, completion: @escaping (Animal) -> Void)
}

// It is a helper class for storing, processing animal information and creating Animal.
class AnimalInfo {
    let breed: String
    let breedId: String?

    init(breed: String, breedId: String?) {
        self.breed = breed
        self.breedId = breedId
    }
}

class CatInfo: AnimalInfo, AnimalInfoProtocol {
    func createAnimalWithImage(network: NetworkServiceProtocol, group: DispatchGroup,
                               view: AnimalsListViewProtocol?, completion: @escaping (Animal) -> Void) {
        network.getCatImages(by: self.breedId!, in: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let catImage):
                completion(self.createAnimal(catImage: catImage))
            case .failure(let error):
                view?.failure(error: error)

            }
            group.leave()
        }
    }

    func createAnimal(catImage: CatImages) -> Animal {
        let catImage = catImage.first
        return Animal(breed: self.breed, breedId: self.breedId, imageLink: catImage?.url ?? "")
    }
}

class DogInfo: AnimalInfo, AnimalInfoProtocol {
    func createAnimalWithImage(network: NetworkServiceProtocol, group: DispatchGroup,
                               view: AnimalsListViewProtocol?, completion: @escaping (Animal) -> Void) {
        network.getRandomDogImage(by: self.breed) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let dogRandomImage):
                completion(self.createAnimal(dogRandomImage: dogRandomImage))
            case .failure(let error):
                view?.failure(error: error)
            }
            group.leave()
        }
    }

    func createAnimal(dogRandomImage: DogRamdomImage) -> Animal {
        let imageLink = dogRandomImage.message
        return Animal(breed: breed, breedId: nil, imageLink: imageLink ?? "")
    }
}
