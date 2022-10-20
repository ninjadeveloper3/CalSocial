//
//  HeaderTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 02/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> HeaderTableViewCell {
        let kHeaderTableViewCell = "kHeaderTableViewCell"
        tableView.register(UINib(nibName: "HeaderTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kHeaderTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kHeaderTableViewCell, for: indexPath) as! HeaderTableViewCell
        return cell
    }
}
