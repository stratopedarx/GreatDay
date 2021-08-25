import UIKit
import Foundation

enum SegmentIndex: Int {
    case metric = 0
    case imperial = 1
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var unitSegment: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialSegmentIndex()
    }

    private func setInitialSegmentIndex() {
        if let unit = UserDefaults.standard.string(forKey: "temperutureUnit") {
            if unit == "°C" {
                unitSegment.selectedSegmentIndex = SegmentIndex.metric.rawValue
            } else {
                unitSegment.selectedSegmentIndex = SegmentIndex.imperial.rawValue
            }
        } else {
            return unitSegment.selectedSegmentIndex = SegmentIndex.metric.rawValue
        }
    }

    @IBAction func unitChanged(_ sender: UISegmentedControl) {
        if let unit = sender.titleForSegment(at: sender.selectedSegmentIndex) {
            UserDefaults.standard.set(unit, forKey: "temperutureUnit")
        }
    }
}
