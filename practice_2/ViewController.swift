import UIKit

class ViewController: UIViewController {
    var models = [Model]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        ApiManager.shared.getRandom { images in
            print(images)
            for link in images.message! {
                self.models.append(Model(imageLink: link))
            }
        }
        
        if models.count != 6 {
            createTestModels()
        }
    }
    
    private func createTestModels() {
        self.models = [Model]()
        models.append(Model(imageLink: "https://images.dog.ceo/breeds/bulldog-boston/n02096585_318.jpg"))
        models.append(Model(imageLink: "https://images.dog.ceo/breeds/briard/n02105251_7430.jpg"))
        models.append(Model(imageLink: "https://images.dog.ceo/breeds/akita/512px-Ainu-Dog.jpg"))
        models.append(Model(imageLink: "https://images.dog.ceo/breeds/mountain-swiss/n02107574_497.jpg"))
        models.append(Model(imageLink: "https://images.dog.ceo/breeds/ridgeback-rhodesian/n02087394_7777.jpg"))
        models.append(Model(imageLink: "https://images.dog.ceo/breeds/setter-irish/n02100877_585.jpg"))
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell1.identifier, for: indexPath) as! CustomTableViewCell1
            cell.configure(with: models[0])
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell2.identifier, for: indexPath) as! CustomTableViewCell2
            cell.configure(leftModel: models[1], rightModel: models[2])
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell3.identifier, for: indexPath) as! CustomTableViewCell3
            cell.collectionModels = [models[3], models[4], models[5]]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:  return 120
        case 1: return 285
        default: return 400
        }
    }
}


struct Model {
    var imageLink: String
    var breed: String

    init(imageLink: String) {
        self.imageLink = imageLink  //e.g. https://images.dog.ceo/breeds/bulldog-boston/n02096585_318.jpg
        self.breed = imageLink.split(separator: "/")[3].capitalized
    }
}


// https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

