import UIKit

class MiddleTableViewCell: UITableViewCell {
    static let identifier = "idMiddleCell"
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    func configure(leftModel: Model, rightModel: Model) {
        self.leftLabel.text = leftModel.breed
        self.rightLabel.text = rightModel.breed
        self.leftImageView.load(url: URL(string: leftModel.imageLink)!)
        self.rightImageView.load(url: URL(string: rightModel.imageLink)!)
    }
}
