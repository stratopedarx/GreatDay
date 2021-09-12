import UIKit

class NewsCell: UICollectionViewCell {
    static let identifier = "newsCell"
    var article: TopArticle?
    @IBOutlet private weak var newsImage: UIImageView!
    @IBOutlet private weak var newsTitleLabel: UILabel!

    func configure() {
        guard let article = article else { return }
        let numberOfCharactersInLine = 35
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
