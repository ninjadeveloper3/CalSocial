//
//  HiveListTableViewCell.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 03/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol HiveListTableViewCellDelegate {
    func didFinishTask(cell: HiveListTableViewCell)
}

class HiveListTableViewCell: UITableViewCell {

    //MARK: - IBOutlets

    
    @IBOutlet weak var requestLabel: UILabel!
    
    @IBOutlet weak var notHiveLabel: UILabel!
    
    @IBOutlet weak var contactImageView: BUIImageView!
    
    @IBOutlet weak var contactNameLabel: UILabel!
    
    @IBOutlet weak var hiveImageView: UIImageView!
    
    @IBOutlet weak var emptyImageView: HMView!
    
    @IBOutlet weak var emptyImageLabel: UILabel!
    
    
    var delegate : HiveListTableViewCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        requestLabel.isHidden = true
        let uploadGesture = UITapGestureRecognizer(target: self, action: #selector(requestSend(sender:)))
        hiveImageView.addGestureRecognizer(uploadGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func requestSend(sender: UITapGestureRecognizer){
        hiveImageView.isHidden = true
        requestLabel.isHidden = false
        notHiveLabel.isHidden = true
        delegate?.didFinishTask(cell: self)
    }
    
    func setStatus(status: Int) {
        
        if status == -1 { //You
            hiveImageView.isHidden = true
            requestLabel.isHidden = false
            requestLabel.text = "You"
            notHiveLabel.isHidden = true
            requestLabel.textColor = #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)
        }
        if status == 0 { //add to hive
            hiveImageView.isHidden = false
            hiveImageView.image = #imageLiteral(resourceName: "Create_Event")
            requestLabel.isHidden = true
        }
        if status == 1 { //in your hive
            hiveImageView.isHidden = true
            requestLabel.isHidden = false
            requestLabel.text = "In Hive"
            requestLabel.textColor = #colorLiteral(red: 0.9061171412, green: 0.6871158481, blue: 0.04991754144, alpha: 1)
            notHiveLabel.text = ""
        }
        if status == 2 {
            hiveImageView.isHidden = true
            requestLabel.isHidden = false
            requestLabel.text = "Request Received"
            requestLabel.textColor = #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)
        }
        if status == 3 {
            hiveImageView.isHidden = true
            requestLabel.isHidden = false
            requestLabel.text = "Invite Sent"
            requestLabel.textColor = #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)
            notHiveLabel.isHidden = true
        }
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> HiveListTableViewCell {
        let kHiveListTableViewCell = "kHiveListTableViewCell"
        tableView.register(UINib(nibName: "HiveListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kHiveListTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kHiveListTableViewCell, for: indexPath) as! HiveListTableViewCell
        return cell
    }
    
}
