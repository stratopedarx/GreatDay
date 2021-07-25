import UIKit

class AnimalsTopCell: UICollectionViewCell {
    static let identifier = "animalsTopCell"
    @IBOutlet private weak var breedLabel: UILabel!
    @IBOutlet private weak var animalImage: UIImageView!

    func configure() {
        self.breedLabel.text = "Easy Text"
        let image : UIImage = UIImage(named: "cat")!
        self.animalImage.image = image
    }
}
