import UIKit

class ViewController: UIViewController {
    var models = [Model]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        ApiManager.shared.getRandom { images in
            for link in images.message! {
                self.models.append(Model(imageLink: link))
            }
        }
        
        // we use test models if we get https errors or not corrected data
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
        models.shuffle()
    }
}

enum Section: Int {
    case top = 0
    case middle = 1
    case bottom = 2
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch getSection(indexPath.row % 3) {
        case .top:
            return createTopCell(indexPath)
        case .middle:
            return createMiddleCell(indexPath)
        case .bottom:
            return createBottomCell(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch getSection(indexPath.row % 3) {
        case .top:  return 120
        case .middle: return 285
        case .bottom: return 400
        }
    }
    
    private func getSection(_ position: Int) -> Section {
        if position == 0 { return Section.top }
        else if position == 1 { return Section.middle }
        else { return Section.bottom }
    }
    
    private func createTopCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TopTableViewCell.identifier, for: indexPath) as! TopTableViewCell
        cell.configure(with: models[0])
        return cell
    }
    
    private func createMiddleCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MiddleTableViewCell.identifier, for: indexPath) as! MiddleTableViewCell
        cell.configure(leftModel: models[1], rightModel: models[2])
        return cell
    }
    
    private func createBottomCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BottomTableViewCell.identifier, for: indexPath) as! BottomTableViewCell
        cell.collectionModels = [models[3], models[4], models[5]]
        return cell
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

