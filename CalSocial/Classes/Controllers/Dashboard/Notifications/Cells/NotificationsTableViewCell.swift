//
//  NotificationsTableViewCell.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 02/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var dotsView: HMView!
    
    @IBOutlet weak var displayPicture: BUIImageView!
    
    @IBOutlet weak var emptyImageView: HMView!
    
    @IBOutlet weak var emptyImageText: UILabel!
    
    @IBOutlet weak var rightArrowImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> NotificationsTableViewCell {
        let kNotificationsTableViewCell = "kNotificationsTableViewCell"
        tableView.register(UINib(nibName: "NotificationsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kNotificationsTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kNotificationsTableViewCell, for: indexPath) as! NotificationsTableViewCell
        return cell
    }
    
    func timeFormatter(rowDate: String) -> String {
        let timeFormatterGet = DateFormatter()
        timeFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let timeFormatterPrint = DateFormatter()
        timeFormatterPrint.dateFormat = "hh:mma"
        
        var formatedTime = ""
        
        if let time = timeFormatterGet.date(from: rowDate) {
            print(timeFormatterPrint.string(from: time))
            formatedTime = timeFormatterPrint.string(from: time)
        } else {
            print("There was an error decoding the string")
        }
        return formatedTime
    }
    
    func loadCell(dataSource: NotificationsModel) {
        var image = ""
        var name = ""
        self.title.text = dataSource.title
        self.messageLabel.text = dataSource.message
        rightArrowImageView.isHidden = false
        if dataSource.status == 1 {
            dotsView.isHidden = true
        }
        else{
            dotsView.isHidden = false
        }
        self.time.text = timeFormatter(rowDate: dataSource.createdAt)
        
        switch dataSource.notificationType{
        case 0:
            image = dataSource.hive.profilePicture
            name = dataSource.hive.firstName
            break;
            
        case 1:
            image = dataSource.event.coverPhoto
            name = dataSource.event.title
            
            break;
        case 2:
            rightArrowImageView.isHidden = true
            
            break;
        case 3:
            rightArrowImageView.isHidden = true
            break;
        case 4:
            if dataSource.swarm.count > 0 {
                image = dataSource.swarm[0].profilePicture
            }
            name = dataSource.title
            break;
        case 6:
            rightArrowImageView.isHidden = true
            break;
            
        case 8:
            image = dataSource.event.coverPhoto
            name = dataSource.event.title
            break;
            
        default:
            name = dataSource.title
            break
        }
        
        if image == "" {
            self.emptyImageView.isHidden = false
            let str = name
            if str != "" {
                self.emptyImageText.text = name.getFirstChar()
            }
            
        }
        else{
            self.emptyImageView.isHidden = true
            if let url = URL(string: "\(kImageDownloadBaseUrl)\(image)") {
                self.displayPicture.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                })
            }
        }
    }
}
