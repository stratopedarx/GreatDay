import CoreData
import Foundation

class NewsDatabaseStack {
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewsAppDataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unuble to load persistent stores: \(error)")
            }
        }
        return container
    }()
}
