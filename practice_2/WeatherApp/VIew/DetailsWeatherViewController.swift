import UIKit

class DetailsWeatherViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var windSpeedLabel: UILabel!
    @IBOutlet private weak var windDegLabel: UILabel!
    @IBOutlet private weak var cloudsAllLabel: UILabel!
    @IBOutlet private weak var weatherImage: UIImageView!

    var weather: Weather?
    var forecastDays = [Forecast?]()
    var unit: String = defaultUnits.unit

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        setUp()
    }

    private func setUp() {
        unit = getUnit()
        if let info = self.weather {
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

// MARK: UITableViewDataSource
extension DetailsWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecastDays.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: ForecastCell.identifier, for: indexPath) as? ForecastCell {
            if let forecast = forecastDays[indexPath.row] {
                cell.configure(by: forecast, unit: unit)
            }
            return cell
        } else {
            print("Can`t create the cell ForecastCell")
            return UITableViewCell()
        }
    }
}
