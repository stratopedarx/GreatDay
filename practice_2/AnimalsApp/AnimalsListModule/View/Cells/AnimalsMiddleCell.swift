import UIKit

class AnimalsMiddleCell: UICollectionViewCell {
    static let identifier = "animalsMiddleCell"
    @IBOutlet private weak var leftAnimalImage: UIImageView!
    @IBOutlet private weak var rightAnimalImage: UIImageView!
    @IBOutlet private weak var leftBreedLabel: UILabel!
    @IBOutlet private weak var rightBreedLabel: UILabel!

    func configure() {
        self.leftBreedLabel.text = "Text1"
        self.rightBreedLabel.text = "Text2"
        let image1 : UIImage = UIImage(named: "cat")!
        let image2 : UIImage = UIImage(named: "cat")!
        self.leftAnimalImage.image = image1
        self.rightAnimalImage.image = image2
    }
}
