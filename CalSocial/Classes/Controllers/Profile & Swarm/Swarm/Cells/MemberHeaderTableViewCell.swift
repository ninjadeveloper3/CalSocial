//
//  MemberHeaderTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 20/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol MemberHeaderTableViewCellDelegate {
    func didTapExpandMemberButton()
}

class MemberHeaderTableViewCell: UITableViewCell {

    var delegate: MemberHeaderTableViewCellDelegate?
    
    @IBOutlet weak var noOfMembers: UILabel!
    
    @IBOutlet weak var expandHideButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func instanceFromNib() -> MemberHeaderTableViewCell {
        return UINib(nibName: "MemberHeaderTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MemberHeaderTableViewCell
    }
    
    @IBAction func memberExpandButtonTapped(_ sender: Any) {
        delegate?.didTapExpandMemberButton()
    }
    
    func expandHide(isHide: Bool) {
        if !isHide {
            expandHideButton.setImage(#imageLiteral(resourceName: "up arrow"), for: .normal)
            
        } else {
            expandHideButton.setImage(#imageLiteral(resourceName: "Down arrow"), for: .normal)
        }
    }
}
