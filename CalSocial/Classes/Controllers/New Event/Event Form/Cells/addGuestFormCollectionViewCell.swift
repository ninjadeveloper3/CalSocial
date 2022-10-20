//
//  addGuestFormCollectionViewCell.swift
//  CalSocial
//
//  Created by Moiz Amjad on 05/11/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class addGuestFormCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> addGuestFormCollectionViewCell {
        let kaddGuestFormCollectionViewCellIdentifier = "kaddGuestFormCollectionViewCellIdentifier"
        collectionView.register(UINib(nibName: "addGuestFormCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kaddGuestFormCollectionViewCellIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kaddGuestFormCollectionViewCellIdentifier, for: indexPath) as! addGuestFormCollectionViewCell
        
        return cell
    }
}
