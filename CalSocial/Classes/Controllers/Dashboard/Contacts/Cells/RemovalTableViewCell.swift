//
//  RemovalTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 02/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol RemovalTableViewCellDelegate {
    func didTapFavoritesButton(cell: RemovalTableViewCell)
    func didTapDeleteButton(cell: RemovalTableViewCell)
}

class RemovalTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var favIconImageView: UIImageView!
    
    @IBOutlet weak var emptyImageView: HMView!
    
    @IBOutlet weak var emptyImageLabelText: UILabel!
    
    @IBOutlet weak var displayPicture: BUIImageView!
    
    @IBOutlet weak var leaveLabel: UILabel!
    
    @IBOutlet weak var deleteButton: MBButton!
    
    var delegate : RemovalTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        displayPicture.contentMode = .scaleAspectFill
    }    
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> RemovalTableViewCell {
        let kRemovalTableViewCell = "kRemovalTableViewCell"
        tableView.register(UINib(nibName: "RemovalTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kRemovalTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kRemovalTableViewCell, for: indexPath) as! RemovalTableViewCell
        return cell
    }
    @IBAction func leaveButtonTapped(_ sender: Any) {
        delegate?.didTapDeleteButton(cell: self)
    }
    
    @IBAction func favourButtonTapped(_ sender: Any) {
        delegate?.didTapFavoritesButton(cell: self)
    }
}
