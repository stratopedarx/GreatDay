import UIKit

class AnimalsBottomCVCell: UICollectionViewCell {
    static let identifier = "animalsBottomCVCell"
    @IBOutlet private weak var animalImage: UIImageView!
    @IBOutlet weak var breedLabel: UILabel!

    func configure(by animal: Animal) {
        self.breedLabel.text = animal.breed
        if let url = URL(string: animal.imageLink) {
            self.animalImage.load(url: url)
        } else {
            print("Could not create URL object for \(animal.imageLink)")
        }
    }
}
