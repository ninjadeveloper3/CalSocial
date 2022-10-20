//
//  addGuestTableViewCell.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 01/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol addGuestTableViewCellDelegate {
    func didTapSelectButton(cell: addGuestTableViewCell)
}

class addGuestTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: BUIImageView!
    
    @IBOutlet weak var favouriteImage: UIImageView!
    
    @IBOutlet weak var contactNameLabel: UILabel!
    
    @IBOutlet weak var membersLabel: UILabel!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var emptyImageView: HMView!
    
    @IBOutlet weak var emptyImageLabelText: UILabel!
    
    var delegate : addGuestTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> addGuestTableViewCell {
        let kaddGuestTableViewCell = "kaddGuestTableViewCell"
        tableView.register(UINib(nibName: "addGuestTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kaddGuestTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kaddGuestTableViewCell, for: indexPath) as! addGuestTableViewCell
        return cell
    }
    
    func initCellData(dataSource: HiveModel) {
        contactNameLabel.text = "\(dataSource.hiveMember.firstName) \(dataSource.hiveMember.lastName)"
        favoriteHiveMemberCheck(isFavourite: dataSource.isFavourite)
        membersLabel.text = ""
        selectionMemberCheck(isSelected: dataSource.isSelected)
        if dataSource.hiveMember.profilePicture == "" {
            emptyImageView.isHidden = false
            emptyImageLabelText.text = dataSource.hiveMember.firstName.getFirstChar()+dataSource.hiveMember.lastName.getFirstChar()
            emptyImageView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(dataSource.hiveMember.color, alpha: 1.0)
        } else {
            emptyImageView.isHidden = true
            if let url = URL(string: "\(kImageDownloadBaseUrl)\(dataSource.hiveMember.profilePicture)") {
                profileImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                })
            
            } else {
                emptyImageView.isHidden = false
                emptyImageLabelText.text = dataSource.hiveMember.firstName.getFirstChar()
            }
        }
    }
    
    func initCellPhoneContactData(dataSource: PhoneContacts) {
        contactNameLabel.text = dataSource.name
        favoriteHiveMemberCheck(isFavourite: 0)
        membersLabel.text = "Will receive SMS invite"
        selectionMemberCheck(isSelected: dataSource.isSelected)
        emptyImageView.isHidden = false
        emptyImageLabelText.text = dataSource.name.getFirstChar()
        emptyImageView.backgroundColor = UIColor.appThemeColor()
    }
    
    func initCellSwarmData(dataSource: SwarmModel) {
        contactNameLabel.text = dataSource.swarm.title
        favoriteHiveMemberCheck(isFavourite: dataSource.isFavorites)
        if dataSource.swarm.swarmMembers.count > 0 {
            let members = dataSource.swarm.swarmMembers
            var nameOfMembers = ""
            for names in members {
                nameOfMembers = "\(names.firstName ), " + nameOfMembers
            }
            membersLabel.text = nameOfMembers
        }
        selectionMemberCheck(isSelected: dataSource.isSelected)
        emptyImageView.isHidden = false
        emptyImageLabelText.text = dataSource.swarm.title.getFirstChar()
        emptyImageView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(dataSource.swarm.backgroundColor, alpha: 1.0)
    }
    
    func initCellHiveData(dataSource: HiveModel) {
        contactNameLabel.text = "\(dataSource.hiveMember.firstName) \(dataSource.hiveMember.lastName)"
        favoriteHiveMemberCheck(isFavourite: dataSource.isFavourite)
        membersLabel.text = ""
        selectionMemberCheck(isSelected: dataSource.isSelected)
        if dataSource.hiveMember.profilePicture == "" {
            emptyImageView.isHidden = false
            emptyImageLabelText.text = dataSource.hiveMember.firstName.getFirstChar()+dataSource.hiveMember.lastName.getFirstChar()
            emptyImageView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(dataSource.hiveMember.color, alpha: 1.0)
        } else {
            emptyImageView.isHidden = true
            if let url = URL(string: "\(kImageDownloadBaseUrl)\(dataSource.hiveMember.profilePicture)") {
                profileImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                })
                
            } else {
                emptyImageView.isHidden = false
                emptyImageLabelText.text = dataSource.hiveMember.firstName.getFirstChar()
            }
        }
        
    }
    
    func favoriteHiveMemberCheck(isFavourite: Int) {
        if isFavourite == 1 {
        favouriteImage.isHidden = false
        }
        else{
        favouriteImage.isHidden = true
        }
    }
    
    func selectionMemberCheck(isSelected: Bool) {
        if !isSelected {
            selectedImageView.image = #imageLiteral(resourceName: "unselected")
            
        } else {
            selectedImageView.image = #imageLiteral(resourceName: "selected")
        }
    }
    
    @IBAction func selectionButtonTapped(_ sender: UIButton) {
        delegate?.didTapSelectButton(cell: self)
    }
}
