import UIKit

class FullScreenBreedViewController: UIViewController {
    var animalImageScrollView: AnimalImageScrollView!

    var animalImage: UIImage?
    var animal: Animal?

    override func viewDidLoad() {
        super.viewDidLoad()
        animalImageScrollView = AnimalImageScrollView(frame: view.bounds)
        view.addSubview(animalImageScrollView)
        setupScrollView()
        getImage(by: animal!.imageLink)
        animalImageScrollView.set(image: animalImage!)
    }

    private func setupScrollView() {
        animalImageScrollView.translatesAutoresizingMaskIntoConstraints = false
        animalImageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        animalImageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        animalImageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        animalImageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}

// MARK: UIScrollViewDelegate
extension FullScreenBreedViewController: UIScrollViewDelegate {
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.zoomScale = 1.0
    }
}

extension FullScreenBreedViewController {
    private func getImage(by imageLink: String) {
        if let url = URL(string: imageLink) {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    animalImage = image
                }
            }
        }
    }
}
