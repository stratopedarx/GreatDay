import UIKit

class DetailsBreedViewController: UIViewController {
    var presenter: DetailsBreedPresenterProtocol!
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = self.presenter.breed.replacingOccurrences(of: "/", with: " ")
        createCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "DetailsBreedCell", bundle: nil),
                                forCellWithReuseIdentifier: DetailsBreedCell.identifier)
    }

    private func createCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.view.addSubview(collectionView)
    }
}

// MARK: UICollectionViewDataSource
extension DetailsBreedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.animals.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailsBreedCell.identifier,
                for: indexPath) as? DetailsBreedCell else { fatalError("Can`t create the cell") }
        cell.configure(by: self.presenter.animals[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegate
 extension DetailsBreedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fullScreenBreedVC = FullScreenBreedViewController()
        fullScreenBreedVC.animal = self.presenter.animals[indexPath.row]
        self.navigationController?.pushViewController(fullScreenBreedVC, animated: true)
    }
 }

// MARK: UICollectionViewDelegateFlowLayout
extension DetailsBreedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (layout?.minimumInteritemSpacing ?? 0.0) +
            (layout?.sectionInset.left ?? 0.0) + (layout?.sectionInset.right ?? 0.0)
        let size: CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
}

extension DetailsBreedViewController: DetailsBreedViewProtocol {
    func success() {
        collectionView.reloadData()
        print("success")
    }

    func failure(error: Error) {
        print("FAIL!!!")
        print(error.localizedDescription)
    }
}
