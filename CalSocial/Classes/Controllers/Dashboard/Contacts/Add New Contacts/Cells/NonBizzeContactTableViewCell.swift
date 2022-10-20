//
//  NonBizzeContactTableViewCell.swift
//  Bizze
//
//  Created by DevBatch on 02/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol NonBizzeContactTableViewCellDelegate {
    func didFinishTask(cell: NonBizzeContactTableViewCell)
}

class NonBizzeContactTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets

    @IBOutlet weak var uploadIconBtn: UIButton!
    
    @IBOutlet weak var requestSendLabel: UILabel!
    
    @IBOutlet weak var contactNameLabel: UILabel!
    
    @IBOutlet weak var emptyImageView: HMView!
    
    @IBOutlet weak var emptyImageViewText: UILabel!
    
    @IBOutlet weak var profileImageView: BUIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    //MARK: - Variables
    
    var delegate : NonBizzeContactTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        requestSendLabel.isHidden = true
        let uploadGesture = UITapGestureRecognizer(target: self, action: #selector(requestSend(sender:)))
        uploadIconBtn.addGestureRecognizer(uploadGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func requestSend(sender: UITapGestureRecognizer){
        print("Clicked")
        delegate?.didFinishTask(cell: self)
    }
    
    func setStatus(status: Int,type: String) {
        
        if status == 0 { //add to hive
            uploadIconBtn.isHidden = false
            uploadIconBtn.setImage(#imageLiteral(resourceName: "Bubble select gold"), for: .normal)
            requestSendLabel.isHidden = true
            statusLabel.text = ""
        
        } else if status == 1 { //in your hive
            statusLabel.text = ""
            uploadIconBtn.isHidden = true
            requestSendLabel.isHidden = false
            requestSendLabel.text = "In Hive"
            requestSendLabel.textColor = #colorLiteral(red: 0.9061171412, green: 0.6871158481, blue: 0.04991754144, alpha: 1)
        
        } else if status == 2 {
            statusLabel.text = ""
            uploadIconBtn.isHidden = true
            requestSendLabel.isHidden = false
            requestSendLabel.text = "Request Received"
        
        } else if status == 3 {
            uploadIconBtn.isHidden = true
            requestSendLabel.isHidden = false
            if type == "nonBizee" {
                requestSendLabel.text = "Invite Sent"
            
            } else {
                requestSendLabel.text = "Request Sent"
            }
            statusLabel.text = ""
            
        } else {
            uploadIconBtn.isHidden = false
            uploadIconBtn.setImage(#imageLiteral(resourceName: "Share"), for: .normal)
            requestSendLabel.isHidden = true
            statusLabel.text = "I don't have Bizee"
        }
    }
    
    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> NonBizzeContactTableViewCell {
        let kNonBizzeContactTableViewCell = "kNonBizzeContactTableViewCell"
        tableView.register(UINib(nibName: "NonBizzeContactTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kNonBizzeContactTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: kNonBizzeContactTableViewCell, for: indexPath) as! NonBizzeContactTableViewCell
        return cell
    }
    
}
