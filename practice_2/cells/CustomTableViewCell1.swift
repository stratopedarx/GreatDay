import UIKit

class CustomTableViewCell1: UITableViewCell {
    static let identifier = "idCell1"
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var topImageView: UIImageView!
    
    func configure(with model: Model) {
        self.topLabel.text = model.breeed
        //self.topImageView = model.imageLink
    }
}
