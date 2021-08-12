import UIKit

class AnimalsMiddleCell: UICollectionViewCell {
    static let identifier = "animalsMiddleCell"
    static let quantityOfAnimals = 2

    var navigationController: UINavigationController?
    var animals = [Animal]()
    @IBOutlet private weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AnimalsMiddleCVCell", bundle: nil),
                                forCellWithReuseIdentifier: AnimalsMiddleCVCell.identifier)
    }
}

// MARK: UICollectionViewDataSource
extension AnimalsMiddleCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        animals.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AnimalsMiddleCVCell.identifier,
                for: indexPath) as? AnimalsMiddleCVCell else { fatalError("Can`t create the cell") }
        cell.configure(by: animals[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension AnimalsMiddleCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let animal = animals[indexPath.row]
        let detailsBreedVC = ModuleBuilder.createDetailsBreedModule(breed: animal.breed, breedId: animal.breedId)
        self.navigationController?.pushViewController(detailsBreedVC, animated: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension AnimalsMiddleCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(190), height: CGFloat(190))
    }
}
