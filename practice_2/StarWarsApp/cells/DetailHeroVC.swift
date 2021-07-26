import UIKit

class DetailHeroVC: UIViewController {
    var name = ""
    var text = ""

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var detailTextLabel: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        detailTextLabel.text = text
    }

    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    func configure(with model: HeroModel) {
        self.name = model.name!
        self.text = """
            name: \(model.name!)
            height: \(model.height!)
            mass: \(model.mass!)
            hair color: \(model.hairColor!)
            skin color: \(model.skinColor!)
            eye color: \(model.eyeColor!)
            birth year: \(model.birthYear!)
            gender: \(model.gender!)
            """
    }
}
