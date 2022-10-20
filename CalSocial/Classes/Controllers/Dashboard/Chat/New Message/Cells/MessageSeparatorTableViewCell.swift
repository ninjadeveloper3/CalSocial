//
//  MessageSeparatorTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 09/03/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import UIKit

class MessageSeparatorTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> MessageSeparatorTableViewCell {
        let kMessageSeparatorTableViewCell = "kMessageSeparatorTableViewCell"
        tableView.register(UINib(nibName: "MessageSeparatorTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kMessageSeparatorTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kMessageSeparatorTableViewCell, for: indexPath) as! MessageSeparatorTableViewCell
        return cell
    }
    
}
