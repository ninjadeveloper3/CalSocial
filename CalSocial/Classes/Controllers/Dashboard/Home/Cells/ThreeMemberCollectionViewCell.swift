//
//  ThreeMemberCollectionViewCell.swift
//  CalSocial
//
//  Created by Moiz Amjad on 28/01/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import UIKit

protocol ThreeMemberCollectionViewCellDelegate {
    func didLongPressTapped(cell: ThreeMemberCollectionViewCell)
}

class ThreeMemberCollectionViewCell: UICollectionViewCell {

    
    var delegate: ThreeMemberCollectionViewCellDelegate?
    
    @IBOutlet weak var firstView: HMView!
    
    @IBOutlet weak var firstViewLabel: UILabel!
    
    @IBOutlet weak var firstViewImage: BUIImageView!
    
    
    @IBOutlet weak var secondView: HMView!
    
    @IBOutlet weak var secondViewLabel: UILabel!
    
    @IBOutlet weak var secondViewImage: BUIImageView!
    
    
    @IBOutlet weak var thirdView: HMView!
    
    @IBOutlet weak var thirdViewLabel: UILabel!
    
    @IBOutlet weak var thirdViewImage: BUIImageView!
    
    
    
    @IBOutlet weak var swarmTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        self.addGestureRecognizer(longPressGesture)
    }
    
    class func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> ThreeMemberCollectionViewCell {
        let kThreeMemberCollectionViewCellIdentifier = "kThreeMemberCollectionViewCellIdentifier"
        collectionView.register(UINib(nibName: "ThreeMemberCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kThreeMemberCollectionViewCellIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kThreeMemberCollectionViewCellIdentifier, for: indexPath) as! ThreeMemberCollectionViewCell
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
