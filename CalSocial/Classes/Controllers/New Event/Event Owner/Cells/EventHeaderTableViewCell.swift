//
//  EventHeaderTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 08/01/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

protocol EventHeaderTableViewCellDelegate {
    func didSelectUserProfile(index: Int)
    func didTapIgnoreButton()
    func didTapDontJoinButton()
    func didTapMaybeButton()
    func didTapJoinButton()
}

class EventHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    @IBOutlet weak var eventDateLabel: UILabel!
    
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    @IBOutlet weak var eventAddressLabel: UILabel!
    
    @IBOutlet weak var hostNotesLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var inviteMemeberLabel: UILabel!
    
    @IBOutlet weak var goingMembersLabel: UILabel!
    
    @IBOutlet weak var maybeMemberLabel: UILabel!
    
    @IBOutlet weak var notGoingLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var statsStackView: UIStackView!
    
    @IBOutlet weak var ownerProfileImageView: BUIImageView!
    
    @IBOutlet weak var backgroundImageViewConstranit: NSLayoutConstraint!
    
    @IBOutlet weak var ignoreButton: MBButton!
    
    @IBOutlet weak var dontJoinButton: MBButton!
    
    @IBOutlet weak var maybeButton: MBButton!
    
    @IBOutlet weak var joinButton: MBButton!
    
    @IBOutlet weak var userStatusLabel: UILabel!
    
    @IBOutlet weak var statsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var responseButtonStackHeight: NSLayoutConstraint!
    
    @IBOutlet weak var responseButtonStack: UIStackView!
    
    @IBOutlet weak var unreadCommentDot: HMView!
    
    var dataSource = Mapper<EventDetailsModel>().map(JSON: [:])!
    
    var isLoadData = false
    
    var userId = 0
    
    var delegate : EventHeaderTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        selectionStyle = .none
        
        if Utility.isKeyPresentInUserDefaults(key: kUserId){
            self.userId = UserDefaults.standard.object(forKey: kUserId) as! Int
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    class func instanceFromNib() -> EventHeaderTableViewCell {
        return UINib(nibName: "EventHeaderTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventHeaderTableViewCell
    }
    
    func initData(dataSource: EventDetailsModel) {
        self.dataSource = dataSource
        eventTitleLabel.text = self.dataSource.eventDetails.title
        eventAddressLabel.text = self.dataSource.eventDetails.location
        hostNotesLabel.text = self.dataSource.eventDetails.notes
        inviteMemeberLabel.text = "\(self.dataSource.allData.invited)"
        goingMembersLabel.text = "\(self.dataSource.allData.going)"
        notGoingLabel.text = "\(self.dataSource.allData.notGoing)"
        maybeMemberLabel.text = "\(self.dataSource.allData.maybe)"
        
        
        if dataSource.isOwner == 1 {
            responseButtonStackHeight.constant = 0
            responseButtonStack.isHidden = true
        }
        
        if dataSource.isConflict == 1 { // Conflict
            userStatusLabel.text = "Conflict! View in Agenda"
            userStatusLabel.textColor = #colorLiteral(red: 0.8274844289, green: 0.379353106, blue: 0.209089905, alpha: 1)
            
        } else if dataSource.isConflict == 0 { // Avaiable
            userStatusLabel.text = "Available!"
            userStatusLabel.textColor = #colorLiteral(red: 0.6772228479, green: 0.7539524436, blue: 0.3781521022, alpha: 1)
            
        } else if dataSource.status != 3 {
            userStatusLabel.isHidden = true
        }
        
        if dataSource.status == 2 { // Maybe
            maybeButton.layer.borderWidth = 2
            joinButton.layer.borderWidth = 0
            dontJoinButton.layer.borderWidth = 0
            maybeButton.layer.borderColor = #colorLiteral(red: 0.6391444206, green: 0.6392566562, blue: 0.6391373277, alpha: 1)
            userStatusLabel.isHidden = true
            
        } else if dataSource.status == 1 { // Join
            maybeButton.layer.borderWidth = 0
            joinButton.layer.borderWidth = 2
            dontJoinButton.layer.borderWidth = 0
            joinButton.layer.borderColor = #colorLiteral(red: 0.6772228479, green: 0.7539524436, blue: 0.3781521022, alpha: 1)
            userStatusLabel.isHidden = true
            
        } else if dataSource.status == 0 { //Didnt Join
            maybeButton.layer.borderWidth = 0
            joinButton.layer.borderWidth = 0
            dontJoinButton.layer.borderWidth = 2
            dontJoinButton.layer.borderColor = #colorLiteral(red: 0.819499433, green: 0.3834590018, blue: 0.2093472481, alpha: 1)
            userStatusLabel.isHidden = true
        
        } else {
            maybeButton.layer.borderWidth = 0
            joinButton.layer.borderWidth = 0
            dontJoinButton.layer.borderWidth = 0
        }
        
        if dataSource.eventDetails.eventMembers.count > 2 {
            let myNormalAttributedTitle = NSAttributedString(string: "Maybe",
                                                             attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6391444206, green: 0.6392566562, blue: 0.6391373277, alpha: 1)])
            maybeButton.setAttributedTitle(myNormalAttributedTitle, for: .normal)
        }
        
        
        if dataSource.eventDetails.eventMembers.count <= 2 {
            statsStackView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            statsStackView.isHidden = true
            statsHeight.constant = 0
        }
        
        if dataSource.eventDetails.ownerImage != "" {
            if let url = URL(string: "\(kImageDownloadBaseUrl)\(dataSource.eventDetails.ownerImage)") {
                print("url",url)
                ownerProfileImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                })
            }
        }
        
        let stringDateFormatter = DateFormatter()
        stringDateFormatter.dateFormat = "yyyy-MM-dd"
        let date = stringDateFormatter.date(from: dataSource.eventDetails.eventDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let modifiedDate = dateFormatter.string(from: date ?? Date())
        eventDateLabel.text = modifiedDate
        
        
        let stringTimeFormatter = DateFormatter()
        stringTimeFormatter.dateFormat = "HH:mm:ss"
        let startTime = stringTimeFormatter.date(from: dataSource.eventDetails.startTime)!
        let endTime = stringTimeFormatter.date(from: dataSource.eventDetails.endTime)!
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mma"
        let modifiedStartTime = timeFormatter.string(from: startTime)
        let modifiedEndTime = timeFormatter.string(from: endTime)
        eventTimeLabel.text = "\(modifiedStartTime) - \(modifiedEndTime)"
        
        if dataSource.eventDetails.coverPicture != "" {
            if let url = URL(string: "\(kImageDownloadBaseUrl)\(dataSource.eventDetails.coverPicture)") {
                print("url",url)
                backgroundImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "loading-placeholder"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                })
            }
            
        } else {
            backgroundImageViewConstranit.constant = 0
            backgroundImageView.isHidden = true
        }
        self.isLoadData = true
        collectionView.reloadData()
    }
    
    @IBAction func ignoreButtonTapped(_ sender: Any) {
        delegate?.didTapIgnoreButton()
    }
    
    @IBAction func dontJoinButtonTapped(_ sender: Any) {
        delegate?.didTapDontJoinButton()
    }
    
    @IBAction func maybeButtonTapped(_ sender: Any) {
        delegate?.didTapMaybeButton()
    }
    
    @IBAction func joinButtonTapped(_ sender: Any) {
        delegate?.didTapJoinButton()
    }
    
}

extension EventHeaderTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoadData {
            return self.dataSource.eventDetails.eventMembers.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let guestCell = GuestCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
        guestCell.delegate = self
        
        if dataSource.eventDetails.eventMembers[indexPath.item].role == 1 && dataSource.eventDetails.eventMembers[indexPath.item].userId == self.userId{
            guestCell.nameLabel.text = "You"
            guestCell.noSyncLabel.isHidden = false
            guestCell.progressBarView.isHidden = true
            guestCell.statusDot.isHidden = true
            guestCell.noSyncLabel.text = "Host"
            
            if dataSource.eventDetails.eventMembers[indexPath.item].profilePicture == "" {
                guestCell.emptyView.isHidden = false
                guestCell.emptyViewLabel.text = dataSource.eventDetails.eventMembers[indexPath.item].firstName.getFirstChar()+dataSource.eventDetails.eventMembers[indexPath.item].lastName.getFirstChar()
                guestCell.emptyView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha( dataSource.eventDetails.eventMembers[indexPath.item].color, alpha: 1.0)
            }
            else{
                guestCell.emptyView.isHidden = true
                if let url = URL(string: "\(kImageDownloadBaseUrl)\(dataSource.eventDetails.eventMembers[indexPath.item].profilePicture)") {
                    print("url",url)
                    guestCell.profileImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                }
            }
            
            guestCell.initData(profilePic: dataSource.eventDetails.eventMembers[indexPath.item].profilePicture, fname: dataSource.eventDetails.eventMembers[indexPath.item].firstName,lname: dataSource.eventDetails.eventMembers[indexPath.item].lastName, color: dataSource.eventDetails.eventMembers[indexPath.item].color)
        }
        else{
            
            
            if dataSource.eventDetails.eventMembers[indexPath.item].role == 1 {
                guestCell.noSyncLabel.isHidden = false
                guestCell.progressBarView.isHidden = true
                guestCell.noSyncLabel.text = "Host"
                guestCell.statusDot.isHidden = true
            
            } else {
                guestCell.noSyncLabel.isHidden = true
                guestCell.progressBarView.isHidden = true
                guestCell.statusDot.isHidden = false
                let status = dataSource.eventDetails.eventMembers[indexPath.item].going
                guestCell.statusDot.borderWidth = 0
                switch status {
                case 1:
//                    guestCell.noSyncLabel.textColor = #colorLiteral(red: 1, green: 0.7616637349, blue: 0.04396914691, alpha: 1)
//                    guestCell.noSyncLabel.text = "Joined"
                    guestCell.statusDot.backgroundColor = #colorLiteral(red: 0.6808918118, green: 0.7444447875, blue: 0.378949523, alpha: 1)
                case 2:
//                    guestCell.noSyncLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
//                    guestCell.noSyncLabel.text = "Maybe"
                    guestCell.statusDot.backgroundColor = #colorLiteral(red: 0.6391582489, green: 0.6392524838, blue: 0.6391376853, alpha: 1)
                    
                case 3:
//                    guestCell.noSyncLabel.textColor = #colorLiteral(red: 0.6391582489, green: 0.6392524838, blue: 0.6391376853, alpha: 1)
//                    guestCell.noSyncLabel.text = "Waiting"
                    
                    guestCell.statusDot.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    guestCell.statusDot.borderWidth = 0.8
                    guestCell.statusDot.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                

                default:
//                    guestCell.noSyncLabel.textColor = #colorLiteral(red: 0.4391747713, green: 0.4392418265, blue: 0.4391601086, alpha: 1)
//                    guestCell.noSyncLabel.text = "didn't join"
                    
                    guestCell.statusDot.backgroundColor = #colorLiteral(red: 0.8290296793, green: 0.3805963993, blue: 0.205390662, alpha: 1)
                    
                }
            }
            
            guestCell.nameLabel.text = "\(dataSource.eventDetails.eventMembers[indexPath.item].firstName)"
            guestCell.initData(profilePic: dataSource.eventDetails.eventMembers[indexPath.item].profilePicture, fname: dataSource.eventDetails.eventMembers[indexPath.item].firstName,lname: dataSource.eventDetails.eventMembers[indexPath.item].lastName, color: dataSource.eventDetails.eventMembers[indexPath.item].color)
        }
        return guestCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.dataSource.eventDetails.eventMembers[indexPath.item].isBizee {
            delegate?.didSelectUserProfile(index: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 76 , height: 104)
    }
}

extension EventHeaderTableViewCell : GuestCollectionViewCellDelegate {
    func didLongPressTapped(cell: GuestCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            if self.dataSource.eventDetails.eventMembers[indexPath.item].isBizee {
                delegate?.didSelectUserProfile(index: indexPath.item)
            }
        }
    }
}
