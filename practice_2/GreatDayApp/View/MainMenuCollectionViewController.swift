import UIKit

let countOfCells = 4

class MainMenuCollectionViewController: UICollectionViewController {
    private let itemsPerRow: CGFloat = 2
    private let itemsPerColumn: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 30, left: 10, bottom: 100, right: 10)

    private let labelNames = ["Meditation", "Exercises", "Sports News", "Quote of the Day"]
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundView = imageView

    }

    @IBAction func slideMenuTapped(_ sender: UIBarButtonItem) {
        HamburgerMenu().triggerSideMenu()
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countOfCells
    }

    override func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let defaultCell = UICollectionViewCell()
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GreatDayCell.identifier, for: indexPath) as? GreatDayCell {
            cell.nameLabel.text = labelNames[indexPath.row]
            return cell
        } else {
            print("Can`t create the cell GreadDayCell")
            return defaultCell
        }
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        if index == 0 {
            self.performSegue(withIdentifier: "meditationSegue", sender: self)
        } else if index == 1 {
            self.performSegue(withIdentifier: "exercisesSegue", sender: self)
        } else if index == 2 {
            self.performSegue(withIdentifier: "newsSourceSegue", sender: self)
        } else if index == 3 {
            self.performSegue(withIdentifier: "quotesSegue", sender: self)
        }
    }

}

// MARK: DarkMode
extension MainMenuCollectionViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        userInterfaceChangeToDarkMode()
    }

    func userInterfaceChangeToDarkMode() {
        if traitCollection.userInterfaceStyle == .dark {
            imageView.image = UIImage(named: "backgroundNight")
        }
        if traitCollection.userInterfaceStyle == .light {
            imageView.image = UIImage(named: "background")
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension MainMenuCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = sectionInsets.left * (itemsPerRow + 1) // add 1, there are 1 more indents than items
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        let paddingHeight = sectionInsets.left * (itemsPerColumn + 1) // add 1, there are 1 more indents than items
        let availableHeight = collectionView.frame.height - paddingHeight - 200
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
