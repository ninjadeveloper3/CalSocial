//
//  UserInfoTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 12/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol UserInfoTableViewCellDelegate {
    func didClickStatusButton(cell: UserInfoTableViewCell,request: String)
    func didTappedCreateEventButton()
    func didTappedMessageButton(cell: UserInfoTableViewCell)
}

class UserInfoTableViewCell: UITableViewCell {
    
    //MARK:- Variables
    
    var delegate : UserInfoTableViewCellDelegate?
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var statusButton: MBButton!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var bio: UILabel!
    
    @IBOutlet weak var emptyImageView: HMView!
    
    @IBOutlet weak var emptyImageLabelText: UILabel!
    
    @IBOutlet weak var profileImageView: BUIImageView!
    
    @IBOutlet weak var requestAcceptButton: MBButton!
    
    @IBOutlet weak var requestDeclineButton: MBButton!
    
    @IBOutlet weak var messageIcon: UIImageView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var messageButton: UIButton!
    
    @IBOutlet weak var eventIcon: UIImageView!
    
    @IBOutlet weak var eventLabel: UILabel!
    
    @IBOutlet weak var eventButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func statusButtonTapped(_ sender: Any) {
        delegate?.didClickStatusButton(cell: self,request: "")
    }
    
    @IBAction func requestAcceptTapped(_ sender: Any) {
        delegate?.didClickStatusButton(cell: self,request: "Accept")
    }
    
    @IBAction func requestDeclineTapped(_ sender: Any) {
        delegate?.didClickStatusButton(cell: self,request: "Decline")
    }
    
    
    @IBAction func createEventButtonTapped(_ sender: Any) {
        print("Tapped")
        delegate?.didTappedCreateEventButton()
    }
    
    @IBAction func messageButtonTapped(_ sender: Any) {
        delegate?.didTappedMessageButton(cell: self)
    }
    
    
    func setStatus(status: Int) {
        if status == 0 { //add to hive
            self.messageIcon.isHidden = true
            self.messageLabel.isHidden = true
            statusButton.setTitle("Add to Hive", for: .normal)
            statusButton.backgroundColor = #colorLiteral(red: 1, green: 0.7616637349, blue: 0.04396914691, alpha: 1)
        }
        if status == 1 { //in your hive
            self.messageIcon.isHidden = false
            self.messageLabel.isHidden = false
            statusButton.setTitle("In Hive", for: .normal)
            statusButton.backgroundColor = #colorLiteral(red: 1, green: 0.7616637349, blue: 0.04396914691, alpha: 1)
        }
        if status == 2 { //request received
            self.messageIcon.isHidden = true
            self.messageLabel.isHidden = true
            statusButton.setTitle("Request Received", for: .normal)
            statusButton.backgroundColor = #colorLiteral(red: 0.5414876938, green: 0.6542616487, blue: 0.7128990293, alpha: 1)
        }
        if status == 3 { //request Sent
            self.messageIcon.isHidden = true
            self.messageLabel.isHidden = true
            statusButton.setTitle("Request Sent", for: .normal)
            statusButton.backgroundColor = #colorLiteral(red: 0.5414876938, green: 0.6542616487, blue: 0.7128990293, alpha: 1)
        }
    }
    
    class func instanceFromNib() -> UserInfoTableViewCell {
        return UINib(nibName: "UserInfoTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UserInfoTableViewCell
    }
    
}
