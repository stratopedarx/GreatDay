import UIKit
import WebKit

class VideoViewController: UIViewController {
    @IBOutlet weak var videoWebView: WKWebView!
    var video: Video?

    override func viewDidLoad() {
        super.viewDidLoad()
        getVideo()
    }
}

private extension VideoViewController {
    func getVideo() {
        if let video = video {
            if let url = URL(string: video.urlToVideo) {
                let request = URLRequest(url: url)
                videoWebView.load(request)
            }
        }
    }
}
