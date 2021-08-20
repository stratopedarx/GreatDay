import UIKit

class AnimalsTopCell: UICollectionViewCell {
    static let identifier = "animalsTopCell"
    static let quantityOfAnimals = 1
    @IBOutlet private weak var breedLabel: UILabel!
    @IBOutlet private weak var animalImage: UIImageView!

    func configure(by animals: [Animal]) {
        if animals.count == 0 { return }
        let animal = animals[0]
        self.breedLabel.text = animal.breed
        if let url = URL(string: animal.imageLink) {
            self.animalImage.load(url: url)
        } else {
            print("Could not create URL object for \(animal.imageLink)")
        }
    }
}
