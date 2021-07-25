import UIKit

class AnimalsListViewContoller: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCV()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func configureCV() {
        let nib = UINib(nibName: "AnimalsTopCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: AnimalsTopCell.identifier)
    }
}

extension AnimalsListViewContoller: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AnimalsTopCell.identifier,
                for: indexPath) as? AnimalsTopCell else { fatalError("Can not create the cell") }
        cell.configure()
        return cell
    }
}

extension AnimalsListViewContoller: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width,
                      height: collectionView.bounds.height/CGFloat(3))
    }
}

extension AnimalsListViewContoller: UICollectionViewDelegate {
}
