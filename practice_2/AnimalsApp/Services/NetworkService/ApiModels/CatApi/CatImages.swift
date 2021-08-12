// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let catImage = try? newJSONDecoder().decode(CatImage.self, from: jsonData)

import Foundation

// MARK: - CatImageElement
struct CatImageElement: Codable {
    let breeds: [Breed]?
    let height: Int?
    let id: String?
    let url: String?
    let width: Int?
}

// MARK: - Breed
struct Breed: Codable {
    let adaptability, affectionLevel: Int?
    let altNames: String?
    let cfaURL: String?
    let childFriendly: Int?
    let countryCode, countryCodes, breedDescription: String?
    let dogFriendly, energyLevel, experimental, grooming: Int?
    let hairless, healthIssues, hypoallergenic: Int?
    let id: String?
    let indoor, intelligence, lap: Int?
    let lifeSpan, name: String?
    let natural: Int?
    let origin: String?
    let rare: Int?
    let referenceImageID: String?
    let rex, sheddingLevel, shortLegs, socialNeeds: Int?
    let strangerFriendly, suppressedTail: Int?
    let temperament: String?
    let vcahospitalsURL: String?
    let vetstreetURL: String?
    let vocalisation: Int?
    let weight: Weight?
    let wikipediaURL: String?

    enum CodingKeys: String, CodingKey {
        case adaptability
        case affectionLevel = "affection_level"
        case altNames = "alt_names"
        case cfaURL = "cfa_url"
        case childFriendly = "child_friendly"
        case countryCode = "country_code"
        case countryCodes = "country_codes"
        case breedDescription = "description"
        case dogFriendly = "dog_friendly"
        case energyLevel = "energy_level"
        case experimental, grooming, hairless
        case healthIssues = "health_issues"
        case hypoallergenic, id, indoor, intelligence, lap
        case lifeSpan = "life_span"
        case name, natural, origin, rare
        case referenceImageID = "reference_image_id"
        case rex
        case sheddingLevel = "shedding_level"
        case shortLegs = "short_legs"
        case socialNeeds = "social_needs"
        case strangerFriendly = "stranger_friendly"
        case suppressedTail = "suppressed_tail"
        case temperament
        case vcahospitalsURL = "vcahospitals_url"
        case vetstreetURL = "vetstreet_url"
        case vocalisation, weight
        case wikipediaURL = "wikipedia_url"
    }
}

typealias CatImages = [CatImageElement]
