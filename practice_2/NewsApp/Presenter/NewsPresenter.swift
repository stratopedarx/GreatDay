import Foundation

let newsCacheExpired = 1  // 15 minutes
let newsMaxNumberOfConnectionAttempts = 5

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
    let dbService = DefaultNewsDBService(context: NewsDatabaseStack.persistentContainer.viewContext)

    required init(view: NewsViewProtocol, networkService: NewsNetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        getTopNews()
    }

    private func getTopNews() {
        let now = NSDate()
        let lastApiDate = dbService.getDateFromDB()
        let timeSinceLastApiUpdate = Int(now.timeIntervalSince(lastApiDate as Date))  // in seconds

        if timeSinceLastApiUpdate > newsCacheExpired {
            dbService.deleteAllArticlesFromDatabase()
            getArticlesFromApi()
        } else {
            print("Get data from DB")
            dbService.getArticlesFromDatabase(onComplete: { articlesDB in
                if articlesDB.count == 0 {
                    self.getArticlesFromApi()
                } else {
                    self.topArticles = articlesDB
                    self.topArticles.shuffle()
                }
            })
        }
    }

    /// Makes requests to api servers and save it to database
    private func getArticlesFromApi() {
        print("Get data from API")
        self.fetchTopNews(country: "ru")
        saveArticlesToDatabse()
    }

    private func saveArticlesToDatabse() {
        var isArticlesSaved = false
        var isDateSaved = false
        var attempt = 0
        while !isDateSaved && !isArticlesSaved && attempt < newsMaxNumberOfConnectionAttempts {
            isArticlesSaved = dbService.saveArticlesToDB(articles: topArticles)
            isDateSaved = dbService.saveDateToDB(date: NSDate())
            attempt += 1
        }
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
                        TopArticle(
                            source: sourceName,
                            title: title,
                            description: description,
                            url: url,
                            urlToImage: urlToImage,
                            publishedAt: publishedAt
                        )
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
