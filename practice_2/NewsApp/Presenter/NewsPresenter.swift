import Foundation

protocol NewsViewProtocol: AnyObject {
    func failure(error: Error)
}

protocol NewsPresenterProtocol: AnyObject {
    var topArticles: [TopArticle] { get set }
    init(view: NewsViewProtocol, networkService: NewsNetworkServiceProtocol)
    func fetchArticles(by keyword: String)
    func sortAlphabetically(inOrder: String)
}

class NewsPresenter: NewsPresenterProtocol {
    var topArticles = [TopArticle]()
    weak var view: NewsViewProtocol?
    let networkService: NewsNetworkServiceProtocol

    required init(view: NewsViewProtocol, networkService: NewsNetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        fetchTopNews(country: "ru")
    }
}

// MARK: fetchTopNews
extension NewsPresenter {
    func fetchTopNews(country: String) {
        let group = DispatchGroup()
        group.enter()
        networkService.fetchTopNews(country: country) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let topNews):
                    self.parseTopNews(topNews)
                case .failure(let error):
                    self.view?.failure(error: error)
            }
            group.leave()
        }
        group.wait()
    }

    func fetchArticles(by keyword: String) {
        topArticles = []
        let group = DispatchGroup()
        group.enter()
        networkService.fetchArticles(by: keyword) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let articles):
                    self.parseTopNews(articles)
                case .failure(let error):
                    self.view?.failure(error: error)
            }
            group.leave()
        }
        group.wait()
    }

    private func parseTopNews(_ topNews: NewsAPI) {
        if let articles = topNews.articles {
            for article in articles {
                if let source = article.source, let sourceName = source.name, let title = article.title,
                   let description = article.articleDescription, let url = article.url,
                   let urlToImage = article.urlToImage, let publishedAt = article.publishedAt {
                    topArticles.append(
                        TopArticle(source: sourceName, title: title, description: description,
                                   url: url, urlToImage: urlToImage, publishedAt: publishedAt)
                    )
                }
            }
        }
    }
}

// MARK: Sort alphabetically
extension NewsPresenter {
    func sortAlphabetically(inOrder: String) {
        if inOrder == "up" {
            topArticles = topArticles.sorted { $0.title.lowercased() < $1.title.lowercased() }
        } else {
            topArticles = topArticles.sorted { $0.title.lowercased() > $1.title.lowercased() }
        }
    }
}
