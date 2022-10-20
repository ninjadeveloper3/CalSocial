//
//  TwoMembersCollectionViewCell.swift
//  CalSocial
//
//  Created by Moiz Amjad on 28/01/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import UIKit
protocol TwoMembersCollectionViewCellDelegate {
    func didLongPressTapped(cell: TwoMembersCollectionViewCell)
}

class TwoMembersCollectionViewCell: UICollectionViewCell {
    
    //MARK:- Variables
    
    var delegate: TwoMembersCollectionViewCellDelegate?
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var firstView: HMView!
    
    @IBOutlet weak var firstViewLabel: UILabel!
    
    @IBOutlet weak var firstViewImage: BUIImageView!
    
    
    @IBOutlet weak var secondView: HMView!
    
    @IBOutlet weak var secondViewLabel: UILabel!
    
    @IBOutlet weak var secondViewImage: BUIImageView!
    
    
    @IBOutlet weak var swarmTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        self.addGestureRecognizer(longPressGesture)
    }
    
    class func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> TwoMembersCollectionViewCell {
        let kTwoMembersCollectionViewCellIdentifier = "kTwoMembersCollectionViewCellIdentifier"
        collectionView.register(UINib(nibName: "TwoMembersCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kTwoMembersCollectionViewCellIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kTwoMembersCollectionViewCellIdentifier, for: indexPath) as! TwoMembersCollectionViewCell
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
