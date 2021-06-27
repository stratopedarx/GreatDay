//
//  CustomTableViewCell_3.swift
//  practice_2
//
//  Created by user199993 on 6/27/21.
//

import UIKit

class CustomTableViewCell_3: UITableViewCell, UITableViewDelegate {
    static let identifier = "idCell_3"

    @IBOutlet weak var horizontalTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        horizontalTableView.delegate = self
        horizontalTableView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}


extension CustomTableViewCell_3: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell_4.identifier) as! CustomTableViewCell_4
        tableView.rowHeight = 400
        return cell
    }
    
    
}


extension CustomTableViewCell_3: UITabBarDelegate {
    
}
