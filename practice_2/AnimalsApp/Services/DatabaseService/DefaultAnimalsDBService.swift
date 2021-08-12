import CoreData
import Foundation

class DefaultAnimalsDBService: AnimalsDatabaseService {
    let dateEntityName = "ApiDate"
    private var managedContext: NSManagedObjectContext

    init(context managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }

}

// MARK: ApiDate methods
extension DefaultAnimalsDBService {
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

// MARK: Useful common DB methods
extension DefaultAnimalsDBService {
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
