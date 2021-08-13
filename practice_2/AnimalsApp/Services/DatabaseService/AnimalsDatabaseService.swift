import Foundation

protocol AnimalsDatabaseService {
    func saveDateToDB(date: NSDate) -> Bool
    func getDateFromDB() -> NSDate
    func saveAnimalsToDB(animals: [Animal]) -> Bool
    func getAnimalsFromDatabase(onComplete: @escaping ([Animal]) -> Void)
    func deleteAllAnimalsFromDatabase()
}
