//
//  CustomCollectionViewCell.swift
//  practice_2
//
//  Created by user199993 on 6/27/21.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "idCollectionCell"
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var bottomImageView: UIImageView!

    func configure(with model: Model) {
        self.bottomLabel.text = model.breed
        //self.topImageView = model.imageLink
    }
}
