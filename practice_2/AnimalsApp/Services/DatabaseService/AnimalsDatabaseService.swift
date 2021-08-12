import Foundation

protocol AnimalsDatabaseService {
    func saveDateToDB(date: NSDate) -> Bool
    func getDateFromDB() -> NSDate
    // func isInDatabase(_ heroModel: HeroModel) -> Bool
    // func saveToDatabase(_ heroModel: HeroModel) -> Bool
    // func removeFromDatabase(_ heroModel: HeroModel) -> Bool
    // func getFromDatabase(onComplete: @escaping ([HeroModel]) -> Void)
}
