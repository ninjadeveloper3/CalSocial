//
//  CoverCollectionViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 30/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class CoverCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var colorBackView: HMView!
    
    @IBOutlet weak var checkMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> CoverCollectionViewCell {
        let kCoverCollectionViewCellIdentifier = "kCoverCollectionViewCellIdentifier"
        collectionView.register(UINib(nibName: "CoverCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kCoverCollectionViewCellIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCoverCollectionViewCellIdentifier, for: indexPath) as! CoverCollectionViewCell
        
        return cell
    }

}
