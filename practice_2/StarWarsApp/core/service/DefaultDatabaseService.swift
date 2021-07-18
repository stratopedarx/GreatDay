import CoreData
import Foundation

class DefaultDatabaseService: DatabaseService {
    let entityName = "SWHeroModel"
    private var managedContext: NSManagedObjectContext

    init(context managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }

    func saveToDatabase(_ heroModel: HeroModel) -> Bool {
        if isExist(heroModel) {
            return false
        }

        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let hero = NSManagedObject(entity: entity, insertInto: managedContext)

        hero.setValue(heroModel.name, forKey: "name")
        hero.setValue(heroModel.height, forKey: "height")
        hero.setValue(heroModel.mass, forKey: "mass")
        hero.setValue(heroModel.hairColor, forKey: "hairColor")
        hero.setValue(heroModel.skinColor, forKey: "skinColor")
        hero.setValue(heroModel.eyeColor, forKey: "eyeColor")
        hero.setValue(heroModel.birthYear, forKey: "birthYear")
        hero.setValue(heroModel.gender, forKey: "gender")
        return saveContext()
    }

    func getFromDatabase(onComplete: @escaping ([HeroModel]) -> Void) {
           let fetchRequest = getFetchRequest()

           do {
               guard let fetchResult = try managedContext.fetch(fetchRequest) as? [SWHeroModel] else { return }
               let heroes = mapFetchedData(fetchResult)
               onComplete(heroes)
           } catch let error {
               print("Could not fetch heroes from database. \(error)")
           }
       }

    private func mapFetchedData(_ fetched: [SWHeroModel]) -> [HeroModel] {
        return fetched.map { object in
            let name = object.value(forKey: "name") as? String
            let height = object.value(forKey: "height") as? String
            let mass = object.value(forKey: "mass") as? String
            let hairColor = object.value(forKey: "hairColor") as? String
            let skinColor = object.value(forKey: "skinColor") as? String
            let eyeColor = object.value(forKey: "eyeColor") as? String
            let birthYear = object.value(forKey: "birthYear") as? String
            let gender = object.value(forKey: "gender") as? String
            let result = Result(name: name, height: height, mass: mass, hairColor: hairColor,
                                skinColor: skinColor, eyeColor: eyeColor, birthYear: birthYear, gender: gender,
                                homeworld: nil, films: nil, species: nil, vehicles: nil,
                                starships: nil, created: nil, edited: nil, url: nil)
            return HeroModel(result)
        }
    }

    // MARK: below helper methods
    private func isExist(_ heroModel: HeroModel) -> Bool {
        let fetchRequest = getFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", heroModel.name!)
        var results: [NSManagedObject] = []

        do {
            results = try managedContext.fetch(fetchRequest)
        } catch let error {
            print("Error executing fetch request. \(error)")
        }
        return results.count > 0
    }

    func getObjects(by name: String, onComplete: @escaping ([HeroModel]) -> Void) {
        let fetchRequest = getFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] '\(name)'")

        do {
            guard let fetchResult = try managedContext.fetch(fetchRequest) as? [SWHeroModel] else { return }
            let heroes = mapFetchedData(fetchResult)
            onComplete(heroes)
        } catch let error {
            print("Error executing fetch request. \(error)")
        }
    }

    private func getFetchRequest() -> NSFetchRequest<NSManagedObject> {
        return NSFetchRequest<NSManagedObject>(entityName: entityName)
    }

    private func saveContext() -> Bool {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
                return true
            } catch let error {
                print("Could not save hero to database. \(error)")
            }
        }
        return false
    }

    /// This method only for developers.
    /// Remove all objects from database.
    /// Returns number of deleted items.
    func deleteAllObjectsFromDatabase() -> Int {
        var items: [NSManagedObject] = []
        do {
            items = try managedContext.fetch(getFetchRequest())
            for item in items {
                managedContext.delete(item)
            }
        } catch let error {
            print("Could not delete all items. \(error)")
            return 0
        }
        if !saveContext() {
            return 0
        }

        print("Delete \(items.count) objects")
        return items.count
    }
}
