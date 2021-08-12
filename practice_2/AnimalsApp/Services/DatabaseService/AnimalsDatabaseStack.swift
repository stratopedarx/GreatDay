import CoreData
import Foundation

class AnimalsDatabaseStack {
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AnimalsAppDataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unuble to load persistent stores: \(error)")
            }
        }
        return container
    }()
}
