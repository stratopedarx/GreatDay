import UIKit

class DetailsBreedViewController: UIViewController {
    var presenter: DetailsBreedPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = self.presenter.breed
        // presenter.setAnimals()
    }
}

extension DetailsBreedViewController: DetailsBreedViewProtocol {
    func success() {
        // collectionView.reloadData()
        print("success")
    }

    func failure(error: Error) {
        print("FAIL!!!")
        print(error.localizedDescription)
    }
    
    func setAnimals(by breed: String) {
        return
    }
}
