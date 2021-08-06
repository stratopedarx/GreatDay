import UIKit

class DetailsBreedViewController: UIViewController {
    var presenter: DetailsBreedPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello")
        // presenter.setAnimals()
    }
}

extension DetailsBreedViewController: DetailsBreedViewProtocol {
    func setAnimals(by breed: String) {
        return
    }
}
