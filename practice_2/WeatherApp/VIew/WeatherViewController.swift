import UIKit
import MapKit

let latitudeNN = 56.327395
let longitudeNN = 44.003519

class WeatherViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!
    var presenter: WeatherPresenterProtocol?
    var units = "metric"

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        mapView.delegate = self

        initLocation()
        initRecognizer()
    }

    private func setup() {
        let networkService = WeatherNetworkService.sharedWeather
        self.presenter = WeatherPresenter(view: self, networkService: networkService)
    }

    private func initLocation() {
        let initialLocation = CLLocation(latitude: latitudeNN, longitude: longitudeNN)
        mapView.centerToLocation(initialLocation)
    }

    private func initRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAnnotationAction))
        mapView.addGestureRecognizer(gestureRecognizer)
    }

    @objc func tapAnnotationAction(gestureRecognizer: UIGestureRecognizer) {
        let location = getLocation(from: gestureRecognizer)
        self.presenter?.getTemperature(by: location, units: units)
        addAnnotation(by: location, temperature: presenter?.temperature ?? "")
    }

    private func getLocation(from gestureRecognizer: UIGestureRecognizer) -> CLLocationCoordinate2D {
        let touchLocation = gestureRecognizer.location(in: mapView)
        let location = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        return location
    }

    private func addAnnotation(by location: CLLocationCoordinate2D, temperature: String) {
        let annotation = MKPointAnnotation()
        if temperature != "" {
            annotation.title = temperature + " °C"
        } else {
            annotation.title = temperature
        }
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        mapView.addAnnotation(annotation)
    }
}

// MARK: MKMapView extension
private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 100000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

// MARK: MKMapViewDelegate
extension WeatherViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
//        annotationView.image = UIImage(systemName: "cloud.sun")
//
//        annotationView.canShowCallout = true
//        return annotationView
//    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        print("22222222222")
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("did select")
        let detailsWeatherVC = DetailsWeatherViewController()
        self.navigationController?.pushViewController(detailsWeatherVC, animated: true)
    }
}

extension WeatherViewController: WeatherViewProtocol {
   func failure(error: Error) {
        print("FAIL!!!")
        print(error.localizedDescription)
    }
}
