//
//  CustomTableViewCell_3.swift
//  practice_2
//
//  Created by user199993 on 6/27/21.
//

import UIKit

class CustomTableViewCell_3: UITableViewCell {
    static let identifier = "idCell_3"

    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}


extension CustomTableViewCell_3: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier,
                                                    for: indexPath) as! CustomCollectionViewCell
        return cell
    }
}


extension CustomTableViewCell_3: UICollectionViewDelegate {
    
}
