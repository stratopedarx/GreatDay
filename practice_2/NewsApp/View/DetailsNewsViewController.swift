import UIKit

class DetailsNewsViewController: UIViewController {
    @IBOutlet private weak var newsImage: UIImageView!
    @IBOutlet private weak var newsDescriptionTextView: UITextView!

    var article: TopArticle?

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        guard let article = article else { return }
        if let url = URL(string: article.urlToImage) {
            newsImage.load(url: url)
        } else {
            print("Could not create URL object for \(article.urlToImage)")
        }
        newsDescriptionTextView.text = article.description
    }

    private func getNewsUrl() -> URL? {
        if let article = article {
            return URL(string: article.url)
        }
        DispatchQueue.main.async {
            Alert.showAlert(title: "Error", message: "Please try again", on: self)
        }
        return nil
    }

    @IBAction func goToSourceAction(_ sender: UIButton) {
        guard let url = getNewsUrl() else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @IBAction func shareAction(_ sender: UIButton) {
        if let url = getNewsUrl() {
            let shareController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            shareController.completionWithItemsHandler = { _, bool, _, _ in
                if bool {
                    print("Successfully sent")
                }
            }

            present(shareController, animated: true, completion: nil)
        }
    }
}
