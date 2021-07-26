import UIKit

class StarWarsVC: UIViewController {
    var heroModels = [HeroModel]()
    let databaseService = DefaultDatabaseService(context: DatabaseStack.persistentContainer.viewContext)

    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var starWarsTableView: UITableView!
    @IBOutlet private weak var searchButton: UIButton!


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
            SWApiManager.sharedSW.searchHero(by: name) { response in
                self.removeModels()
                if response.count! == 0 {
                    DispatchQueue.main.async {
                        Alert.showAlert(title: "Not found", message: "try again", on: self)
                    }
                } else {
                    self.handleResults(response)
                    self.reloadView()
                    return
                }
            }
        }
        // databaseService.deleteAllObjectsFromDatabase()
        handleResultsFromDB(by: name)
        self.reloadView()
    }

    private func handleResultsFromDB(by name: String) {
        databaseService.getObjects(by: name) { heroModels in
            for heroModel in heroModels {
                self.heroModels.append(heroModel)
            }
        }
    }

    private func handleResults(_ response: SWHero) {
        for res in response.results! {
            let newHeroModel = HeroModel(res)
            self.heroModels.append(newHeroModel)
            if !self.databaseService.saveToDatabase(newHeroModel) {
                print("Could not save the object: \(newHeroModel)")
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
        guard let cell = starWarsTableView.dequeueReusableCell(
                withIdentifier: HeroCell.identifier,
                for: indexPath) as? HeroCell else { fatalError("Can not create the cell") }
        cell.configure(with: heroModels[indexPath.row])
        return cell
    }
}

// This extension updates searchButton color for dark mode
extension StarWarsVC {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        userInterfaceChangeToDarkMode()
    }

    func userInterfaceChangeToDarkMode() {
        if traitCollection.userInterfaceStyle == .dark {
            searchButton.layer.backgroundColor = UIColor.yellow.cgColor
            searchButton.setTitleColor(UIColor.black, for: .normal)
        }
    }
}
