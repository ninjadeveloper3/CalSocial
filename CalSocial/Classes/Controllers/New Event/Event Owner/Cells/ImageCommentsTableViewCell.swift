//
//  ImageCommentsTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 04/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class ImageCommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var emptyView: HMView!
    
    @IBOutlet weak var emptyViewLabel: UILabel!
    
    @IBOutlet weak var profileImageView: BUIImageView!
    
    @IBOutlet weak var commentImageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> ImageCommentsTableViewCell {
        let kImageCommentsTableViewCell = "kImageCommentsTableViewCell"
        tableView.register(UINib(nibName: "ImageCommentsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kImageCommentsTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kImageCommentsTableViewCell, for: indexPath) as! ImageCommentsTableViewCell
        return cell
    }
    
    func getTimeInFormat(date: String) -> String {
        let stringDateFormatter = DateFormatter()
        stringDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = stringDateFormatter.date(from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        let modifiedDate = dateFormatter.string(from: date ?? Date())
        return modifiedDate
    }
}
