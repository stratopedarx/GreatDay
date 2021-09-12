import Foundation

protocol NewsDatabaseService {
    func saveDateToDB(date: NSDate) -> Bool
    func getDateFromDB() -> NSDate
    func saveArticlesToDB(articles: [TopArticle]) -> Bool
    func getArticlesFromDatabase(onComplete: @escaping ([TopArticle]) -> Void)
    func deleteAllArticlesFromDatabase()
}
