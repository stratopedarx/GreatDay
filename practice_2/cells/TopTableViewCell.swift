import UIKit

class TopTableViewCell: UITableViewCell {
    static let identifier = "idTopCell"
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var topImageView: UIImageView!
    
    func configure(with model: Model) {
        self.topLabel.text = model.breed
        self.topImageView.load(url: URL(string: model.imageLink)!)
    }
}
