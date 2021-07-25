struct Animal {
    var imageLink: String
    var breed: String

    init(imageLink: String) {
        //var baseLink = "https://dog.ceo/api/breed/hound/afghan/images"
        self.imageLink = imageLink  // e.g. https://images.dog.ceo/breeds/bulldog-boston/n02096585_318.jpg
        //self.breed = imageLink.split(separator: "/")[3].capitalized
        self.breed = "breed breed"
    }
}
