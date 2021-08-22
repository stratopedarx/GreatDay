import Foundation

struct WeatherInfo {
    let weatherId: Int
    let temperature: Double
    let feelsLikeTemperature: Double
    let humidity: Int
    let pressure: Int
    let latitude: Double
    let longitude: Double
    let windSpeed: Double
    let windDeg: Int
    let cloudsAll: Int

    var weatherImage: String {
        switch weatherId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "cloud.sun"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
