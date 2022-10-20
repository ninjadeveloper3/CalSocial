//
//  MyUserTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 12/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class MyUserTableViewCell: UITableViewCell {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var emptyImageView: HMView!
    
    @IBOutlet weak var imagePlaceholderName: UILabel!
    
    @IBOutlet weak var fullName: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var bio: UILabel!
    
    @IBOutlet weak var profileImage: BUIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func instanceFromNib() -> MyUserTableViewCell {
        return UINib(nibName: "MyUserTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MyUserTableViewCell
    }
    
}
