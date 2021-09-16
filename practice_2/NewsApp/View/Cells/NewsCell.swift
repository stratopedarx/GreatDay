import UIKit

let numberOfCharactersInLine = 35

class NewsCell: UICollectionViewCell {
    @IBOutlet private weak var newsImage: UIImageView!
    @IBOutlet private weak var newsTitleLabel: UILabel!

    static let identifier = "newsCell"
    var article: TopArticle?

    func configure() {
        guard let article = article else { return }
        let title = article.title.count > numberOfCharactersInLine ?
            "\(article.title[0...numberOfCharactersInLine])..." : article.title

        newsTitleLabel.text = title
        if let url = URL(string: article.urlToImage) {
            newsImage.load(url: url)
        } else {
            print("Could not create URL object for \(article.urlToImage)")
        }
    }
}
