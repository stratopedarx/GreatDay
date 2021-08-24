import UIKit
import Foundation

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func unitChanged(_ sender: UISegmentedControl) {
        if let unit = sender.titleForSegment(at: sender.selectedSegmentIndex) {
            UserDefaults.standard.set(unit, forKey: "temperutureUnit")
        }
    }
}
