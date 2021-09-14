import UIKit

class ForecastCell: UITableViewCell {
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!

    static let identifier = "forecastCell"
    static let formatter = DateFormatter()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(by forecast: Forecast, unit: String) {
        if let unixtime = forecast.unixtime, let temperature = forecast.temperature {
            dateLabel.text = convertUnixtimeToDate(unixtime: unixtime)
            temperatureLabel.text = "\(String(temperature)) \(unit)"
        }
    }

    private func convertUnixtimeToDate (unixtime: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixtime))
        ForecastCell.formatter.dateFormat = "MM-dd-yy EEEE"
        let dayOfWeek = ForecastCell.formatter.string(from: date)
        return dayOfWeek
    }
}
