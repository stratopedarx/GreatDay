import CoreData
import Foundation

class DefaultNewsDBService: NewsDatabaseService {
    let dateEntityName = "NewsApiDate"
    let articlesEntityName = "Articles"
    private var managedContext: NSManagedObjectContext

    init(context managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }

}

// MARK: ApiDate methods
extension DefaultNewsDBService {
    func saveDateToDB(date: NSDate) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: dateEntityName, in: managedContext)!
        let apiDate = NSManagedObject(entity: entity, insertInto: managedContext)
        apiDate.setValue(date, forKey: "lastApiUpdate")
        return saveContext()
    }

    func getDateFromDB() -> NSDate {
        let fetchRequest = getFetchRequest(entityName: dateEntityName)
        let currentDate = NSDate()

        do {
            let fetchResult = try managedContext.fetch(fetchRequest)
            let date = fetchResult.last?.value(forKey: "lastApiUpdate") as? NSDate ?? currentDate
            return date
        } catch let error {
            print("Could not fetch date from database. \(error)")
            return currentDate
        }
    }
}

// MARK: Articles methods
extension DefaultNewsDBService {
    func saveArticlesToDB(articles: [TopArticle]) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: articlesEntityName, in: managedContext)!
        for article in articles {
            let dbArticle = NSManagedObject(entity: entity, insertInto: managedContext)
            dbArticle.setValue(article.source, forKey: "source")
            dbArticle.setValue(article.title, forKey: "title")
            dbArticle.setValue(article.description, forKey: "articleDescription")
            dbArticle.setValue(article.url, forKey: "url")
            dbArticle.setValue(article.urlToImage, forKey: "urlToImage")
            dbArticle.setValue(article.publishedAt, forKey: "publishedAt")
        }
        return saveContext()
    }

    func getArticlesFromDatabase(onComplete: @escaping ([TopArticle]) -> Void) {
        let fetchRequest = getFetchRequest(entityName: articlesEntityName)

        do {
            let fetchResult = try managedContext.fetch(fetchRequest)
            let articles = mapFetchedData(fetchResult)
            onComplete(articles)
        } catch let error {
            print("Could not fetch articles from database. \(error)")
        }
    }

    private func mapFetchedData(_ fetched: [NSManagedObject]) -> [TopArticle] {
        return fetched.map { object in
            let source = object.value(forKey: "source") as? String ?? ""
            let title = object.value(forKey: "title") as? String ?? ""
            let description = object.value(forKey: "articleDescription") as? String ?? ""
            let url = object.value(forKey: "url") as? String ?? ""
            let urlToImage = object.value(forKey: "urlToImage") as? String ?? ""
            let publishedAt = object.value(forKey: "publishedAt") as? String ?? ""

            return TopArticle(
                source: source,
                title: title,
                description: description,
                url: url,
                urlToImage: urlToImage,
                publishedAt: publishedAt
            )
        }
    }

    /// Remove all articles from database
    /// Returns number of deleted items.
    func deleteAllArticlesFromDatabase() {
        var items: [NSManagedObject] = []
        do {
            items = try managedContext.fetch(getFetchRequest(entityName: articlesEntityName))
            for item in items {
                managedContext.delete(item)
            }
        } catch let error {
            print("Could not delete all items. \(error)")
        }
        if !saveContext() {
            print("Could not save context after deleting all articles")
            return
        }

        print("Delete \(items.count) objects")
    }
}

// MARK: Useful common DB methods
extension DefaultNewsDBService {
    private func saveContext() -> Bool {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
                return true
            } catch let error {
                print("Could not save to database. \(error)")
            }
        }
        return false
    }

    private func getFetchRequest(entityName: String) -> NSFetchRequest<NSManagedObject> {
        return NSFetchRequest<NSManagedObject>(entityName: entityName)
    }
}
