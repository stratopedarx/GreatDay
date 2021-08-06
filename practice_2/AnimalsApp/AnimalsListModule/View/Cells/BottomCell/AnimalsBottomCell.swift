import UIKit

class AnimalsBottomCell: UICollectionViewCell {
    static let identifier = "animalsBottomCell"
    static let quantityOfAnimals = 3
    @IBOutlet private weak var animalImage: UIImageView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet weak var breedLabel: UILabel!
    var animals = [Animal]()

    override func awakeFromNib() {
        super.awakeFromNib()
        pageControl.numberOfPages = 3
    }

    func configure(by animals: [Animal]) {
        if animals.count == 0 { return }
        self.animals = animals
        swipePage(pageControl)
    }

    @IBAction private func swipePage(_ sender: UIPageControl) {
        let animal = self.animals[sender.currentPage]
        animalImage.load(url: URL(string: animal.imageLink)!)
        breedLabel.text = animal.breed
    }
}
