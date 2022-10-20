//
//  SuggestionTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 24/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class SuggestionTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> SuggestionTableViewCell {
        let kSuggestionTableViewCell = "kSuggestionTableViewCell"
        tableView.register(UINib(nibName: "SuggestionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kSuggestionTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kSuggestionTableViewCell, for: indexPath) as! SuggestionTableViewCell
        return cell
    }
    
}
