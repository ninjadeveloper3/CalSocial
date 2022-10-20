//
//  GuestFormCollectionViewCell.swift
//  CalSocial
//
//  Created by Moiz Amjad on 05/11/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class GuestFormCollectionViewCell: UICollectionViewCell {

    //MARK:- Variables
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var profileImageView: BUIImageView!
    
    @IBOutlet weak var emptyView: HMView!
    
    @IBOutlet weak var emptyViewLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> GuestFormCollectionViewCell {
        let kGuestFormCollectionViewCellIdentifier = "kGuestFormCollectionViewCellIdentifier"
        collectionView.register(UINib(nibName: "GuestFormCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kGuestFormCollectionViewCellIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGuestFormCollectionViewCellIdentifier, for: indexPath) as! GuestFormCollectionViewCell
        
        return cell
    }
}
