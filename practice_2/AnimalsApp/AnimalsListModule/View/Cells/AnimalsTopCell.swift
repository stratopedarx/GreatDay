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
        self.animalImage.load(url: URL(string: animal.imageLink)!)
    }
}
