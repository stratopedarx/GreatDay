import Foundation

protocol DetailsBreedViewProtocol: AnyObject {
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

    required init(view: DetailsBreedViewProtocol, networkService: NetworkServiceProtocol, breed: String) {
        self.view = view
        self.networkService = networkService
        self.breed = breed
    }

    func setAnimals() {
        self.view?.setAnimals(by: breed)
    }

}
