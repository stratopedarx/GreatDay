import UIKit

class AnimalsBottomCell: UICollectionViewCell {
    static let identifier = "animalsBottomCell"
    @IBOutlet private weak var animalImage: UIImageView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet weak var breedLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        pageControl.numberOfPages = 3
    }

    func configure() {
        swipePage(pageControl)
    }

    @IBAction private func swipePage(_ sender: UIPageControl) {
        animalImage.image = UIImage(named: "cat")
        let arr = ["lala1", "lala2", "lala3"]
        breedLabel.text = arr[sender.currentPage]
    }
}
