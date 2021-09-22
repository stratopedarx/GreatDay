import UIKit
import WebKit

class VideoViewController: UIViewController {
    @IBOutlet weak var videoWebView: WKWebView!
    var video: Video?

    override func viewDidLoad() {
        super.viewDidLoad()
        getVideo()
    }

    @IBAction func shareAction(_ sender: UIButton) {
        if let video = video {
            let shareController = UIActivityViewController(
                activityItems: [video.urlToVideo], applicationActivities: nil)
            shareController.completionWithItemsHandler = { _, bool, _, _ in
                if bool {
                    print("Successfully sent")
                }
            }
            present(shareController, animated: true, completion: nil)
        }
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
