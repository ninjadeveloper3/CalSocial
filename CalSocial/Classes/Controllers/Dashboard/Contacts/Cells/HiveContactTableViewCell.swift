//
//  HiveContactTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 30/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol HiveContactTableViewCellDelegate {
    func didTappedCreateEvent(cell: HiveContactTableViewCell)
    func didTappedMessageIcon(cell: HiveContactTableViewCell)
}

class HiveContactTableViewCell: UITableViewCell {

    @IBOutlet weak var createEventImageView: UIImageView!
    
    @IBOutlet weak var messageImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var favIconImageView: UIImageView!
    
    @IBOutlet weak var emptyImageView: HMView!
    
    @IBOutlet weak var emptyImageLabelText: UILabel!
    
    @IBOutlet weak var profileImage: BUIImageView!
    
    
    var delegate: HiveContactTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(createEventGestureTapped(sender:)))
        createEventImageView.addGestureRecognizer(tapGesture)
        
        let messageTapGesture = UITapGestureRecognizer(target: self, action: #selector(messageIconGestureTapped(sender:)))
        messageImageView.addGestureRecognizer(messageTapGesture)
        profileImage.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func createEventGestureTapped(sender: UITapGestureRecognizer){
        delegate?.didTappedCreateEvent(cell: self)
    }
    
    @objc func messageIconGestureTapped(sender: UITapGestureRecognizer){
        delegate?.didTappedMessageIcon(cell: self)
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> HiveContactTableViewCell {
        let kHiveContactTableViewCell = "kHiveContactTableViewCell"
        tableView.register(UINib(nibName: "HiveContactTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kHiveContactTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kHiveContactTableViewCell, for: indexPath) as! HiveContactTableViewCell
        return cell
    }
}
