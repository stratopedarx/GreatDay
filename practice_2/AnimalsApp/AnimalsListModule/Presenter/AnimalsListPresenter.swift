import Foundation

let cacheExpired = 1  // one day
let maxNumberOfRequests = 6

protocol AnimalsListViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol AnimalsListViewPresenterProtocol: AnyObject {
    init(view: AnimalsListViewProtocol, networkService: NetworkServiceProtocol)
    var animals: [Animal] { get set }
    var animalsInfo: [AnimalInfoProtocol] { get set }
    func fetchAnimals(in quantity: Int) -> [Animal]
}

class AnimalsListPresenter: AnimalsListViewPresenterProtocol {
    let dbService = DefaultAnimalsDBService(context: AnimalsDatabaseStack.persistentContainer.viewContext)
    weak var view: AnimalsListViewProtocol?
    let networkService: NetworkServiceProtocol!
    var animals = [Animal]()
    var animalsInfo = [AnimalInfoProtocol]()

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
        let now = NSDate()
        let lastApiDate = dbService.getDateFromDB()
        let timeSinceLastApiUpdate = Int(now.timeIntervalSince(lastApiDate as Date))  // in seconds

        if timeSinceLastApiUpdate > cacheExpired {
            dbService.deleteAllAnimalsFromDatabase()
            getAnimalsFromApi()
        } else {
            print("Get data from DB")
            dbService.getAnimalsFromDatabase(onComplete: { animals in
                if animals.count == 0 {
                    self.getAnimalsFromApi()
                } else {
                    self.animals = animals
                    self.animals.shuffle()
                }
            })
        }
    }

    /// Makes requests to api servers and save it to database
    private func getAnimalsFromApi() {
        print("Get data from API")
        getAnimalsInfo()
        animalsInfo.shuffle()
        createAnimals()
        saveAnimalsToDatabse()
    }

    private func saveAnimalsToDatabse() {
        var isAnimalsSaved = false
        var isDateSaved = false
        var attempt = 0
        while !isDateSaved && !isAnimalsSaved && attempt < 5 {
            isAnimalsSaved = dbService.saveAnimalsToDB(animals: animals)
            isDateSaved = dbService.saveDateToDB(date: NSDate())
            attempt += 1
        }
    }

    private func getAnimalsInfo() {
        getDogInfo()
        getCatInfo()
    }

    /// This func takes image links from api, parse them and create Animal object
    private func createAnimals() {
        var numberOfRequests = 0
        for info in animalsInfo {
            let group = DispatchGroup()
            group.enter()
            if numberOfRequests >= maxNumberOfRequests {
                return
            }
            info.createAnimalWithImage(network: networkService, group: group, view: self.view) { animal in
                self.animals.append(animal)
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
                    let animalInfo = DogInfo(breed: breed, breedId: nil)
                    self.animalsInfo.append(animalInfo)
                } else {
                    for typeBreed in typeBreeds {
                        let breedName = breed + "/" + typeBreed
                        let animalInfo = DogInfo(breed: breedName, breedId: nil)
                        self.animalsInfo.append(animalInfo)
                    }
                }
            }
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
            let animalInfo = CatInfo(breed: cat.name!, breedId: cat.id!)
            self.animalsInfo.append(animalInfo)
        }
    }
}
