//
//  ViewHiveTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 12/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class ViewHiveTableViewCell: UITableViewCell {
    
    //MARK:- IBOutlets
    
    
    @IBOutlet weak var viewHiveLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func instanceFromNib() -> ViewHiveTableViewCell {
        return UINib(nibName: "ViewHiveTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ViewHiveTableViewCell
    }
    
}
