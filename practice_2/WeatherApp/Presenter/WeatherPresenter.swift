import Foundation
import MapKit

protocol WeatherViewProtocol: AnyObject {
    func failure(error: Error)
}

protocol WeatherPresenterProtocol: AnyObject {
    var weatherInfo: WeatherInfo? { get set }
    init(view: WeatherViewProtocol, networkService: WeatherNetworkServiceProtocol)
    func fetchWeather(by location: CLLocationCoordinate2D, units: String)
}

class WeatherPresenter: WeatherPresenterProtocol {
    var weatherInfo: WeatherInfo?
    weak var view: WeatherViewProtocol?
    let networkService: WeatherNetworkServiceProtocol

    required init(view: WeatherViewProtocol, networkService: WeatherNetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }

    func fetchWeather(by location: CLLocationCoordinate2D, units: String) {
        let group = DispatchGroup()
        group.enter()
        networkService.fetchWeather(
            latitude: location.latitude, longtitude: location.longitude, units: units) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let weather):
                    self.parseWeather(weather)
                case .failure(let error):
                    self.view?.failure(error: error)
            }
            group.leave()
        }
        group.wait()
    }

    private func parseWeather(_ weather: Weather) {
        if let coord = weather.coord, let longitude = coord.lon, let latitude = coord.lat,
           let weatherList = weather.weather, let weatherId = weatherList.first?.id,
           let main = weather.main, let tempareture = main.temp, let feelsLikeTemperature = main.feelsLike,
           let humidity = main.humidity, let pressure = main.pressure,
           let wind = weather.wind, let windSpeed = wind.speed, let windDeg = wind.deg,
           let cloudsBlock = weather.clouds, let cloudsAll = cloudsBlock.all {
            self.weatherInfo = WeatherInfo(
                weatherId: weatherId,
                temperature: tempareture,
                feelsLikeTemperature: feelsLikeTemperature,
                humidity: humidity,
                pressure: pressure,
                latitude: latitude,
                longitude: longitude,
                windSpeed: windSpeed,
                windDeg: windDeg,
                cloudsAll: cloudsAll
            )
        }
    }
}
