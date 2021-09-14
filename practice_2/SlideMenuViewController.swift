import UIKit

class SlideMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("SlideMenu")
    }

    @IBAction func openNewsAppButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "newsSegue", sender: self)
        HamburgerMenu().closeSideMenu()
    }

    @IBAction func openStarWarsAppButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "starWarsSegue", sender: self)
        HamburgerMenu().closeSideMenu()
    }

    @IBAction func openDogsAppButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "dogsSegue", sender: self)
        HamburgerMenu().closeSideMenu()
    }

    @IBAction func openAnimalsAppButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "animalsSegue", sender: self)
        HamburgerMenu().closeSideMenu()
    }

    @IBAction func openWeatherAppButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "weatherSegue", sender: self)
        HamburgerMenu().closeSideMenu()
    }

    @IBAction func openGreatDayAppButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "greatDaySegue", sender: self)
        HamburgerMenu().closeSideMenu()
    }
}
