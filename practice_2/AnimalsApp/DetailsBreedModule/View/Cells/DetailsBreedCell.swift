import UIKit

class DetailsBreedCell: UICollectionViewCell {
    static let identifier = "detailsBreedCell"
    @IBOutlet private weak var animalImage: UIImageView!

    func configure(by animal: Animal) {
        self.animalImage.load(url: URL(string: animal.imageLink)!)
    }
}
