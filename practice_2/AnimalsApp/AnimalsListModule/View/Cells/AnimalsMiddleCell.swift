import UIKit

class AnimalsMiddleCell: UICollectionViewCell {
    static let identifier = "animalsMiddleCell"
    static let quantityOfAnimals = 2
    @IBOutlet private weak var leftAnimalImage: UIImageView!
    @IBOutlet private weak var rightAnimalImage: UIImageView!
    @IBOutlet private weak var leftBreedLabel: UILabel!
    @IBOutlet private weak var rightBreedLabel: UILabel!

    func configure(by animals: [Animal]) {
        if animals.count == 0 { return }
        let leftAnimal = animals[0]
        let rightAnimal = animals[1]
        self.leftBreedLabel.text = leftAnimal.breed
        self.rightBreedLabel.text = rightAnimal.breed
        self.leftAnimalImage.load(url: URL(string: leftAnimal.imageLink)!)
        self.rightAnimalImage.load(url: URL(string: rightAnimal.imageLink)!)
    }
}
