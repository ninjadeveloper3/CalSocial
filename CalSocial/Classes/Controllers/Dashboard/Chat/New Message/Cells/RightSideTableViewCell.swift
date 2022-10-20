//
//  RightSideTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 17/01/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import UIKit
import TwilioChatClient
import TwilioAccessManager

class RightSideTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textMessageLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var profileImageView: BUIImageView!
    
    @IBOutlet weak var emptyView: HMView!
    
    @IBOutlet weak var emptyLable: UILabel!
    
    
    var userAuthor = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> RightSideTableViewCell {
        let kRightSideTableViewCell = "kRightSideTableViewCell"
        tableView.register(UINib(nibName: "RightSideTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kRightSideTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kRightSideTableViewCell, for: indexPath) as! RightSideTableViewCell
        return cell
    }
    
    func initData(message: TCHMessage, membersFlag: Bool) {
        textMessageLabel.text = message.body
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "EE, dd MMM, hh:mma"
        let time = timeFormatter.string(from: message.dateUpdatedAsDate ?? Date())
        timeLabel.text = time
        
        for (key,value) in message.attributes()! {
            if key == "author" {
                if let author = value as? String {
                    if membersFlag {
                        userNameLabel.text = author
                        userAuthor = author
                        
                    } else {
                        userNameLabel.text = ""
                        userAuthor = author
                    }
                }
            }
            
            if key == "profile_picture" {
                if let profilePicture = value as? String {
                    if profilePicture != "" {
                        emptyView.isHidden = true
                        emptyLable.isHidden = true
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(profilePicture)") {
                            profileImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                        
                    } else {
                        emptyView.isHidden = false
                        emptyLable.isHidden = false
                        if let author = value as? String {
                            emptyLable.text = userAuthor.getFirstChar()
                        }
                    }
                    
                } else {
                    emptyView.isHidden = false
                    emptyLable.isHidden = false
                    if let author = value as? String {
                        emptyLable.text = userAuthor.getFirstChar()
                    }
                }
            }
        }
    }
}
