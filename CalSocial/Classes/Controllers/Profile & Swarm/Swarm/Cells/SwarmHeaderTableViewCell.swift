//
//  SwarmHeaderTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 20/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol SwarmHeaderTableViewCellDelegate {
    func didTapCreateEvent()
    func didTapMessage()
}

class SwarmHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var swarmTitleLabel: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var aboutUsLabel: UILabel!
    
    @IBOutlet weak var createEventImageView: UIImageView!
    
    @IBOutlet weak var messageImageView: UIImageView!
    
    @IBOutlet weak var favStar: UIImageView!
    
    
    var delegate : SwarmHeaderTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(createEventGestureTapped(sender:)))
        createEventImageView.addGestureRecognizer(tapGesture)
        
        
        let messageTapGesture = UITapGestureRecognizer(target: self, action: #selector(messageIconGestureTapped(sender:)))
        messageImageView.addGestureRecognizer(messageTapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func createEventGestureTapped(sender: UITapGestureRecognizer){
        delegate?.didTapCreateEvent()
    }
    
    @objc func messageIconGestureTapped(sender: UITapGestureRecognizer){
        delegate?.didTapMessage()
    }
    
    class func instanceFromNib() -> SwarmHeaderTableViewCell {
        return UINib(nibName: "SwarmHeaderTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SwarmHeaderTableViewCell
    }
}
