import UIKit

class NewsGreatAppCell: UITableViewCell {
    @IBOutlet private weak var sourceNameLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!

    static let identifier = "newsGreatAppCell"
    static let defaultHeight = 200

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(by cell: NewsSourceModel) {
        sourceNameLabel.text = cell.name
        descriptionTextView.text = cell.description
    }
}
