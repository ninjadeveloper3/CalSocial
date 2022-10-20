//
//  GuestCollectionViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 30/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import GTProgressBar

protocol GuestCollectionViewCellDelegate {
    func didLongPressTapped(cell: GuestCollectionViewCell)
}

class GuestCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var progressBarView: GTProgressBar!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var profileImageView: BUIImageView!
    
    @IBOutlet weak var emptyView: HMView!
    
    @IBOutlet weak var emptyViewLabel: UILabel!
    
    @IBOutlet weak var noSyncLabel: UILabel!
    
    @IBOutlet weak var statusDot: HMView!
    
    
    
    var delegate: GuestCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        progressBarView.displayLabel = false
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        self.addGestureRecognizer(longPressGesture)
    }
    
    func initData(profilePic: String, fname: String,lname: String, color: String) {
        if profilePic == "" {
            emptyView.isHidden = false
            emptyViewLabel.text = fname.getFirstChar()+lname.getFirstChar()
            emptyView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha( color, alpha: 1.0)
        }
        else{
            emptyView.isHidden = true
            if let url = URL(string: "\(kImageDownloadBaseUrl)\(profilePic)") {
                print("url",url)
                profileImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                })
            }
        }
    }
    
    
    class func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> GuestCollectionViewCell {
        let kGuestCollectionViewCellIdentifier = "kGuestCollectionViewCellIdentifier"
        collectionView.register(UINib(nibName: "GuestCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kGuestCollectionViewCellIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGuestCollectionViewCellIdentifier, for: indexPath) as! GuestCollectionViewCell
        
        return cell
    }
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }
        delegate?.didLongPressTapped(cell: self)
        print("Long Press")
    }

}
