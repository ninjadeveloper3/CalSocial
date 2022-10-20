//
//  DummyTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 12/11/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class DummyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> DummyTableViewCell {
        let kDummyTableViewCell = "kDummyTableViewCell"
        tableView.register(UINib(nibName: "DummyTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kDummyTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kDummyTableViewCell, for: indexPath) as! DummyTableViewCell
        return cell
    }
}
