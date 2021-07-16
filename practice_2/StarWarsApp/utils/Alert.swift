import UIKit

class Alert {
    static func showAlert(title: String, message: String, on vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            vc.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        vc.present(alert, animated: true)
    }
}
