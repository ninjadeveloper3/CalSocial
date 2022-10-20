//
//  ThreeMemberInboxTableViewCell.swift
//  CalSocial
//
//  Created by Moiz Amjad on 28/02/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import UIKit
import TwilioChatClient
import TwilioAccessManager

class ThreeMemberInboxTableViewCell: UITableViewCell {
    
    //MARK:-IBOutlets
    
    @IBOutlet weak var emptyVIewFirst: HMView!
    
    @IBOutlet weak var emptyViewFirstLabel: UILabel!
    
    @IBOutlet weak var profileImageFirst: BUIImageView!
    
    @IBOutlet weak var emptyViewSecond: HMView!
    
    @IBOutlet weak var emptyViewSecondLabel: UILabel!
    
    @IBOutlet weak var profileImageSecond: BUIImageView!
    
    @IBOutlet weak var emptyViewThird: HMView!
    
    @IBOutlet weak var emptyViewThirdLabel: UILabel!
    
    @IBOutlet weak var profileImageThird: BUIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var chatTitelLabel: UILabel!
    
    @IBOutlet weak var chatSubtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> ThreeMemberInboxTableViewCell {
        let kThreeMemberInboxTableViewCell = "kThreeMemberInboxTableViewCell"
        tableView.register(UINib(nibName: "ThreeMemberInboxTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kThreeMemberInboxTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kThreeMemberInboxTableViewCell, for: indexPath) as! ThreeMemberInboxTableViewCell
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
        let index = channel.messages?.lastConsumedMessageIndex
        channel.messages?.getLastWithCount(1, completion: { (result, message) in
            if message?.count ?? 0 > 0 {
              self.chatSubtitleLabel.text = message?[0].body ?? "No Message"
                
            } else {
                self.chatSubtitleLabel.text = "No Message"
            }
        })
        chatMembers = member.filter({ $0.id != userId })
        if chatMembers.count >= 3 {
            if chatMembers[0].picture != "" {
                profileImageFirst.isHidden = false
                if let url = URL(string: "\(kImageDownloadBaseUrl)\(chatMembers[0].picture)") {
                    debugPrint("User URL: \(url)")
                    profileImageFirst.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                    
                } else {
                    emptyVIewFirst.isHidden = false
                    emptyViewFirstLabel.isHidden = false
                    profileImageFirst.isHidden = true
                    emptyViewFirstLabel.text = chatMembers[0].name.getFirstChar()
                }
                
            } else {
                emptyVIewFirst.isHidden = false
                emptyViewFirstLabel.isHidden = false
                profileImageFirst.isHidden = true
                emptyViewFirstLabel.text = chatMembers[0].name.getFirstChar()
            }
            
            if chatMembers[1].picture != "" {
                profileImageSecond.isHidden = false
                if let url = URL(string: "\(kImageDownloadBaseUrl)\(chatMembers[1].picture)") {
                    debugPrint("User URL: \(url)")
                    profileImageSecond.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                
                } else {
                    emptyViewSecond.isHidden = false
                    emptyViewSecondLabel.isHidden = false
                    profileImageSecond.isHidden = true
                    emptyViewSecondLabel.text = chatMembers[1].name.getFirstChar()

                }
                
            } else {
                emptyViewSecond.isHidden = false
                emptyViewSecondLabel.isHidden = false
                profileImageSecond.isHidden = true
                emptyViewSecondLabel.text = chatMembers[1].name.getFirstChar()
            }
            
            if chatMembers[2].picture != "" {
                profileImageThird.isHidden = false
                if let url = URL(string: "\(kImageDownloadBaseUrl)\(chatMembers[2].picture)") {
                    debugPrint("User URL: \(url)")
                    profileImageThird.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                } else {
                    emptyViewThird.isHidden = false
                    emptyViewThirdLabel.isHidden = false
                    profileImageThird.isHidden = true
                    emptyViewThirdLabel.text = chatMembers[2].name.getFirstChar()
                }
                
            } else {
                emptyViewThird.isHidden = false
                emptyViewThirdLabel.isHidden = false
                profileImageThird.isHidden = true
                emptyViewThirdLabel.text = chatMembers[2].name.getFirstChar()
            }
        }
    }
}
