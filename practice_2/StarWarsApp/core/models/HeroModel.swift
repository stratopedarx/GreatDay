import Foundation

struct HeroModel {
    let name, height, mass, hairColor: String?
    let skinColor, eyeColor, birthYear, gender: String?

    init(_ hero: SWResult) {
        self.name = hero.name ?? ""
        self.height = hero.height ?? ""
        self.mass = hero.mass ?? ""
        self.hairColor = hero.hairColor ?? ""
        self.skinColor = hero.skinColor ?? ""
        self.eyeColor = hero.eyeColor ?? ""
        self.birthYear = hero.birthYear ?? ""
        self.gender = hero.gender ?? ""
    }
}
