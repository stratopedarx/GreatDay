class Animal {
    var breed: String
    var breedId: String?  // used only for cat
    var imageLink: String
    var isUsed: Bool = false

    init(breed: String, breedId: String?, imageLink: String) {
        self.breed = breed.replacingOccurrences(of: "/", with: " ")
        self.breedId = breedId

        // dog api: https://images.dog.ceo/breeds/bulldog-boston/n02096585_318.jpg
        // cat api: https://cdn2.thecatapi.com/images/KWdLHmOqc.jpg
        self.imageLink = imageLink
    }
}
