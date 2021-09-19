import Foundation

// MARK: - NewsSourceAPI
struct NewsSourceAPI: Codable {
    let status: String?
    let sources: [SourceNews]?
}

// MARK: - Source
struct SourceNews: Codable {
    let id, name, sourceDescription: String?
    let url: String?
    let category: Category?
    let language: Language?
    let country: Country?

    enum CodingKeys: String, CodingKey {
        case id, name
        case sourceDescription = "description"
        case url, category, language, country
    }
}

enum Category: String, Codable {
    case sports
}

enum Country: String, Codable {
    case gb
    case it
    case us
}

enum Language: String, Codable {
    case en
}
