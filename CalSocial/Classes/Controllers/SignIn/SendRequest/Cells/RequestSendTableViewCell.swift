//
//  RequestSendTableViewCell.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 30/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
protocol RequestSendTableViewCellDelegate {
    func contactTapped(cell: RequestSendTableViewCell, isContactSelected: Bool)
}
class RequestSendTableViewCell: UITableViewCell {
    
    //MARK: - Vaeriables
    
    var isContactSelected = false

    var delegate: RequestSendTableViewCellDelegate?

    //MARK: - IBOutlets
    
    @IBOutlet weak var radioButton: UIButton!
    
    @IBOutlet weak var contantNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> RequestSendTableViewCell {
        let kRequestSendTableViewCell = "kRequestSendTableViewCell"
        tableView.register(UINib(nibName: "RequestSendTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kRequestSendTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kRequestSendTableViewCell, for: indexPath) as! RequestSendTableViewCell
        return cell
    }
    
    @IBAction func radioButtonTapped(_ sender: UIButton) {
        
//        if sender.isSelected {
//            sender.isSelected = false
//            isContactSelected = false
//            sender.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
//
//        } else {
//            sender.isSelected = true
//            isContactSelected = true
//            sender.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
//        }
//        delegate?.contactTapped(cell: self, isContactSelected: isContactSelected)
    }
}
