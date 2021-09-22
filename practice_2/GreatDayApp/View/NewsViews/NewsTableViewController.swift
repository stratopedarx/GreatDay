import UIKit

let defaultCountry = "us"

class NewsTableViewController: UITableViewController {
    var sourcesNews = [NewsSourceModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSourceNews(country: defaultCountry)
    }
}

// MARK: UITableViewDelegate
extension NewsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourcesNews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsGreatAppCell.identifier, for: indexPath) as? NewsGreatAppCell {
            cell.configure(by: sourcesNews[indexPath.row])
            return cell
        } else {
            print("Can`t create the cell NewsGreatAppCell")
            return defaultCell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(NewsGreatAppCell.defaultHeight)
    }
}

// MARK: UITableViewDelegate
extension NewsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToSource(by: sourcesNews[indexPath.row].url)
    }
}

private extension NewsTableViewController {
    func fetchSourceNews(country: String) {
        let group = DispatchGroup()
        group.enter()
        NewsNetworkService.sharedNews.fetchSourceNews(country: country) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let sources):
                    self.parseSourceNews(sources)
                case .failure(let error):
                    DispatchQueue.main.async {
                        Alert.showAlert(title: "Error", message: error.localizedDescription, on: self)
                    }
            }
            group.leave()
        }
        group.wait()
    }

    func parseSourceNews(_ sources: NewsSourceAPI) {
        if let sources = sources.sources {
            for source in sources {
                if let name = source.name,
                   let description = source.sourceDescription,
                   let url = source.url {
                      sourcesNews.append(NewsSourceModel(name: name, description: description, url: url))
                }
            }
        }
    }

    func goToSource(by url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            DispatchQueue.main.async {
                Alert.showAlert(title: "Error", message: "Please try again", on: self)
            }
        }
    }
}
