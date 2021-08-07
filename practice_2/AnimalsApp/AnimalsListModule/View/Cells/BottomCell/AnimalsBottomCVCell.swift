import UIKit

class AnimalsBottomCVCell: UICollectionViewCell {
    static let identifier = "animalsBottomCVCell"
    @IBOutlet private weak var animalImage: UIImageView!
    @IBOutlet weak var breedLabel: UILabel!

    func configure(by animal: Animal) {
        self.breedLabel.text = animal.breed
        self.animalImage.load(url: URL(string: animal.imageLink)!)
    }

}
