//
//  addGuestCollectionViewCell.swift
//  CalSocial
//
//  Created by Moiz Amjad on 09/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class addGuestCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    class func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> addGuestCollectionViewCell {
        let kaddGuestCollectionViewCellIdentifier = "kaddGuestCollectionViewCellIdentifier"
        collectionView.register(UINib(nibName: "addGuestCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kaddGuestCollectionViewCellIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kaddGuestCollectionViewCellIdentifier, for: indexPath) as! addGuestCollectionViewCell
        
        return cell
    }
}
