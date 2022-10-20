//
//  CommentTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 04/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var commentTextLabel: UILabel!
    
    @IBOutlet weak var profileImageView: BUIImageView!
    
    @IBOutlet weak var emptyView: HMView!
    
    @IBOutlet weak var emptyViewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> CommentTableViewCell {
        let kCommentTableViewCell = "kCommentTableViewCell"
        tableView.register(UINib(nibName: "CommentTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kCommentTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kCommentTableViewCell, for: indexPath) as! CommentTableViewCell
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
