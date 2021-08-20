import Foundation
import MapKit

protocol WeatherViewProtocol: AnyObject {
    func failure(error: Error)
}

protocol WeatherPresenterProtocol: AnyObject {
    var temperature: String? { get set }
    init(view: WeatherViewProtocol, networkService: WeatherNetworkServiceProtocol)
    func getTemperature(by location: CLLocationCoordinate2D, units: String)
}

class WeatherPresenter: WeatherPresenterProtocol {
    var temperature: String?
    weak var view: WeatherViewProtocol?
    let networkService: WeatherNetworkServiceProtocol

    required init(view: WeatherViewProtocol, networkService: WeatherNetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }

    func getTemperature(by location: CLLocationCoordinate2D, units: String) {
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
        if let main = weather.main, let temperature = main.temp {
            self.temperature = String(temperature)
        }
    }
}
