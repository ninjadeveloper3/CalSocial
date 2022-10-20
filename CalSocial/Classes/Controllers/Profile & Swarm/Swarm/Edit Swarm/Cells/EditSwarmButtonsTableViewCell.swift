//
//  EditSwarmButtonsTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 13/01/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import UIKit

protocol EditSwarmButtonsTableViewCellDelegate  {
    func didAddMemberButtonTapped()
    func didDeleteSwarmButtonTapped()
}

class EditSwarmButtonsTableViewCell: UITableViewCell {
    
    var delegate: EditSwarmButtonsTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addMemberButtonTapped(_ sender: Any) {
        delegate?.didAddMemberButtonTapped()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.didDeleteSwarmButtonTapped()
    }
    
    class func instanceFromNib() -> EditSwarmButtonsTableViewCell {
        return UINib(nibName: "EditSwarmButtonsTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EditSwarmButtonsTableViewCell
    }
}
