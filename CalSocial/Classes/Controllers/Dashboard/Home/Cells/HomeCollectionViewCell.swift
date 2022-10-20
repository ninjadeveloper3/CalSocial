//
//  HomeCollectionViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 01/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol HomeCollectionViewCellDelegate {
    func didLongPressTapped(cell: HomeCollectionViewCell)
}

class HomeCollectionViewCell: UICollectionViewCell {
    
    
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var firstView: HMView!
    
    @IBOutlet weak var firstViewLabel: UILabel!
    
    @IBOutlet weak var firstViewImage: BUIImageView!
    
    @IBOutlet weak var secondView: HMView!
    
    @IBOutlet weak var secondViewLabel: UILabel!
    
    @IBOutlet weak var secondViewImage: BUIImageView!
    
    @IBOutlet weak var thirdView: HMView!
    
    @IBOutlet weak var thirdViewLabel: UILabel!
    
    @IBOutlet weak var thirdViewImage: BUIImageView!
    
    @IBOutlet weak var forthView: HMView!
    
    @IBOutlet weak var forthViewLabel: UILabel!
    
    @IBOutlet weak var forthViewImage: BUIImageView!
    
    //MARK:- Variables
    
    var delegate: HomeCollectionViewCellDelegate?
    
    @IBOutlet weak var swarmTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        self.addGestureRecognizer(longPressGesture)
    }
    
    class func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> HomeCollectionViewCell {
        let kHomeCollectionViewCellIdentifier = "kHomeCollectionViewCellIdentifier"
        collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kHomeCollectionViewCellIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kHomeCollectionViewCellIdentifier, for: indexPath) as! HomeCollectionViewCell
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
