struct Model {
    var imageLink: String
    var breed: String

    init(imageLink: String) {
        self.imageLink = imageLink  // e.g. https://images.dog.ceo/breeds/bulldog-boston/n02096585_318.jpg
        self.breed = imageLink.split(separator: "/")[3].capitalized
    }
}
