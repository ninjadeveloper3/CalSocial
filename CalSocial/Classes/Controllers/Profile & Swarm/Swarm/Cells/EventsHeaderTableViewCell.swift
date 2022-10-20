//
//  EventsHeaderTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 20/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol EventsHeaderTableViewCellDelegate {
    func didTapExpandButton()
}

class EventsHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventLabel: UILabel!
    
    @IBOutlet weak var expandHideButton: UIButton!
    
    var delegate: EventsHeaderTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func instanceFromNib() -> EventsHeaderTableViewCell {
        return UINib(nibName: "EventsHeaderTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventsHeaderTableViewCell
    }
    
    func expandHide(isHide: Bool) {
        if !isHide {
            expandHideButton.setImage(#imageLiteral(resourceName: "up arrow"), for: .normal)
            
        } else {
            expandHideButton.setImage(#imageLiteral(resourceName: "Down arrow"), for: .normal)
        }
    }
    
    @IBAction func eventExpandButtonTapped(_ sender: Any) {
        delegate?.didTapExpandButton()
    }
    
}
