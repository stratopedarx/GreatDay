import Foundation
import UIKit

protocol BuilderProtocol {
    static func createDetailsBreedModule(breed: String) -> UIViewController
}

class ModuleBuilder: BuilderProtocol {
    static func createDetailsBreedModule(breed: String) -> UIViewController {
        let view = DetailsBreedViewController()
        let networkService = NetworkService()
        let presenter = DetailsBreedPresenter(view: view, networkService: networkService, breed: breed)
        view.presenter = presenter
        return view
    }
}
