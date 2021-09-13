import UIKit

class MainViewController: UIViewController {
    @IBOutlet private weak var tabbarContainerView: UIView!
    @IBOutlet private weak var slideMenuView: UIView!

    var openFlag: Bool = false
    let duration = 0.3
    let zeroDuration = 0.0
    let multiplier: CGFloat = 0.8

    lazy var frontVC: UIViewController? = {
        let front = self.storyboard?.instantiateViewController(withIdentifier: "frontTabbar")
        return front
    }()

    lazy var rearVC: UIViewController? = {
        let rear = self.storyboard?.instantiateViewController(withIdentifier: "rearVC")
        return rear
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        displayTabbar()
        setUpNotifications()
    }

    func setUpNotifications() {
        let notificationOpenOrCloseSideMenu = Notification.Name("notificationOpenOrCloseSideMenu")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(openOrCloseSideMenu),
                                               name: notificationOpenOrCloseSideMenu,
                                               object: nil)

        let notificationCloseSideMenu = Notification.Name("notificationCloseSideMenu")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(closeSideMenu),
                                               name: notificationCloseSideMenu,
                                               object: nil)

        let notificationCloseMenuWithoutAnimation = Notification.Name("notificationCloseWithoutAnimation")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(closeWithoutAnimation),
                                               name: notificationCloseMenuWithoutAnimation,
                                               object: nil)
    }

    // MARK: UISetup
    func displayTabbar() {
        // To display Tabbar in TabbarContainerView
        if let frontVC = frontVC {
            self.addChild(frontVC)
            frontVC.didMove(toParent: self)
            frontVC.view.frame = self.tabbarContainerView.bounds
            self.tabbarContainerView.addSubview(frontVC.view)
        }
    }

    func displaySideMenu() {
        // To display RearViewController in Side Menu View
        if let rearVC = rearVC {
            self.addChild(rearVC)
            rearVC.didMove(toParent: self)
            rearVC.view.frame = self.slideMenuView.bounds
            self.slideMenuView.addSubview(rearVC.view)
        }
    }

    // MARK: Selector Methods
    @objc func openOrCloseSideMenu() {
        // Opens or Closes Side Menu On Click of Button
        if openFlag {
            // This closes Rear View
            UIView.animate(withDuration: duration, animations: {
                self.tabbarContainerView.frame = CGRect(x: 0,
                                                        y: 0,
                                                        width: self.tabbarContainerView.frame.size.width,
                                                        height: self.tabbarContainerView.frame.size.height)
            }, completion: { _ in
                self.openFlag = false
            })
        } else {
            // This opens Rear View
            UIView.animate(withDuration: zeroDuration, animations: {
                self.displaySideMenu()
            }, completion: { _ in
                UIView.animate(withDuration: self.duration, animations: {
                    self.tabbarContainerView.frame = CGRect(
                        x: self.tabbarContainerView.bounds.size.width * self.multiplier,
                        y: 0,
                        width: self.tabbarContainerView.frame.size.width,
                        height: self.tabbarContainerView.frame.size.height)
                }, completion: { _ in
                    self.openFlag = true
                })
            })
        }
    }

    @objc func closeSideMenu() {
        // To close Side Menu
        UIView.animate(withDuration: duration, animations: {
            self.tabbarContainerView.frame = CGRect(x: 0,
                                                    y: 0,
                                                    width: self.tabbarContainerView.frame.size.width,
                                                    height: self.tabbarContainerView.frame.size.height)
        }, completion: { _ in
            self.openFlag = false
        })
    }

    @objc func closeWithoutAnimation() {
        // To close Side Menu without animation
        self.tabbarContainerView.frame = CGRect(x: 0,
                                                y: 0,
                                                width: self.tabbarContainerView.frame.size.width,
                                                height: self.tabbarContainerView.frame.size.height)
        self.openFlag = false
    }
}

class HamburgerMenu {
    // Class To Implement Easy Functions To Open Or Close RearView
    // Make object of this class and call functions
    func triggerSideMenu() {
        let notificationOpenOrCloseSideMenu = Notification.Name("notificationOpenOrCloseSideMenu")
        NotificationCenter.default.post(name: notificationOpenOrCloseSideMenu, object: nil)
    }

    func closeSideMenu() {
        let notificationCloseSideMenu = Notification.Name("notificationCloseSideMenu")
        NotificationCenter.default.post(name: notificationCloseSideMenu, object: nil)
    }

    func closeSideMenuWithoutAnimation() {
        let notificationCloseMenuWithoutAnimation = Notification.Name("notificationCloseMenuWithoutAnimation")
        NotificationCenter.default.post(name: notificationCloseMenuWithoutAnimation, object: nil)
    }
}
