import UIKit

class BottomCollectionViewCell: UICollectionViewCell {
    static let identifier = "idCollectionCell"
    @IBOutlet private weak var bottomLabel: UILabel!
    @IBOutlet private weak var bottomImageView: UIImageView!

    func configure(with model: Model) {
        self.bottomLabel.text = model.breed
        self.bottomImageView.load(url: URL(string: model.imageLink)!)
    }
}
