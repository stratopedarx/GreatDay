import UIKit

let secondsInMinute = 60
let defaultTimeSliderValue = 600 // 10 minutes
let defaultLeftButtonValue = 300 // 5 minutes
let defaultMiddleButtonValue = 600 // 10 minutes
let defaultRightButtonValue = 900 // 15 minutes

enum Mode: String {
    case start = "START"
    case stop = "STOP"
}

class MeditationViewController: UIViewController {
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var timeSlider: UISlider!

    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var middleButton: UIButton!
    @IBOutlet private weak var rightButton: UIButton!

    var timer = Timer()
    var meditationTime: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setInitValues()
    }

    @IBAction func timeSliderChanged(_ sender: UISlider) {
        updateScreen(to: Int(sender.value))
    }

    @IBAction func leftButtonTapped(_ sender: UIButton) {
        updateScreen(to: defaultLeftButtonValue)
    }

    @IBAction func middleButtonTapped(_ sender: UIButton) {
        updateScreen(to: defaultMiddleButtonValue)
    }

    @IBAction func rigthButtonTapped(_ sender: UIButton) {
        updateScreen(to: defaultRightButtonValue)
    }

    @IBAction func startButtonTapped(_ sender: UIButton) {
        let currentMode = sender.titleLabel?.text

        if currentMode == Mode.start.rawValue {
            startTimer(sender: sender)
        } else {
            stopTimer(sender: sender)
        }
    }

    private func setInitValues() {
        timeSlider.value = Float(defaultTimeSliderValue)
        updateScreen(to: defaultTimeSliderValue)
    }

    private func updateScreen(to seconds: Int) {
        timeSlider.value = Float(seconds)
        timeLabel.text = "\(seconds / secondsInMinute):00"
    }

    private func startTimer(sender: UIButton) {
        meditationTime = Int(timeSlider.value) - Int(timeSlider.value) % secondsInMinute
        sender.setTitle(Mode.stop.rawValue, for: .normal)

        timeSlider.isHidden = true
        leftButton.isHidden = true
        middleButton.isHidden = true
        rightButton.isHidden = true

        timer = Timer.scheduledTimer(
            timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }

    @objc func timerAction() {
        meditationTime -= 1
        let minutes = String(format: "%02d", meditationTime / secondsInMinute)
        let restOfSeconds = String(format: "%02d", meditationTime % secondsInMinute)
        timeLabel.text = "\(minutes):\(restOfSeconds)"
    }

    private func stopTimer(sender: UIButton) {
        timer.invalidate()
        meditationTime = 0
        sender.setTitle(Mode.start.rawValue, for: .normal)

        timeSlider.isHidden = false
        leftButton.isHidden = false
        middleButton.isHidden = false
        rightButton.isHidden = false

        setInitValues()
    }
}
