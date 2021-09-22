// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let quoteOfTheDay = try? newJSONDecoder().decode(QuoteOfTheDay.self, from: jsonData)

import Foundation

// MARK: - QuoteOfTheDay
struct QuoteOfTheDay: Codable {
    let qotdDate: String?
    let quote: Quote?

    enum CodingKeys: String, CodingKey {
        case qotdDate = "qotd_date"
        case quote
    }
}

// MARK: - Quote
struct Quote: Codable {
    let id: Int?
    let dialogue, quotePrivate: Bool?
    let tags: [String]?
    let url: String?
    let favoritesCount, upvotesCount, downvotesCount: Int?
    let author, authorPermalink, body: String?

    enum CodingKeys: String, CodingKey {
        case id, dialogue
        case quotePrivate = "private"
        case tags, url
        case favoritesCount = "favorites_count"
        case upvotesCount = "upvotes_count"
        case downvotesCount = "downvotes_count"
        case author
        case authorPermalink = "author_permalink"
        case body
    }
}
