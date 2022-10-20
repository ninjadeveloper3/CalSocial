//
//  LeftSideTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 17/01/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import UIKit
import TwilioChatClient
import TwilioAccessManager

class LeftSideTableViewCell: UITableViewCell {

    @IBOutlet weak var textMessageLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> LeftSideTableViewCell {
        let kLeftSideTableViewCell = "kLeftSideTableViewCell"
        tableView.register(UINib(nibName: "LeftSideTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kLeftSideTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kLeftSideTableViewCell, for: indexPath) as! LeftSideTableViewCell
        return cell
    }
    
    func initData(message: TCHMessage)  {
        textMessageLabel.text = message.body
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "EE, dd MMM, hh:mma"
        let time = timeFormatter.string(from: message.dateUpdatedAsDate ?? Date())
        timeLabel.text = time
    }
}
