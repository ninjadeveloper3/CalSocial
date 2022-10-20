//
//  EventProfileTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 12/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class EventProfileTableViewCell: UITableViewCell {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> EventProfileTableViewCell {
        let kEventTableViewCell = "kEventTableViewCell"
        tableView.register(UINib(nibName: "EventProfileTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kEventTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kEventTableViewCell, for: indexPath) as! EventProfileTableViewCell
        return cell
    }
}
