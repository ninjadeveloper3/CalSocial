//
//  EditSwarmTableViewCell.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 03/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol EditSwarmTableViewCellDelegate {
    func didDeleteButtonTapped(cell: EditSwarmTableViewCell)
}

class EditSwarmTableViewCell: UITableViewCell {
    
    var delegate : EditSwarmTableViewCellDelegate?
    
    @IBOutlet weak var deleteIconButton: MBButton!
    
    @IBOutlet weak var contactNameLabel: UILabel!
    
    @IBOutlet weak var emptyView: HMView!
    
    @IBOutlet weak var emptyViewLabel: UILabel!
    
    @IBOutlet weak var profilePicView: BUIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> EditSwarmTableViewCell {
        let kEditSwarmTableViewCell = "kEditSwarmTableViewCell"
        tableView.register(UINib(nibName: "EditSwarmTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kEditSwarmTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kEditSwarmTableViewCell, for: indexPath) as! EditSwarmTableViewCell
        return cell
    }
    
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.didDeleteButtonTapped(cell: self)
    }
}
