import UIKit

class ExercisesCell: UITableViewCell {
    @IBOutlet private weak var imageVideo: UIImageView!
    @IBOutlet private weak var videoTitleLabel: UILabel!

    static let identifier = "exercisesCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(by video: Video) {
        videoTitleLabel.text = video.title
        if let url = URL(string: video.urlToImage) {
            imageVideo.load(url: url)
        } else {
            print("Could not create URL object for \(video.urlToImage)")
        }
    }
}
