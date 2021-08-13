import UIKit

let defaultMaxScale = CGFloat(1.0)
let defaultMinScale = CGFloat(0.1)
let scale03 = CGFloat(0.3)
let scale05 = CGFloat(0.5)
let scale07 = CGFloat(0.7)

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
        let boundSize = self.bounds.size
        let imageSize = animalImageView.bounds.size

        let xScale = boundSize.width / imageSize.width
        let yScale = boundSize.height / imageSize.height
        let minScale = min(xScale, yScale)

        var maxScale = defaultMaxScale
        if minScale < defaultMinScale {
            maxScale = scale03
        }
        if minScale >= defaultMinScale && minScale < scale05 {
            maxScale = scale07
        }
        if minScale >= scale05 {
            maxScale = max(defaultMaxScale, minScale)
        }

        self.minimumZoomScale = minScale
        self.maximumZoomScale = maxScale
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
        self.zoomScale = self.minimumZoomScale
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerImage()
    }
}
