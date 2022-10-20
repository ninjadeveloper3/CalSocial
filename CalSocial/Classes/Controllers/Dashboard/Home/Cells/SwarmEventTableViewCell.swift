//
//  SwarmEventTableViewCell.swift
//  CalSocial
//
//  Created by Moiz Amjad on 03/03/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import UIKit

class SwarmEventTableViewCell: UITableViewCell {
    
    //MARK:- Variablesah
    
    var statusKey = false
    
    var userId  = 0
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    @IBOutlet weak var eventStatusLabel: UILabel!
    
    @IBOutlet weak var statusDot: HMView!
    
    @IBOutlet weak var moreMembers: HMView!
    
    @IBOutlet weak var firstMemberView: HMView!
    
    @IBOutlet weak var firstMemberEmptyLabel: UILabel!
    
    @IBOutlet weak var firstMemberImage: BUIImageView!
    
    @IBOutlet weak var secondMemberView: HMView!
    
    @IBOutlet weak var secondMemberLabel: UILabel!
    
    @IBOutlet weak var secondMemberImage: BUIImageView!
    
    @IBOutlet weak var thirdMemberView: HMView!
    
    @IBOutlet weak var thirdMemberEmptyLabel: UILabel!
    
    @IBOutlet weak var thirdMemberImage: BUIImageView!
    
    @IBOutlet weak var fourthMemberView: HMView!
    
    @IBOutlet weak var fourthMemberLabel: UILabel!
    
    @IBOutlet weak var fourthMemberImage: BUIImageView!
    
    @IBOutlet weak var swarmName: UILabel!
    
    
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
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> SwarmEventTableViewCell {
        let kSwarmEventTableViewCell = "kSwarmEventTableViewCell"
        tableView.register(UINib(nibName: "SwarmEventTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kSwarmEventTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kSwarmEventTableViewCell, for: indexPath) as! SwarmEventTableViewCell
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
        
        
        swarmName.text = dataSource.swarms.title
        eventTitleLabel.text = dataSource.title
        
        if dataSource.myStatus == .joined {
            eventStatusLabel.text = "You Joined"
            eventStatusLabel.textColor = UIColor.CustomColorFromHexaWithAlpha("AEBE61", alpha: 1.0)
            eventStatusLabel.font = UIFont.muliBold(12.0)
            statusDot.backgroundColor = #colorLiteral(red: 0.6808918118, green: 0.7444447875, blue: 0.378949523, alpha: 1)
        }
        if dataSource.myStatus == .didntJoin {
            eventStatusLabel.text = "Didn't Join"
            eventStatusLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            eventStatusLabel.font = UIFont.muliBold(12.0)
            statusDot.backgroundColor = #colorLiteral(red: 0.8290296793, green: 0.3805963993, blue: 0.205390662, alpha: 1)
        }
        if dataSource.myStatus == .waiting {
            eventStatusLabel.text = "Waiting"
            eventStatusLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            eventStatusLabel.font = UIFont.muliBold(12.0)
            statusDot.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        if dataSource.myStatus == .maybe {
            eventStatusLabel.text = "Maybe"
            eventStatusLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            eventStatusLabel.font = UIFont.muliBold(12.0)
            statusDot.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        //        emptyView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(dataSource.backgroundColor, alpha: 1.0)
        
        if dataSource.swarms.members.count == 1 { // Only You in the event
            
            for (index,member) in dataSource.swarms.members.enumerated() {
                firstMemberView.isHidden = false
                secondMemberView.isHidden = true
                secondMemberImage.isHidden = true
                thirdMemberView.isHidden = true
                thirdMemberImage.isHidden = true
                fourthMemberView.isHidden = true
                fourthMemberImage.isHidden = true
                moreMembers.isHidden = true
                if member.profilePic == "" {
                    //                    firstMemberView.isHidden = false
                    firstMemberImage.isHidden = true
                    let firstName = member.firstName
                    let lastName = member.lastName
                    if firstName != "" && lastName != "" {
                        firstMemberEmptyLabel.text = firstName.getFirstChar()+lastName.getFirstChar()
                    }
                    firstMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.color, alpha: 1.0)
                }
                else{
                    //                    firstMemberView.isHidden = true
                    firstMemberImage.isHidden = false
                    if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.profilePic)") {
                        print("url",url)
                        firstMemberImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                        })
                    }
                }
            }
        }
        else if dataSource.swarms.members.count == 2 { // 2 member event (including you)
            firstMemberView.isHidden = false
            secondMemberView.isHidden = false
            thirdMemberImage.isHidden = true
            thirdMemberView.isHidden = true
            fourthMemberView.isHidden = true
            fourthMemberImage.isHidden = true
            moreMembers.isHidden = true
            for (index,member) in dataSource.swarms.members.enumerated() {
                if index == 0 {
                    if member.profilePic == "" {
                        //                        firstMemberView.isHidden = false
                        firstMemberImage.isHidden = true
                        let firstName = member.firstName
                        let lastName = member.lastName
                        if firstName != "" && lastName != "" {
                            firstMemberEmptyLabel.text = firstName.getFirstChar()+lastName.getFirstChar()
                        }
                        firstMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.color, alpha: 1.0)
                    }
                    else{
                        //                        firstMemberView.isHidden = true
                        firstMemberImage.isHidden = false
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.profilePic)") {
                            print("url",url)
                            firstMemberImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                    }
                }
                else{
                    if member.profilePic == "" {
                        //                        emptyView.isHidden = true
                        //                        eventImage.isHidden = true
                        //                        secondMemberView.isHidden = false
                        secondMemberImage.isHidden = true
                        let firstName = member.firstName
                        let lastName = member.lastName
                        if firstName != "" && lastName != "" {
                            secondMemberLabel.text = firstName.getFirstChar()+lastName.getFirstChar()
                        }
                        secondMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.color, alpha: 1.0)
                    }
                    else{
                        //                        emptyView.isHidden = true
                        //                        eventImage.isHidden = true
                        //                        secondMemberView.isHidden = true
                        secondMemberImage.isHidden = false
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.profilePic)") {
                            print("url",url)
                            secondMemberImage.af_setImage(withURL:url, placeholderImage:#imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                    }
                }
            }
        }
        else if dataSource.swarms.members.count == 3 { // 2 member event (including you)
            firstMemberView.isHidden = false
            secondMemberView.isHidden = false
            thirdMemberView.isHidden = false
            fourthMemberView.isHidden = true
            fourthMemberImage.isHidden = true
            moreMembers.isHidden = true
            for (index,member) in dataSource.swarms.members.enumerated() {
                if index == 0 {
                    if member.profilePic == "" {
                        //                        firstMemberView.isHidden = false
                        firstMemberImage.isHidden = true
                        let firstName = member.firstName
                        let lastName = member.lastName
                        if firstName != "" && lastName != "" {
                            firstMemberEmptyLabel.text = firstName.getFirstChar()+lastName.getFirstChar()
                        }
                        firstMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.color, alpha: 1.0)
                    }
                    else{
                        //                        firstMemberView.isHidden = true
                        firstMemberImage.isHidden = false
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.profilePic)") {
                            print("url",url)
                            firstMemberImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                    }
                }
                else if index == 1 {
                    if member.profilePic == "" {
                        //                        secondMemberView.isHidden = false
                        secondMemberImage.isHidden = true
                        //                        secondMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.color, alpha: 1.0)
                        let firstName = member.firstName
                        let lastName = member.lastName
                        if firstName != "" && lastName != "" {
                            secondMemberLabel.text = firstName.getFirstChar()+lastName.getFirstChar()
                        }
                        secondMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.color, alpha: 1.0)
                    }
                    else{
                        //                        secondMemberView.isHidden = true
                        secondMemberImage.isHidden = false
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.profilePic)") {
                            print("url",url)
                            secondMemberImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                    }
                }
                else if index == 2 {
                    if member.profilePic == "" {
                        //                        thirdMemberView.isHidden = false
                        thirdMemberImage.isHidden = true
                        let firstName = member.firstName
                        let lastName = member.lastName
                        if firstName != "" && lastName != "" {
                            thirdMemberEmptyLabel.text = firstName.getFirstChar()+lastName.getFirstChar()
                        }
                        thirdMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.color, alpha: 1.0)
                    }
                    else{
                        //                        thirdMemberView.isHidden = true
                        thirdMemberImage.isHidden = false
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.profilePic)") {
                            print("url",url)
                            thirdMemberImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                    }
                }
            }
        }
        else if dataSource.swarms.members.count == 4 { // 2 member event (including you)
            firstMemberView.isHidden = false
            secondMemberView.isHidden = false
            thirdMemberView.isHidden = false
            fourthMemberView.isHidden = false
            moreMembers.isHidden = true
            for (index,member) in dataSource.swarms.members.enumerated() {
                if index == 0 {
                    if member.profilePic == "" {
                        //                        firstMemberView.isHidden = false
                        firstMemberImage.isHidden = true
                        let firstName = member.firstName
                        let lastName = member.lastName
                        if firstName != "" && lastName != "" {
                            firstMemberEmptyLabel.text = firstName.getFirstChar()+lastName.getFirstChar()
                        }
                        firstMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.color, alpha: 1.0)
                    }
                    else{
                        //                        firstMemberView.isHidden = true
                        firstMemberImage.isHidden = false
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.profilePic)") {
                            print("url",url)
                            firstMemberImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                    }
                }
                else if index == 1 {
                    if member.profilePic == "" {
                        //                        secondMemberView.isHidden = false
                        secondMemberImage.isHidden = true
                        //                        secondMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.color, alpha: 1.0)
                        let firstName = member.firstName
                        let lastName = member.lastName
                        if firstName != "" && lastName != "" {
                            secondMemberLabel.text = firstName.getFirstChar()+lastName.getFirstChar()
                        }
                        secondMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.color, alpha: 1.0)
                    }
                    else{
                        //                        secondMemberView.isHidden = true
                        secondMemberImage.isHidden = false
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.profilePic)") {
                            print("url",url)
                            secondMemberImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                    }
                }
                else if index == 2 {
                    if member.profilePic == "" {
                        //                        thirdMemberView.isHidden = false
                        thirdMemberImage.isHidden = true
                        let firstName = member.firstName
                        let lastName = member.lastName
                        if firstName != "" && lastName != "" {
                            thirdMemberEmptyLabel.text = firstName.getFirstChar()+lastName.getFirstChar()
                        }
                        thirdMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.color, alpha: 1.0)
                    }
                    else{
                        //                        thirdMemberView.isHidden = true
                        thirdMemberImage.isHidden = false
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.profilePic)") {
                            print("url",url)
                            thirdMemberImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                    }
                }
                else if index == 3 {
                    if member.profilePic == "" {
                        //                                    fourthMemberView.isHidden = false
                        fourthMemberImage.isHidden = true
                        let firstName = member.firstName
                        let lastName = member.lastName
                        if firstName != "" && lastName != "" {
                            fourthMemberLabel.text = firstName.getFirstChar()+lastName.getFirstChar()
                        }
                        fourthMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.color, alpha: 1.0)
                    }
                    else{
                        //                                    fourthMemberView.isHidden = true
                        fourthMemberImage.isHidden = false
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.profilePic)") {
                            print("url",url)
                            fourthMemberImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                    }
                }
            }
            
        } else  { // 2 member event (including you) Greater then 4
            firstMemberView.isHidden = false
            secondMemberView.isHidden = false
            thirdMemberView.isHidden = false
            fourthMemberView.isHidden = false
            moreMembers.isHidden = false
            for (index,member) in dataSource.swarms.members.enumerated() {
                if index == 0 {
                    if member.profilePic == "" {
                        //                        firstMemberView.isHidden = false
                        firstMemberImage.isHidden = true
                        let firstName = member.firstName
                        let lastName = member.lastName
                        if firstName != "" && lastName != "" {
                            firstMemberEmptyLabel.text = firstName.getFirstChar()+lastName.getFirstChar()
                        }
                        firstMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.color, alpha: 1.0)
                    }
                    else{
                        //                        firstMemberView.isHidden = true
                        firstMemberImage.isHidden = false
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.profilePic)") {
                            print("url",url)
                            firstMemberImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                    }
                }
                else if index == 1 {
                    if member.profilePic == "" {
                        //                        secondMemberView.isHidden = false
                        secondMemberImage.isHidden = true
                        //                        secondMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.color, alpha: 1.0)
                        let firstName = member.firstName
                        let lastName = member.lastName
                        if firstName != "" && lastName != "" {
                            secondMemberLabel.text = firstName.getFirstChar()+lastName.getFirstChar()
                        }
                        secondMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.color, alpha: 1.0)
                    }
                    else{
                        //                        secondMemberView.isHidden = true
                        secondMemberImage.isHidden = false
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.profilePic)") {
                            print("url",url)
                            secondMemberImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                    }
                }
                else if index == 2 {
                    if member.profilePic == "" {
                        //                        thirdMemberView.isHidden = false
                        thirdMemberImage.isHidden = true
                        let firstName = member.firstName
                        let lastName = member.lastName
                        if firstName != "" && lastName != "" {
                            thirdMemberEmptyLabel.text = firstName.getFirstChar()+lastName.getFirstChar()
                        }
                        thirdMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.color, alpha: 1.0)
                    }
                    else{
                        //                        thirdMemberView.isHidden = true
                        thirdMemberImage.isHidden = false
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.profilePic)") {
                            print("url",url)
                            thirdMemberImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                    }
                }
                else if index == 3 {
                    if member.profilePic == "" {
                        //                                    fourthMemberView.isHidden = false
                        fourthMemberImage.isHidden = true
                        let firstName = member.firstName
                        let lastName = member.lastName
                        if firstName != "" && lastName != "" {
                            fourthMemberLabel.text = firstName.getFirstChar()+lastName.getFirstChar()
                        }
                        fourthMemberView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(member.color, alpha: 1.0)
                    }
                    else{
                        //                                    fourthMemberView.isHidden = true
                        fourthMemberImage.isHidden = false
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(member.profilePic)") {
                            print("url",url)
                            fourthMemberImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                    }
                }
            }
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
            eventStatusLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
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
}
