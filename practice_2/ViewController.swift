//
//  ViewController.swift
//  practice_2
//
//  Created by user199993 on 6/27/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        ApiManager.shared.getRandom { images in
//        }
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
            cell.topLabel.text = "Lalala"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell2.identifier, for: indexPath) as! CustomTableViewCell2
            cell.leftLabel.text = "Left"
            cell.rightLabel.text = "Right"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell3.identifier, for: indexPath) as! CustomTableViewCell3
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

