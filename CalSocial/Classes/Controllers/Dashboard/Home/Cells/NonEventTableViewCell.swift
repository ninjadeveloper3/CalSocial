//
//  NonEventTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 02/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class NonEventTableViewCell: UITableViewCell {

    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    @IBOutlet weak var dividerView: UIView!
    
    @IBOutlet weak var allDayView: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> NonEventTableViewCell {
        let kNonEventTableViewCell = "kNonEventTableViewCell"
        tableView.register(UINib(nibName: "NonEventTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kNonEventTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kNonEventTableViewCell, for: indexPath) as! NonEventTableViewCell
        return cell
    }
    
    func initData(dataSource: PhoneEventData) {
        
        if dataSource.allDay == 1 {
            startTimeLabel.isHidden = true
            endTimeLabel.isHidden = true
            dividerView.isHidden = true
            allDayView.isHidden = false
        }
        else{
            startTimeLabel.isHidden = false
            endTimeLabel.isHidden = false
            dividerView.isHidden = false
            allDayView.isHidden = true
            
            startTimeLabel.text = Date().covertTimeFormat(time: dataSource.startTime)
            endTimeLabel.text = Date().covertTimeFormat(time: dataSource.endTime)
        }
        
        
        eventTitleLabel.text = dataSource.title
    }
}
