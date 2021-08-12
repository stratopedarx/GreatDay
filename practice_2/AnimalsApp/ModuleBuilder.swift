import Foundation
import UIKit

protocol BuilderProtocol {
    static func createDetailsBreedModule(breed: String, breedId: String?) -> UIViewController
}

class ModuleBuilder: BuilderProtocol {
    static func createDetailsBreedModule(breed: String, breedId: String?) -> UIViewController {
        let view = DetailsBreedViewController()
        let networkService = NetworkService()
        let presenter = DetailsBreedPresenter(view: view, networkService: networkService,
                                              breed: breed, breedId: breedId)
        view.presenter = presenter
        return view
    }
}
