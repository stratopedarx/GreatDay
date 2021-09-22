import Foundation

struct Video {
    var youtubeKey: String
    var title: String
    var isFavourite: Bool = false
    var urlToImage: String {
        return "https://i.ytimg.com/vi/\(youtubeKey)/hqdefault.jpg"
    }
    var urlToVideo: String {
        return "https://www.youtube.com/watch?v=\(youtubeKey)"
    }
}
