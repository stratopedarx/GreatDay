import UIKit

class NewsCell: UICollectionViewCell {
    static let identifier = "newsCell"
    @IBOutlet private weak var newsImage: UIImageView!
    @IBOutlet private weak var newsTitleLabel: UILabel!

    func configure(article: TopArticle) {
        newsTitleLabel.text = article.title[0...35] + "..."
        if let url = URL(string: article.urlToImage) {
            newsImage.load(url: url)
        } else {
            print("Could not create URL object for \(article.urlToImage)")
        }
    }
}
