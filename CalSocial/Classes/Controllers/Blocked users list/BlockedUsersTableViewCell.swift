//
//  BlockedUsersTableViewCell.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 08/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
protocol BlockedUsersTableViewCellDelegate {
    func didSelectRow(cell: BlockedUsersTableViewCell)
}

class BlockedUsersTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    
    var delegate: BlockedUsersTableViewCellDelegate?
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var emptyImageView: HMView!
    
    @IBOutlet weak var emptyImageLabel: UILabel!
    
    @IBOutlet weak var profileImage: BUIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var unBlockButton: MBButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func unBlockTapped(_ sender: Any) {
        delegate?.didSelectRow(cell: self)
    }
    
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> BlockedUsersTableViewCell {
        let kBlockedUsersTableViewCell = "kBlockedUsersTableViewCell"
        tableView.register(UINib(nibName: "BlockedUsersTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kBlockedUsersTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kBlockedUsersTableViewCell, for: indexPath) as! BlockedUsersTableViewCell
        return cell
    }
    
}
