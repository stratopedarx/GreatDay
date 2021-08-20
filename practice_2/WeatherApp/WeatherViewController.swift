import UIKit
import MapKit

let latitudeNN = 56.327395
let longitudeNN = 44.003519

class WeatherViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        initLocation()
        initRecognizer()
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
        print(location)
        // fetch http request
        addAnnotation(by: location)
    }

    private func getLocation(from gestureRecognizer: UIGestureRecognizer) -> CLLocationCoordinate2D {
        let touchLocation = gestureRecognizer.location(in: mapView)
        let location = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        return location
    }

    private func addAnnotation(by location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.title = "weather"
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
    }
}
