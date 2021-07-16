import CoreData
import Foundation

class DatabaseStack {
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StarWarsDataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unuble to load persistent stores: \(error)")
            }
        }
        return container
    }()
}
