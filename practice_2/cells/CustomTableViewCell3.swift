import UIKit

class CustomTableViewCell3: UITableViewCell {
    static let identifier = "idCell3"

    var models = [Model]()
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}


extension CustomTableViewCell3: UICollectionViewDataSource, UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier,
                                                    for: indexPath) as! CustomCollectionViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
}

