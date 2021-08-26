import Foundation
import MapKit

protocol WeatherViewProtocol: AnyObject {
    func failure(error: Error)
}

protocol WeatherPresenterProtocol: AnyObject {
    var weather: Weather? { get set }
    var forecastDays: [Forecast?] { get set }
    init(view: WeatherViewProtocol, networkService: WeatherNetworkServiceProtocol)
    func fetchWeather(by location: CLLocationCoordinate2D, units: String)
    func fetchForecast(by location: CLLocationCoordinate2D, units: String)
}

class WeatherPresenter: WeatherPresenterProtocol {
    var weather: Weather?
    var forecastDays = [Forecast?]()
    weak var view: WeatherViewProtocol?
    let networkService: WeatherNetworkServiceProtocol

    required init(view: WeatherViewProtocol, networkService: WeatherNetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }
}

// MARK: fetchWeather
extension WeatherPresenter {
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

    private func parseWeather(_ weatherApi: WeatherApiModel) {
        if let coord = weatherApi.coord, let longitude = coord.lon, let latitude = coord.lat,
           let weatherList = weatherApi.weather, let weatherId = weatherList.first?.id,
           let main = weatherApi.main, let tempareture = main.temp, let feelsLikeTemperature = main.feelsLike,
           let humidity = main.humidity, let pressure = main.pressure,
           let wind = weatherApi.wind, let windSpeed = wind.speed, let windDeg = wind.deg,
           let cloudsBlock = weatherApi.clouds, let cloudsAll = cloudsBlock.all {
            self.weather = Weather(
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

// MARK: fetchForecast
extension WeatherPresenter {
    func fetchForecast(by location: CLLocationCoordinate2D, units: String) {
        networkService.fetchForecast(
            latitude: location.latitude, longtitude: location.longitude, units: units) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let forecast):
                    self.parseForecast(forecast)
                case .failure(let error):
                    self.view?.failure(error: error)
            }
        }
    }

    private func parseForecast(_ forecastApiModel: ForecastApiModel) {
        forecastDays = []
        if let days = forecastApiModel.daily {
            for day in days {
                forecastDays.append(Forecast(unixtime: day.dt, temperature: day.temp?.day))

            }
        }
    }
}
