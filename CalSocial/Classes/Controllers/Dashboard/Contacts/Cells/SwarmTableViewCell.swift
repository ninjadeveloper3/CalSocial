//
//  SwarmTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 01/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol SwarmTableViewCellDelegate {
    func didTapCreateEvent(cell: SwarmTableViewCell)
    func didTapMessage(cell: SwarmTableViewCell)
}

class SwarmTableViewCell: UITableViewCell {
    
    @IBOutlet weak var swarmTitle: UILabel!
    
    @IBOutlet weak var membersLabel: UILabel!
    
    @IBOutlet weak var createEventImageView: UIImageView!
    
    @IBOutlet weak var messageImageView: UIImageView!
    
    @IBOutlet weak var emptyImageView: HMView!
    
    @IBOutlet weak var emptyImageLabelText: UILabel!
    
    @IBOutlet weak var profilePic: BUIImageView!
    
    @IBOutlet weak var favIcon: UIImageView!
    
    
    var delegate: SwarmTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        profilePic.contentMode = .scaleAspectFill
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(createEventGestureTapped(sender:)))
        createEventImageView.addGestureRecognizer(tapGesture)
        
        let messageTapGesture = UITapGestureRecognizer(target: self, action: #selector(messageGestureTapped(sender:)))
        messageImageView.addGestureRecognizer(messageTapGesture)
    }
    
    @objc func createEventGestureTapped(sender: UITapGestureRecognizer){
        delegate?.didTapCreateEvent(cell: self)
    }
    
    @objc func messageGestureTapped(sender: UITapGestureRecognizer){
        delegate?.didTapMessage(cell: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> SwarmTableViewCell {
        let kSwarmTableViewCell = "kSwarmTableViewCell"
        tableView.register(UINib(nibName: "SwarmTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kSwarmTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kSwarmTableViewCell, for: indexPath) as! SwarmTableViewCell
        return cell
    }
}
