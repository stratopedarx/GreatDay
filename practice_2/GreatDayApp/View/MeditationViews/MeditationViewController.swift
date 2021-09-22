import UIKit
import AVFoundation

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
    @IBOutlet private weak var startStopButton: UIButton!

    var timer = Timer()
    var meditationTime: Int = 0
    var audioPlayer: AVAudioPlayer?

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
            startTimer()
        } else {
            stopTimer()
        }
    }

    @objc func timerAction() {
        meditationTime -= 1
        let minutes = String(format: "%02d", meditationTime / secondsInMinute)
        let restOfSeconds = String(format: "%02d", meditationTime % secondsInMinute)
        timeLabel.text = "\(minutes):\(restOfSeconds)"

        if meditationTime == 0 {
            playSound(name: "alarm")
            DispatchQueue.main.async {
                Alert.showAlert(title: "Great", message: "Meditation completed", on: self)
            }
            stopTimer()
        }
    }

}

// MARK: secondary functions
private extension MeditationViewController {
    func setInitValues() {
        timeSlider.value = Float(defaultTimeSliderValue)
        updateScreen(to: defaultTimeSliderValue)
    }

    func updateScreen(to seconds: Int) {
        timeSlider.value = Float(seconds)
        timeLabel.text = "\(seconds / secondsInMinute):00"
    }

    func startTimer() {
        meditationTime = Int(timeSlider.value) - Int(timeSlider.value) % secondsInMinute
        startStopButton.setTitle(Mode.stop.rawValue, for: .normal)
        setHiddenValue(value: true)
        timer = Timer.scheduledTimer(
            timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }

    func playSound(name: String) {
        guard let pathToSound = Bundle.main.path(forResource: "alarm", ofType: "mp3") else { return }
        let url = URL(fileURLWithPath: pathToSound)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Could not play `\(name)` sound")
        }
    }

    func stopTimer() {
        timer.invalidate()
        meditationTime = 0
        startStopButton.setTitle(Mode.start.rawValue, for: .normal)
        setHiddenValue(value: false)
        setInitValues()
    }

    func setHiddenValue(value: Bool) {
        timeSlider.isHidden = value
        leftButton.isHidden = value
        middleButton.isHidden = value
        rightButton.isHidden = value
    }
}
