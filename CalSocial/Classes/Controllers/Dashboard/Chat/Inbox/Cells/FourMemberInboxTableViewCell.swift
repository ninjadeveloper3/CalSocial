//
//  FourMemberInboxTableViewCell.swift
//  CalSocial
//
//  Created by Moiz Amjad on 28/02/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import UIKit
import TwilioChatClient
import TwilioAccessManager

class FourMemberInboxTableViewCell: UITableViewCell {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var emptyViewFirst: HMView!
    
    @IBOutlet weak var emptyViewLabelFirst: UILabel!
    
    @IBOutlet weak var profileImageFirst: BUIImageView!
    
    @IBOutlet weak var emptyViewSecond: HMView!
    
    @IBOutlet weak var emptyViewSecondLabel: UILabel!
    
    @IBOutlet weak var profileImageSecond: BUIImageView!
    
    @IBOutlet weak var emptyViewThird: HMView!
    
    @IBOutlet weak var emptyViewThirdLabel: UILabel!
    
    @IBOutlet weak var profileImageThird: BUIImageView!
    
    @IBOutlet weak var emptyViewFour: HMView!
    
    @IBOutlet weak var emptyViewFourLabel: UILabel!
    
    @IBOutlet weak var profileImageFour: BUIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var chatTitleLabel: UILabel!
    
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
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> FourMemberInboxTableViewCell {
        let kFourMemberInboxTableViewCell = "kFourMemberInboxTableViewCell"
        tableView.register(UINib(nibName: "FourMemberInboxTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kFourMemberInboxTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kFourMemberInboxTableViewCell, for: indexPath) as! FourMemberInboxTableViewCell
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
        if chatMembers.count >= 3 {
            if chatMembers[0].picture != "" {
                profileImageFirst.isHidden = false
                if let url = URL(string: "\(kImageDownloadBaseUrl)\(chatMembers[0].picture)") {
                    debugPrint("User URL: \(url)")
                    profileImageFirst.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                
                } else {
                    emptyViewFirst.isHidden = false
                    emptyViewLabelFirst.isHidden = false
                    profileImageFirst.isHidden = true
                    emptyViewLabelFirst.text = chatMembers[0].name.getFirstChar()
                }
                
            } else {
                emptyViewFirst.isHidden = false
                emptyViewLabelFirst.isHidden = false
                profileImageFirst.isHidden = true
                emptyViewLabelFirst.text = chatMembers[0].name.getFirstChar()
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
                }
                
            } else {
                emptyViewThird.isHidden = false
                emptyViewThirdLabel.isHidden = false
                profileImageThird.isHidden = true
                emptyViewThirdLabel.text = chatMembers[2].name.getFirstChar()
            }
            
            if chatMembers[3].picture != "" {
                profileImageFour.isHidden = false
                if let url = URL(string: "\(kImageDownloadBaseUrl)\(chatMembers[2].picture)") {
                    debugPrint("User URL: \(url)")
                    profileImageFour.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                
                } else {
                    emptyViewFour.isHidden = false
                    emptyViewFourLabel.isHidden = false
                    profileImageFour.isHidden = true
                    emptyViewFourLabel.text = chatMembers[2].name.getFirstChar()
                }
                
            } else {
                emptyViewFour.isHidden = false
                emptyViewFourLabel.isHidden = false
                profileImageFour.isHidden = true
                emptyViewFourLabel.text = chatMembers[2].name.getFirstChar()
            }
        }
    }
}
