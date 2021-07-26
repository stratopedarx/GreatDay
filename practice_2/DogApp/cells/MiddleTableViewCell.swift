import UIKit

class MiddleTableViewCell: UITableViewCell {
    static let identifier = "idMiddleCell"
    @IBOutlet private weak var leftImageView: UIImageView!
    @IBOutlet private weak var rightImageView: UIImageView!
    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var rightLabel: UILabel!

    func configure(leftModel: Model, rightModel: Model) {
        self.leftLabel.text = leftModel.breed
        self.rightLabel.text = rightModel.breed
        self.leftImageView.load(url: URL(string: leftModel.imageLink)!)
        self.rightImageView.load(url: URL(string: rightModel.imageLink)!)
    }
}
