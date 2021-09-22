import UIKit

class QuotesViewController: UIViewController {
    @IBOutlet private weak var quoteTextView: UITextView!
    @IBOutlet private weak var authorLabel: UILabel!
    private var quote: QuoteModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        getQuoteOfTheDay()
        updateUI()
    }

    @IBAction func refreshAction(_ sender: UIButton) {
        getQuoteOfTheDay()
        updateUI()
    }

    @IBAction func shareAction(_ sender: UIButton) {
        if let quote = self.quote {
            let shareController = UIActivityViewController(activityItems: [quote.url], applicationActivities: nil)
            shareController.completionWithItemsHandler = { _, bool, _, _ in
                if bool {
                    print("Successfully sent")
                }
            }
            present(shareController, animated: true, completion: nil)
        }
    }

    private func updateUI() {
        if let quote = self.quote {
            self.quoteTextView.text = "\"\(quote.text)\""
            self.authorLabel.text = "- \(quote.author)"
        }
    }

    private func getQuoteOfTheDay() {
        let group = DispatchGroup()
        group.enter()

        QuotesNetworkService.sharedQuotes.fetchQuoteOfTheDay { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                if let quote = response.quote,
                   let url = quote.url,
                   let author = quote.author,
                   let body = quote.body {
                       self.quote = QuoteModel(url: url, author: author, text: body)
                } else {
                    DispatchQueue.main.async {
                        Alert.showAlert(title: "Error", message: "Pleasy try later", on: self)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    Alert.showAlert(title: "Error", message: error.localizedDescription, on: self)
                }
            }
            group.leave()
        }
        group.wait()
    }
}
