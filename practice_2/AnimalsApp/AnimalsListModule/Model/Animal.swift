struct Animal {
    var breed: String
    var imageLink: String

    init(_ breed: String, _ imageLink: String) {
        self.breed = breed.replacingOccurrences(of: "/", with: " ")
        self.imageLink = imageLink  // e.g. https://images.dog.ceo/breeds/bulldog-boston/n02096585_318.jpg
    }
}
