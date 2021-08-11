import UIKit

class AnimalImageScrollView: UIScrollView {
    var animalImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = UIScrollView.DecelerationRate.fast
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(image: UIImage) {
        animalImageView?.removeFromSuperview()
        animalImageView = nil
        animalImageView = UIImageView(image: image)
        self.addSubview(animalImageView)
        configurateFor(imageSize: image.size)
    }

    func configurateFor(imageSize: CGSize) {
        self.contentSize = imageSize
        self.setCurrentMaxAndMinZoomScale()
        self.zoomScale = self.minimumZoomScale
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.centerImage()
    }

    func setCurrentMaxAndMinZoomScale() {
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 5.0
    }

    func centerImage() {
        let boundsSize = self.bounds.size
        var frameToCenter = animalImageView.frame

        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }

        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }

        animalImageView.frame = frameToCenter
    }
}

// MARK: UIScrollViewDelegate
extension AnimalImageScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return animalImageView
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.zoomScale = 1.0
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerImage()
    }
}
