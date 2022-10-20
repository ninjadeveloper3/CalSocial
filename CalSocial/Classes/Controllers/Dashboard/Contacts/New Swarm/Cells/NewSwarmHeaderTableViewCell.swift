//
//  NewSwarmHeaderTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 23/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

protocol NewSwarmHeaderTableViewCellDelegate {
    func didTapColor(color: ColorModel)
    func didTapUploadCover()
}

class NewSwarmHeaderTableViewCell: UITableViewCell {
    
    var colorDatasource = [ColorModel]()
    
    var delegate: NewSwarmHeaderTableViewCellDelegate?

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    @IBOutlet weak var swarmTitleTextField: BUITextField!{
        didSet{
            swarmTitleTextField.setupPadding()
        }
    }
    
    @IBOutlet weak var aboutUsTextView: UITextView!{
        didSet{
            aboutUsTextView.placeholder = "A brief description of your group..."
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        selectionStyle = .none
        colorDatasource.removeAll()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func instanceFromNib() -> NewSwarmHeaderTableViewCell {
        return UINib(nibName: "NewSwarmHeaderTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NewSwarmHeaderTableViewCell
    }
    
    func setColors(colors: [ColorModel]) {
        self.colorDatasource = colors
        if self.colorDatasource.count > 0 {
            self.colorDatasource[0].isSelected = true
            self.backgroundImageView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(colors[0].colorCode, alpha: 1.0)
        }
        colorCollectionView.reloadData()
    }
    
    @IBAction func uploadCuatomCoverPhoto(_ sender: Any) {
        
        delegate?.didTapUploadCover()        
    }
    func resetColorSelection(){
        for (index,_) in colorDatasource.enumerated() {
            colorDatasource[index].isSelected = false
        }
        colorCollectionView.reloadData()
    }
    
}


extension NewSwarmHeaderTableViewCell: UICollectionViewDelegateFlowLayout , UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorDatasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let coverCell = CoverCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
        coverCell.colorBackView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(colorDatasource[indexPath.item].colorCode, alpha: 1.0)
        coverCell.checkMark.isHidden = !colorDatasource[indexPath.item].isSelected
        return coverCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if colorDatasource[indexPath.item].isSelected {
            return CGSize(width: 56 , height: 40)
        }
        return CGSize(width: 56 , height: 32)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        for (index,_) in colorDatasource.enumerated() {
            colorDatasource[index].isSelected = false
        }
        delegate?.didTapColor(color: colorDatasource[indexPath.row])
        backgroundImageView.image = UIImage()
        backgroundImageView.image = #imageLiteral(resourceName: "background")
        backgroundImageView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(colorDatasource[indexPath.row].colorCode, alpha: 1.0)
        colorDatasource[indexPath.row].isSelected = true
        colorCollectionView.reloadData()
    }
}
