import UIKit

class StarWarsVC: UIViewController {
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var starWarsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        starWarsTableView.dataSource = self
        starWarsTableView.delegate = self
    }

    @IBAction func searchHero(_ sender: UIButton) {
        if searchTextField.text != "" {
            print("hello")
        } else {
            Alert.showAlert(title: "wrong input data", message: "try again", on: self)
        }
    }
}

extension StarWarsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = starWarsTableView.dequeueReusableCell(withIdentifier: HeroCell.identifier,
                                                         for: indexPath) as! HeroCell
        // swiftlint:enable force_cast
        //cell.configure(with: models[getIndex(indexPath)])
        return cell
    }
}
