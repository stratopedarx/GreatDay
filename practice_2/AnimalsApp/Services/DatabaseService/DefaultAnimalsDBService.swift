import CoreData
import Foundation

class DefaultAnimalsDBService: AnimalsDatabaseService {
    let dateEntityName = "ApiDate"
    let animalsEntityName = "Animals"
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

// MARK: Animals methons
extension DefaultAnimalsDBService {
    func saveAnimalsToDB(animals: [Animal]) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: animalsEntityName, in: managedContext)!
        for animal in animals {
            let dbAnimal = NSManagedObject(entity: entity, insertInto: managedContext)
            dbAnimal.setValue(animal.breed, forKey: "breed")
            dbAnimal.setValue(animal.breedId ?? "", forKey: "breedId")
            dbAnimal.setValue(animal.imageLink, forKey: "imageLink")
        }
        return saveContext()
    }

    func getAnimalsFromDatabase(onComplete: @escaping ([Animal]) -> Void) {
        let fetchRequest = getFetchRequest(entityName: animalsEntityName)

        do {
            let fetchResult = try managedContext.fetch(fetchRequest)
            let animals = mapFetchedData(fetchResult)
            onComplete(animals)
        } catch let error {
            print("Could not fetch animals from database. \(error)")
        }
    }

    private func mapFetchedData(_ fetched: [NSManagedObject]) -> [Animal] {
        return fetched.map { object in
            let breed = object.value(forKey: "breed") as? String ?? ""
            var breedId = object.value(forKey: "breedId") as? String
            if breedId == "" { breedId = nil }
            let imageLink = object.value(forKey: "imageLink") as? String ?? ""
            return Animal(breed: breed, breedId: breedId, imageLink: imageLink)
        }
    }

    /// Remove all animals from database
    /// Returns number of deleted items.
    func deleteAllAnimalsFromDatabase() {
        var items: [NSManagedObject] = []
        do {
            items = try managedContext.fetch(getFetchRequest(entityName: animalsEntityName))
            for item in items {
                managedContext.delete(item)
            }
        } catch let error {
            print("Could not delete all items. \(error)")
        }
        if !saveContext() {
            print("Could not save context after deleting all animals")
            return
        }

        print("Delete \(items.count) objects")
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
