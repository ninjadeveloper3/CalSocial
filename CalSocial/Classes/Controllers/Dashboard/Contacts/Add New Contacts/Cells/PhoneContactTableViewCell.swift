//
//  PhoneContactTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 02/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class PhoneContactTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> PhoneContactTableViewCell {
        let kPhoneContactTableViewCell = "kPhoneContactTableViewCell"
        tableView.register(UINib(nibName: "PhoneContactTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kPhoneContactTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kPhoneContactTableViewCell, for: indexPath) as! PhoneContactTableViewCell
        return cell
    }
}
