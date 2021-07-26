import UIKit

class HeroCell: UITableViewCell {
    static let identifier = "heroCell"
    @IBOutlet private weak var heroNameLabel: UILabel!
    func configure(with model: HeroModel) {
        self.heroNameLabel.text = model.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 1, green: 0.8941176471, blue: 0, alpha: 1)
        selectedBackgroundView = backgroundView
        textLabel?.textColor = isSelected ? .black : UIColor.label
    }
}
