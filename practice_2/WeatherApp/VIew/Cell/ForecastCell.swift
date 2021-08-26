import UIKit

class ForecastCell: UITableViewCell {
    static let identifier = "forecastCell"

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!

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
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixtime))
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yy EEEE"
        let dayOfWeek = formatter.string(from: date as Date)
        return dayOfWeek
    }
}
