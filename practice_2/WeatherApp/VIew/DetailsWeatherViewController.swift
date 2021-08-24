import UIKit

class DetailsWeatherViewController: UIViewController {
    var weatherInfo: WeatherInfo?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var windSpeedLabel: UILabel!
    @IBOutlet private weak var windDegLabel: UILabel!
    @IBOutlet private weak var cloudsAllLabel: UILabel!
    @IBOutlet private weak var weatherImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    private func setUp() {
        let unit = getUnit()
        if let info = self.weatherInfo {
            temperatureLabel.text = "Temperature: \(info.temperature) \(unit)"
            feelsLikeTemperatureLabel.text = "Feels like: \(info.feelsLikeTemperature) \(unit)"
            humidityLabel.text = "Humidity: \(info.humidity)%"
            pressureLabel.text = "Pressure: \(info.pressure) in"
            windSpeedLabel.text = "Wind speed: \(info.windSpeed) m/s"
            windDegLabel.text = "Wind deg: \(info.windDeg)°"
            cloudsAllLabel.text = "Cloudness: \(info.cloudsAll)%"
            weatherImage.image = UIImage(systemName: info.weatherImage)
        }
    }

    private func getUnit() -> String {
        if let unit = UserDefaults.standard.string(forKey: "temperutureUnit") {
            return unit
        }
        return defaultUnits.unit
    }
}
