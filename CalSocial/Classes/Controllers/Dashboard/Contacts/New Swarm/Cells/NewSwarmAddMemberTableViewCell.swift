//
//  NewSwarmAddMemberTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 23/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol NewSwarmAddMemberTableViewCellDelegate {
    func didTapAddMember()
}

class NewSwarmAddMemberTableViewCell: UITableViewCell {
    
    
    var delegate: NewSwarmAddMemberTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func instanceFromNib() -> NewSwarmAddMemberTableViewCell {
        return UINib(nibName: "NewSwarmAddMemberTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NewSwarmAddMemberTableViewCell
    }
    
    @IBAction func addMemberButtonTapped(_ sender: Any) {
        delegate?.didTapAddMember()
    }
    
    @IBAction func deleteSwarmButtonTapped(_ sender: Any) {
    }
    
}
