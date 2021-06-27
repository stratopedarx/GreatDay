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
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell_1.identifier, for: indexPath) as! CustomTableViewCell_1
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell_2.identifier, for: indexPath) as! CustomTableViewCell_2
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell_3.identifier, for: indexPath) as! CustomTableViewCell_3
        }
        return cell
    }
    
    
}


extension ViewController: UITableViewDelegate {
    
}
