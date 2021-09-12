import UIKit

class NewsCollectionViewController: UICollectionViewController {
    private let itemsPerRow: CGFloat = 2
    private let itemsPerColumn: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var presenter: NewsPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsNewsSegue" {
            guard let detailsNewsVC = segue.destination as? DetailsNewsViewController else { return }
            guard let cell = sender as? NewsCell else { return }
            detailsNewsVC.article = cell.article
        }
    }

    private func setup() {
        let networkService = NewsNetworkService.sharedNews
        self.presenter = NewsPresenter(view: self, networkService: networkService)
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.topArticles.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let defaultCell = UICollectionViewCell()
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell {
            guard let article = self.presenter?.topArticles[indexPath.item] else { return defaultCell }
            cell.article = article
            cell.configure()
            return cell
        } else {
            print("Can`t create the cell NewsCell")
            return defaultCell
        }
    }

}

// MARK: UICollectionViewDelegateFlowLayout
extension NewsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        let paddingHeight = sectionInsets.left * (itemsPerColumn + 1)
        let availableHeight = collectionView.frame.height - paddingHeight
        let heightPerItem = availableHeight / itemsPerColumn

        return CGSize(width: widthPerItem, height: heightPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: UISearchBarDelegate
extension NewsCollectionViewController: UISearchBarDelegate {
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        let searchView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "searchBar", for: indexPath)

        return searchView
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text {
            presenter?.fetchArticles(by: keyword)
            if presenter?.topArticles.count != 0 {
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: NewsViewProtocol
extension NewsCollectionViewController: NewsViewProtocol {
   func failure(error: Error) {
        print("FAIL!!!")
        print(error.localizedDescription)
    }
}
