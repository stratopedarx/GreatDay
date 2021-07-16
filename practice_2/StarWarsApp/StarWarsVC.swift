import UIKit

class StarWarsVC: UIViewController {
    var heroModels = [HeroModel]()

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var starWarsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        starWarsTableView.dataSource = self
        starWarsTableView.delegate = self
    }

    @IBAction func searchHero(_ sender: UIButton) {
        removeModels()
        let name = searchTextField.text!
        if name == "" {
            Alert.showAlert(title: "wrong input data", message: "try again", on: self)
        } else {
            SWApiManager.sharedSW.searchHero(by: name) { hero in
                if hero.count! == 0 {
                    DispatchQueue.main.async {
                        Alert.showAlert(title: "Not found", message: "try again", on: self)
                    }
                } else {
                    for res in hero.results! {
                        self.heroModels.append(HeroModel(res))
                    }
                    self.reloadView()
                }
            }
        }
    }

    /// UIKit isn't thread safe. The UI should only be updated from main thread
    private func reloadView() {
        DispatchQueue.main.async {
            self.starWarsTableView.reloadData()
        }
    }

    /// Remove all elements from array 'heroModels' before dispaying new data
    private func removeModels() {
        if heroModels.count != 0 {
            heroModels.removeAll()
        }
    }
}

extension StarWarsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "StarWars", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(identifier: "DetailHeroVC") as? DetailHeroVC {
            detailVC.configure(with: heroModels[indexPath.row])
            show(detailVC, sender: nil)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = starWarsTableView.dequeueReusableCell(withIdentifier: HeroCell.identifier,
                                                         for: indexPath) as! HeroCell
        // swiftlint:enable force_cast
        cell.configure(with: heroModels[indexPath.row])
        return cell
    }
}
