import UIKit

class AnimalsMiddleCVCell: UICollectionViewCell {
    static let identifier = "animalsMiddleCVCell"
    @IBOutlet private weak var breedLabel: UILabel!
    @IBOutlet private weak var animalImage: UIImageView!

    func configure(by animal: Animal) {
        self.breedLabel.text = animal.breed
        if let url = URL(string: animal.imageLink) {
            self.animalImage.load(url: url)
        } else {
            print("Could not create URL object for \(animal.imageLink)")
        }
    }
}
