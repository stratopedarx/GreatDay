//
//  ViewController.swift
//  practice_2
//
//  Created by user199993 on 6/27/21.
//

import UIKit

class ViewController: UIViewController {
    var models = [Model]()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        ApiManager.shared.getRandom { images in
//        }
        models.append(Model(breeed: "bulldog-boston"))
        models.append(Model(breeed: "kelpie"))
        models.append(Model(breeed: "akita"))
        models.append(Model(breeed: "mountain-swiss"))
        models.append(Model(breeed: "ridgeback-rhodesian"))
        models.append(Model(breeed: "setter-irish"))
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
            cell.models = [models[3], models[4], models[5]]
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
    //let imageLink: UIImageView
    let breeed: String
}


//// https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
//extension UIImageView {
//    func load(url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}
