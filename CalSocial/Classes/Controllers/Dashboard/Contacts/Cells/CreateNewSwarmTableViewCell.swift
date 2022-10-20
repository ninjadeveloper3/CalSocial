//
//  CreateNewCreateNewSwarmTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 05/11/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol CreateNewSwarmTableViewCellDelegate {
    func didTapCreateSwarm()
}

class CreateNewSwarmTableViewCell: UITableViewCell {
    
    var delegate: CreateNewSwarmTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> CreateNewSwarmTableViewCell {
        let kCreateNewSwarmTableViewCell = "kCreateNewSwarmTableViewCell"
        tableView.register(UINib(nibName: "CreateNewSwarmTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kCreateNewSwarmTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kCreateNewSwarmTableViewCell, for: indexPath) as! CreateNewSwarmTableViewCell
        return cell
    }
    @IBAction func createSwarmButtonTapped(_ sender: Any) {
        delegate?.didTapCreateSwarm()
    }
}
