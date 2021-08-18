import UIKit
import MapKit

let latitudeNN = 56.327395
let longitudeNN = 44.003519

class WeatherViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let initialLocation = CLLocation(latitude: latitudeNN, longitude: longitudeNN)
        mapView.centerToLocation(initialLocation)
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
