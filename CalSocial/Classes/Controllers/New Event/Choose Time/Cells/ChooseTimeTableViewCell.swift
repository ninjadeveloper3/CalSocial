//
//  ChooseTimeTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 02/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

protocol  ChooseTimeTableViewCellDelegate {
    func contentUpdate(cell: ChooseTimeTableViewCell)
    func didUseButtonTapped(cell: ChooseTimeTableViewCell)
    
}

class ChooseTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var stack: UIStackView!
    
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var useButton: MBButton!
    
    @IBOutlet weak var expandCollapseButton: UIButton!
    
    @IBOutlet weak var borderCell: UIView!
    
    @IBOutlet weak var percentageLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var modifiedStartTime = ""
    
    var modifiedEndTime = ""
    
    var delegate: ChooseTimeTableViewCellDelegate?
    
    var cellDataSource = Mapper<EventData>().map(JSON: [:])!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
//        expandCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> ChooseTimeTableViewCell {
        let kChooseTimeTableViewCell = "kChooseTimeTableViewCell"
        tableView.register(UINib(nibName: "ChooseTimeTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kChooseTimeTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kChooseTimeTableViewCell, for: indexPath) as! ChooseTimeTableViewCell
        return cell
    }
    
    @IBAction func expandButtonTapped(_ sender: Any) {
        if stack.isHidden == false {
            collapseCell()
            delegate?.contentUpdate(cell: self)
            
        } else {
            expandCell()
            delegate?.contentUpdate(cell: self)
        }
    }
    
    func initCellData(dataSource: EventData) {
        self.cellDataSource = dataSource
        let stringDateFormatter = DateFormatter()
        stringDateFormatter.dateFormat = "yyyy-MM-dd"
        let date = stringDateFormatter.date(from: dataSource.eventDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let modifiedDate = dateFormatter.string(from: date ?? Date())
        dateLabel.text = modifiedDate
        
        let stringTimeFormatter = DateFormatter()
        stringTimeFormatter.dateFormat = "HH:mm:ss"
        let startTime = stringTimeFormatter.date(from: dataSource.startTime)!
        let endTime = stringTimeFormatter.date(from: dataSource.endTime)!
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mma"
        modifiedStartTime = timeFormatter.string(from: startTime)
        modifiedEndTime = timeFormatter.string(from: endTime)
        
        let percentage = Int(dataSource.score * 100)
        percentageLabel.text = "\(percentage)%"
        timeLabel.text = "\(modifiedStartTime) - \(modifiedEndTime)"
        if dataSource.guests.count > 0 {
            collectionView.reloadData()
        }
    }
    
    func expandCell() {
        expandCollapseButton.setImage(#imageLiteral(resourceName: "up arrow"), for: .normal)
        UIView.animate(withDuration: 0.0, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.cellHeight.constant = 190
            self.layoutIfNeeded()
        }, completion: { completed in
            self.stack.isHidden = false
        })
    }
    
    func collapseCell() {
        expandCollapseButton.setImage(#imageLiteral(resourceName: "Down arrow"), for: .normal)
        UIView.animate(withDuration: 0.0, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.cellHeight.constant = 61
            self.layoutIfNeeded()
        }, completion: { completed in
            self.stack.isHidden = true
        })
    }
    
    @IBAction func userButtonTapped(_ sender: Any) {
        delegate?.didUseButtonTapped(cell: self)
    }
}

extension ChooseTimeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellDataSource.guests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = GuestCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
        cell.nameLabel.text = cellDataSource.guests[indexPath.item].firstName
        cell.statusDot.isHidden = true
        cell.progressBarView.progress = CGFloat(cellDataSource.guests[indexPath.item].score)
        cell.initData(profilePic: cellDataSource.guests[indexPath.item].profilePicture, fname: cellDataSource.guests[indexPath.item].firstName,lname: cellDataSource.guests[indexPath.item].lastName, color: "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 76 , height: 104)
    }
}
