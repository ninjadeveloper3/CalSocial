//
//  InboxTableViewCell.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 02/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import TwilioChatClient
import TwilioAccessManager

class InboxTableViewCell: UITableViewCell {

    @IBOutlet weak var chatTitleLabel: UILabel!
    
    @IBOutlet weak var chatSubtitleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var emptyView: HMView!
    
    @IBOutlet weak var emptyViewLabel: UILabel!
    
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
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> InboxTableViewCell {
        let kInboxTableViewCell = "kInboxTableViewCell"
        tableView.register(UINib(nibName: "InboxTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kInboxTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kInboxTableViewCell, for: indexPath) as! InboxTableViewCell
        return cell
    }
    
    func initData(channel: TCHChannel, member: [AttMember]) {
        var userId = 0
        var chatMembers = [AttMember]()
        chatMembers.removeAll()
        if Utility.isKeyPresentInUserDefaults(key: kUserId) {
            if let userid  = UserDefaults.standard.object(forKey: kUserId) as? Int {
                userId = userid
            }
        }
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mma"
        let time = timeFormatter.string(from: channel.lastMessageDate ?? Date())
        timeLabel.text = time
        channel.messages?.getLastWithCount(1, completion: { (result, message) in
            if message?.count ?? 0 > 0 {
              self.chatSubtitleLabel.text = message?[0].body ?? "No Message"
                
            } else {
                self.chatSubtitleLabel.text = "No Message"
            }
        })
        chatMembers = member.filter({ $0.id != userId })
        if chatMembers.count > 0 {
            if chatMembers[0].picture != "" {
                profileImage.isHidden = false
                if let url = URL(string: "\(kImageDownloadBaseUrl)\(chatMembers[0].picture)") {
                    debugPrint("User URL: \(url)")
                    profileImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                }
                
            } else {
                emptyView.isHidden = false
                emptyViewLabel.isHidden = false
                profileImage.isHidden = true
                emptyViewLabel.text = chatMembers[0].name.getFirstChar()
            }
        }
    }
}

