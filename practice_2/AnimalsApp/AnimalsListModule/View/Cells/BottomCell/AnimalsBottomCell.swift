import UIKit

class AnimalsBottomCell: UICollectionViewCell {
    static let identifier = "animalsBottomCell"
    static let quantityOfAnimals = 3
    static let widthCell = 414
    static let heightCell = 300

    var navigationController: UINavigationController?
    var animals = [Animal]()
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AnimalsBottomCVCell", bundle: nil),
                                forCellWithReuseIdentifier: AnimalsBottomCVCell.identifier)
    }
}

// MARK: UICollectionViewDataSource
extension AnimalsBottomCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        animals.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AnimalsBottomCVCell.identifier, for: indexPath) as? AnimalsBottomCVCell {
            cell.configure(by: animals[indexPath.row])
            return cell
        } else {
            print("Can`t create the cell AnimalsBottomCVCell")
            return UICollectionViewCell()
        }
    }
}

// MARK: UICollectionViewDelegate
extension AnimalsBottomCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let animal = animals[indexPath.row]
        let detailsBreedVC = ModuleBuilder.createDetailsBreedModule(breed: animal.breed, breedId: animal.breedId)
        self.navigationController?.pushViewController(detailsBreedVC, animated: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension AnimalsBottomCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(AnimalsBottomCell.widthCell),
                      height: CGFloat(AnimalsBottomCell.heightCell))
    }
}
