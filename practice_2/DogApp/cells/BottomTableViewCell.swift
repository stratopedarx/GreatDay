import UIKit

class BottomTableViewCell: UITableViewCell {
    static let identifier = "idBottomCell"

    var collectionModels = [Model]()
    @IBOutlet private weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension BottomTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionModels.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BottomCollectionViewCell.identifier,
                for: indexPath) as?  BottomCollectionViewCell else { fatalError("Can not create the cell") }
        cell.configure(with: collectionModels[indexPath.row])
        return cell
    }
}
