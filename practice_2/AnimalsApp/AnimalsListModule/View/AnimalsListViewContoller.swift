import UIKit

let animalsInOneBlock = 6 // one block contains 3 cells (6 animals)
let numberOfItemsInSection = 3

class AnimalsListViewContoller: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    var presenter: AnimalsListViewPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureCV()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setup() {
        let networkService = NetworkService()
        self.presenter = AnimalsListPresenter(view: self, networkService: networkService)
    }

    private func configureCV() {
        let topNib = UINib(nibName: "AnimalsTopCell", bundle: nil)
        let middleNib = UINib(nibName: "AnimalsMiddleCell", bundle: nil)
        let bottomNib = UINib(nibName: "AnimalsBottomCell", bundle: nil)
        collectionView.register(topNib, forCellWithReuseIdentifier: AnimalsTopCell.identifier)
        collectionView.register(middleNib, forCellWithReuseIdentifier: AnimalsMiddleCell.identifier)
        collectionView.register(bottomNib, forCellWithReuseIdentifier: AnimalsBottomCell.identifier)
    }
}

// MARK: UICollectionViewDataSource
extension AnimalsListViewContoller: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.presenter.animals.count/animalsInOneBlock
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch getScreenSpace(indexPath.row % numberOfItemsInSection) {
        case .top:
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AnimalsTopCell.identifier, for: indexPath) as? AnimalsTopCell {
                let animals = presenter.fetchAnimals(in: AnimalsTopCell.quantityOfAnimals)
                cell.configure(by: animals)
                return cell
            } else {
                print("Can`t create the cell AnimalsTopCell")
                return UICollectionViewCell()
            }

        case .middle:
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AnimalsMiddleCell.identifier, for: indexPath) as? AnimalsMiddleCell {
                cell.animals = presenter.fetchAnimals(in: AnimalsMiddleCell.quantityOfAnimals)
                cell.navigationController = self.navigationController
                return cell
            } else {
                print("Can`t create the cell AnimalsMiddleCell")
                return UICollectionViewCell()
            }
        case .bottom:
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AnimalsBottomCell.identifier, for: indexPath) as? AnimalsBottomCell {
                cell.animals = presenter.fetchAnimals(in: AnimalsBottomCell.quantityOfAnimals)
                if cell.animals.count == 0 {
                    return cell
                }
                cell.navigationController = self.navigationController
                return cell
            } else {
                print("Can`t create the cell AnimalsBottomCell")
                return UICollectionViewCell()
            }
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension AnimalsListViewContoller: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width,
                      height: CGFloat(getHeight(indexPath)))
    }
}

// MARK: UICollectionViewDelegate
extension AnimalsListViewContoller: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.section * animalsInOneBlock + indexPath.row
        let animal = self.presenter.animals[index]
        let breed = animal.breed
        let breedId = animal.breedId
        let detailsBreedVC = ModuleBuilder.createDetailsBreedModule(breed: breed, breedId: breedId)
        self.navigationController?.pushViewController(detailsBreedVC, animated: true)
    }
}

// MARK: useful private methods
extension AnimalsListViewContoller {
    private func getScreenSpace(_ position: Int) -> ScreenSpace {
        if position == 0 {
            return ScreenSpace.top
        } else if position == 1 {
            return ScreenSpace.middle
        } else {
            return ScreenSpace.bottom
        }
    }

    private func getHeight(_ indexPath: IndexPath) -> Int {
        switch getScreenSpace(indexPath.row % 3) {
        case .top:  return 120
        case .middle: return 260
        case .bottom: return 300
        }
    }
}

extension AnimalsListViewContoller: AnimalsListViewProtocol {
    func success() {
        collectionView.reloadData()
    }

    func failure(error: Error) {
        print("FAIL!!!")
        print(error.localizedDescription)
    }
}
