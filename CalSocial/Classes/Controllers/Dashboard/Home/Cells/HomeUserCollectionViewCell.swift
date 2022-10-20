//
//  HomeUserCollectionViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 08/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol HomeUserCollectionViewCellDelegate {
    func didLongPressTapped(cell: HomeUserCollectionViewCell)
}

class HomeUserCollectionViewCell: UICollectionViewCell {
    
    //MARK:- Variables
    
    var delegate: HomeUserCollectionViewCellDelegate?
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var emptyView: HMView!
    
    @IBOutlet weak var emptyViewLabel: UILabel!
    
    @IBOutlet weak var profileImageView: BUIImageView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        self.addGestureRecognizer(longPressGesture)
        profileImageView.contentMode = .scaleAspectFill
    }
    
    class func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> HomeUserCollectionViewCell {
        let kHomeUserCollectionViewCellIdentifier = "kHomeUserCollectionViewCellIdentifier"
        collectionView.register(UINib(nibName: "HomeUserCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kHomeUserCollectionViewCellIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kHomeUserCollectionViewCellIdentifier, for: indexPath) as! HomeUserCollectionViewCell
        return cell
    }
    
    func initData() {
        
    }
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }
        delegate?.didLongPressTapped(cell: self)
        print("Long Press")
    }
}
