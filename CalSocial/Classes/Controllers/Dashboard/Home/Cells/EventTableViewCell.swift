//
//  EventTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 02/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var startTimeLabel: UILabel!
    
    
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    @IBOutlet weak var eventStatusLabel: UILabel!
    
    @IBOutlet weak var statusDot: HMView!
    
    @IBOutlet weak var moreMembers: HMView!
    
    @IBOutlet weak var firstMemberView: HMView!
    
    @IBOutlet weak var firstMemberEmptyLabel: UILabel!
    
    @IBOutlet weak var firstMemberImage: BUIImageView!
    
    @IBOutlet weak var firstMemberStatusDot: HMView!
    
    @IBOutlet weak var secondMemberView: HMView!
    
    @IBOutlet weak var secondMemberLabel: UILabel!
    
    @IBOutlet weak var secondMemberImage: BUIImageView!
    
    @IBOutlet weak var secondMemberStatusDot: HMView!
    
    
    
    var statusKey = false
    
    var userId  = 0
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        if Utility.isKeyPresentInUserDefaults(key: kUserId){
            self.userId = UserDefaults.standard.object(forKey: kUserId) as! Int
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> EventTableViewCell {
        let kEventTableViewCell = "kEventTableViewCell"
        tableView.register(UINib(nibName: "EventTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kEventTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kEventTableViewCell, for: indexPath) as! EventTableViewCell
        return cell
    }
    
    func initData(dataSource: BizeeEventData,dateFormat: Bool) {
        
        if dateFormat {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateType = dateFormatter.date(from: dataSource.eventDate)!
            dateFormatter.dateFormat = "EEE"
            let dayOfTheWeekString = dateFormatter.string(from: dateType)
            
            dateFormatter.dateFormat = "MMM dd"
            let formatDateToDisplay = dateFormatter.string(from: dateType)
            
            startTimeLabel.text = dayOfTheWeekString
            endTimeLabel.text = "\(formatDateToDisplay)"
        }
        else{
            startTimeLabel.text = Date().covertTimeFormat(time: dataSource.startTime)
            endTimeLabel.text = Date().covertTimeFormat(time: dataSource.endTime)
        }
        
        
        eventTitleLabel.text = dataSource.title
        
        if dataSource.myStatus == .joined {
            eventStatusLabel.text = "You Joined"
            eventStatusLabel.textColor = UIColor.CustomColorFromHexaWithAlpha("AEBE61", alpha: 1.0)
            eventStatusLabel.font = UIFont.muliBold(12.0)
            statusDot.backgroundColor = #colorLiteral(red: 0.6823529412, green: 0.7450980392, blue: 0.3803921569, alpha: 1)
            statusDot.borderWidth = 0
        }
        if dataSource.myStatus == .didntJoin {
            eventStatusLabel.text = "Didn't Join"
            eventStatusLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            eventStatusLabel.font = UIFont.muliBold(12.0)
            statusDot.backgroundColor = #colorLiteral(red: 0.8290296793, green: 0.3805963993, blue: 0.205390662, alpha: 1)
            statusDot.borderWidth = 0
        }
        if dataSource.myStatus == .waiting {
            eventStatusLabel.text = "Waiting"
            eventStatusLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            eventStatusLabel.font = UIFont.muliBold(12.0)
            statusDot.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            statusDot.borderWidth = 0.8
            statusDot.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            
        }
        if dataSource.myStatus == .maybe {
            eventStatusLabel.text = "Maybe"
            eventStatusLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            eventStatusLabel.font = UIFont.muliBold(12.0)
            statusDot.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            statusDot.borderWidth = 0
        }
//        emptyView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(dataSource.backgroundColor, alpha: 1.0)
        
        if dataSource.members.count == 1 { // Only You in the event
            secondMemberView.isHidden = true
            moreMembers.isHidden = true
            secondMemberStatusDot.isHidden = true
            for (index,member) in dataSource.members.enumerated() { //in case of phone number 
                
                    if member.users.profilePicture == "" {
                        firstMemberView.isHidden = false
                        firstMemberImage.isHidden = true
                        let firstName = member.users.firstName
                        let lastName = member.users.lastName
                        if firstName != "" && lastName != "" {
                            firstMemberEmptyLabel.text = firstName.getFirstChar()+lastName.getFirstChar()
                        }
                        firstMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.users.color, alpha: 1.0)
                    }
                    else{
                        firstMemberView.isHidden = false
                        firstMemberImage.isHidden = false
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.users.profilePicture)") {
                            print("url",url)
                            firstMemberImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                    }
                    
                    if userId == member.id { //member bottom dot status
                        self.memberStatus(status: dataSource.myStatus.rawValue, index: index)
                    }
                    else{
                        self.memberStatus(status: member.status,index: index)
                    }
            }
        }
        else if dataSource.members.count >= 2 { // 2 member event (including you)
            secondMemberStatusDot.isHidden = false
            if dataSource.members.count == 2 {
                moreMembers.isHidden = true
                
            }
            else{
                moreMembers.isHidden = false
            }
            
            for (index,member) in dataSource.members.enumerated() {
                if index == 0 {
                    if member.isBizee{
                    if member.users.profilePicture == "" {
//                        emptyView.isHidden = true
//                        eventImage.isHidden = true
                        firstMemberView.isHidden = false
                        firstMemberImage.isHidden = true
                        let firstName = member.users.firstName
                        let lastName = member.users.lastName
                        if firstName != "" && lastName != "" {
                            firstMemberEmptyLabel.text = firstName.getFirstChar()+lastName.getFirstChar()
                        }
                        firstMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.users.color, alpha: 1.0)
                    }
                    else{
//                        emptyView.isHidden = true
//                        eventImage.isHidden = true
                        firstMemberView.isHidden = false
                        firstMemberImage.isHidden = false
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.users.profilePicture)") {
                            print("url",url)
                            firstMemberImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                    }
                }
                else{
                        firstMemberView.isHidden = false
                        firstMemberImage.isHidden = true
                        let firstName = member.phoneUsers.firstName
                        
                        if firstName != ""  {
                            firstMemberEmptyLabel.text = firstName.getFirstChar()
                        }
                        firstMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.users.color, alpha: 1.0)
                }
                    if userId == member.id { //member bottom dot status
                        self.memberStatus(status: dataSource.myStatus.rawValue, index: index)
                    }
                    else{
                        self.memberStatus(status: member.status,index: index)
                        }
                }
                else{
                    secondMemberView.isHidden = false
                    if member.users.profilePicture == "" {
//                        emptyView.isHidden = true
//                        eventImage.isHidden = true
                        
                        secondMemberImage.isHidden = true
                        let firstName = member.users.firstName
                        let lastName = member.users.lastName
                        if firstName != "" && lastName != "" {
                            secondMemberLabel.text = firstName.getFirstChar()+lastName.getFirstChar()
                        }
                        secondMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.users.color, alpha: 1.0)
                    }
                    else{
//                        emptyView.isHidden = true
//                        eventImage.isHidden = true
                        secondMemberImage.isHidden = false
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.users.profilePicture)") {
                            print("url",url)
                            secondMemberImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                    }
                    
                    if userId == member.id { //member bottom dot status
                        self.memberStatus(status: dataSource.myStatus.rawValue,index: index)
                    }
                    else{
                        self.memberStatus(status: member.status,index: index)
                    }
                }
            }
        }
        else{ //more then 2 members
            
            moreMembers.isHidden = false
        }
        
    }
    
    func setStatus(status: EventStatus){
        if status == .joined {
            eventStatusLabel.text = "You Joined"
            eventStatusLabel.textColor = UIColor.CustomColorFromHexaWithAlpha("AEBE61", alpha: 1.0)
            eventStatusLabel.font = UIFont.muliBold(12.0)
            
        }
        if status == .didntJoin {
            eventStatusLabel.text = "Didn't Join"
            eventStatusLabel.textColor = #colorLiteral(red: 0.8290296793, green: 0.3805963993, blue: 0.205390662, alpha: 1)
            eventStatusLabel.font = UIFont.muliBold(12.0)
            
        }
        if status == .waiting {
            eventStatusLabel.text = "Waiting"
            eventStatusLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            eventStatusLabel.font = UIFont.muliBold(12.0)
            
        }
        if status == .maybe {
            eventStatusLabel.text = "Maybe"
            eventStatusLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            eventStatusLabel.font = UIFont.muliBold(12.0)
            
        }
    }
    
    func memberStatus(status: Int, index: Int){
        
        if status == 1 {
            if index == 0 { //going
                firstMemberStatusDot.backgroundColor = #colorLiteral(red: 0.6808918118, green: 0.7444447875, blue: 0.378949523, alpha: 1)
            }
            else{
                secondMemberStatusDot.backgroundColor = #colorLiteral(red: 0.6808918118, green: 0.7444447875, blue: 0.378949523, alpha: 1)
            }
            
        }
        if status == 0 { //Not going
            if index == 0 {
                firstMemberStatusDot.backgroundColor = #colorLiteral(red: 0.8290296793, green: 0.3805963993, blue: 0.205390662, alpha: 1)
            }
            else{
                secondMemberStatusDot.backgroundColor = #colorLiteral(red: 0.8290296793, green: 0.3805963993, blue: 0.205390662, alpha: 1)
            }
        }
        if status == 3 { //waiting
            if index == 0 {
                firstMemberStatusDot.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                firstMemberStatusDot.borderWidth = 0.8
                firstMemberStatusDot.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
            else{
                secondMemberStatusDot.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                secondMemberStatusDot.borderWidth = 0.8
                secondMemberStatusDot.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
        }
        if status == 2 { //maybe
            if index == 0 {
                firstMemberStatusDot.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
            else{
                secondMemberStatusDot.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
        }
    }
}
