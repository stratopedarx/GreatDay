import UIKit
import MapKit

let latitudeNN = 56.327395
let longitudeNN = 44.003519
let defaultUnits = (unit: "°C", urlUnits: "metric")

protocol HandleMapSearch: AnyObject {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class WeatherViewController: UIViewController {
    @IBOutlet private weak var mapView: MKMapView!

    var presenter: WeatherPresenterProtocol?
    var resultSearchController: UISearchController?
    var selectedPin: MKPlacemark?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        mapView.delegate = self
        mapView.centerToLocation(latitude: latitudeNN, longitude: longitudeNN)
        initRecognizer()
        initSearchController()
    }

    private func setup() {
        let networkService = WeatherNetworkService.sharedWeather
        self.presenter = WeatherPresenter(view: self, networkService: networkService)
    }

    private func initRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAnnotationAction))
        mapView.addGestureRecognizer(gestureRecognizer)
    }

    private func initSearchController() {
        let storyboard = UIStoryboard(name: "WeatherApp", bundle: nil)
        guard let locationSearchTable = storyboard.instantiateViewController(
                identifier: "LocationSearchTable") as? LocationSearchTable else { return }
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self

        let searchBar = resultSearchController?.searchBar
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar

        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
    }

    @objc func tapAnnotationAction(gestureRecognizer: UIGestureRecognizer) {
        let location = getLocation(from: gestureRecognizer)
        let tempUnits = getTemperatureUnits()
        presenter?.fetchWeather(by: location, units: tempUnits.urlUnits)
        presenter?.fetchForecast(by: location, units: tempUnits.urlUnits)
        let temperature = presenter?.weather?.temperature
        addAnnotation(by: location, temperature: temperature, unit: tempUnits.unit)
    }

    private func getTemperatureUnits() -> (unit: String, urlUnits: String) {
        if let unit = UserDefaults.standard.string(forKey: "temperutureUnit") {
            if unit == "°C" {
                return (unit: "°C", urlUnits: "metric")
            } else {
                return (unit: "°F", urlUnits: "imperial")
            }
        } else {
            return defaultUnits
        }
    }

    private func getLocation(from gestureRecognizer: UIGestureRecognizer) -> CLLocationCoordinate2D {
        let touchLocation = gestureRecognizer.location(in: mapView)
        let location = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        return location
    }

    private func addAnnotation(by location: CLLocationCoordinate2D, temperature: Double?, unit: String) {
        let annotation = MKPointAnnotation()
        if let temperature = temperature {
            annotation.title = "\(temperature) \(unit)"
        } else {
            annotation.title = "\(temperature as Double?)"
        }
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        mapView.addAnnotation(annotation)
    }
}

// MARK: MKMapView extension
extension MKMapView {
    func centerToLocation(latitude: Double, longitude: Double, regionRadius: CLLocationDistance = 100000) {
        let location = CLLocation(latitude: latitudeNN, longitude: longitudeNN)
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

// MARK: MKMapViewDelegate
extension WeatherViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let storyboard = UIStoryboard(name: "WeatherApp", bundle: nil)
        guard let detailsWeatherVC = storyboard.instantiateViewController(
                identifier: "DetailsWeatherVC") as? DetailsWeatherViewController else { return }
        detailsWeatherVC.weather = presenter?.weather
        if let forecastDays = presenter?.forecastDays {
            detailsWeatherVC.forecastDays = forecastDays
        }
        self.navigationController?.pushViewController(detailsWeatherVC, animated: true)
    }
}

// MARK: WeatherViewProtocol
extension WeatherViewController: WeatherViewProtocol {
   func failure(error: Error) {
        print("FAIL!!!")
        print(error.localizedDescription)
    }
}

// MARK: HandleMapSearch
extension WeatherViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality, let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
