import UIKit

class AnimalsMiddleCVCell: UICollectionViewCell {
    static let identifier = "animalsMiddleCVCell"
    @IBOutlet private weak var breedLabel: UILabel!
    @IBOutlet private weak var animalImage: UIImageView!

    func configure(by animal: Animal) {
        self.breedLabel.text = animal.breed
        self.animalImage.load(url: URL(string: animal.imageLink)!)
    }
}
