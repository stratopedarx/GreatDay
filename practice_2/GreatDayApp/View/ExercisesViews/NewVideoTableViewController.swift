import UIKit

class NewVideoTableTableViewController: UITableViewController {
    @IBOutlet private weak var videoTitleTextField: UITextField!
    @IBOutlet private weak var youtubeLinkTextField: UITextField!
    @IBOutlet private weak var saveButton: UIBarButtonItem!

    var video: Video?
    let regex = "^https:\\/\\/www\\.youtube\\.com\\/watch\\?v=[\\d\\w\\s\\S]{5,15}$"

    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
    }

    @IBAction func textChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveSegue" else { return }
    }
}

// MARK: private methods
private extension NewVideoTableTableViewController {
    func updateSaveButtonState() {
        if let videoTitle = videoTitleTextField.text,
           let youtubeLink = youtubeLinkTextField.text {
            if !videoTitle.isEmpty && !youtubeLink.isEmpty && youtubeLink.matches(regex) {
                video = Video(youtubeKey: getYoutubeKey(from: youtubeLink), title: videoTitle)
                saveButton.isEnabled = true
            }
        }
    }

    func getYoutubeKey(from link: String) -> String {
        return link.components(separatedBy: "?v=")[1]
    }
}
