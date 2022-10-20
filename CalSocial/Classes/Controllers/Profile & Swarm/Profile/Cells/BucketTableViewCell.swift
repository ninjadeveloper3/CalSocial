//
//  BucketTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 03/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class BucketTableViewCell: UITableViewCell {
    
    //MARK:- IBOulets
    
    @IBOutlet weak var bucketItemLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> BucketTableViewCell {
        let kBucketTableViewCell = "kBucketTableViewCell"
        tableView.register(UINib(nibName: "BucketTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kBucketTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kBucketTableViewCell, for: indexPath) as! BucketTableViewCell
        return cell
    }
}
