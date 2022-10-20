//
//  EditSwarmHeaderTableViewCell.swift
//  CalSocial
//
//  Created by DevBatch on 13/01/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import UIKit

protocol EditSwarmHeaderTableViewCellDelegate {
    func didColorTapped(colorCode: String)
    func didTapUploadCover()
}

class EditSwarmHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var swarmTitleTextField: BUITextField!{
        didSet {
            swarmTitleTextField.setupPadding()
        }
    }
    
    @IBOutlet weak var notesTextView: UITextView!
    
    var colorDataSource = [ColorModel]()
    
    var delegate: EditSwarmHeaderTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        selectionStyle = .none
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func uploadCoverTapped(_ sender: Any) {
        delegate?.didTapUploadCover()
    }
    
    
    class func instanceFromNib() -> EditSwarmHeaderTableViewCell {
        return UINib(nibName: "EditSwarmHeaderTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EditSwarmHeaderTableViewCell
    }
    
    func resetColorSelection(){
        for (index,_) in colorDataSource.enumerated() {
            colorDataSource[index].isSelected = false
        }
        collectionView.reloadData()
    }
    
    func initData(coverPhoto: String,selectedBackgroundColor: String,colors: [ColorModel], title: String, notes: String) {
        self.swarmTitleTextField.text = title
        self.notesTextView.text = notes
        self.colorDataSource = colors
        if coverPhoto != "" {
            if let url = URL(string: "\(kImageDownloadBaseUrl)\(coverPhoto)") {
                print("url",url)
                backgroundImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "loading-placeholder"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                })
            }
        }
        else{
            for color in self.colorDataSource {
                if color.colorCode == selectedBackgroundColor {
                    color.isSelected = true
                    backgroundImageView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(color.colorCode, alpha: 1.0)
                }
            }
        }
        self.collectionView.reloadData()
    }
}

extension EditSwarmHeaderTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let coverCell = CoverCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
        coverCell.colorBackView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(colorDataSource[indexPath.item].colorCode, alpha: 1.0)
        coverCell.checkMark.isHidden = !colorDataSource[indexPath.item].isSelected
        return coverCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        for (index,_) in colorDataSource.enumerated() {
            colorDataSource[index].isSelected = false
        }
        backgroundImageView.image =  UIImage()
        backgroundImageView.image = #imageLiteral(resourceName: "background")
        backgroundImageView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(colorDataSource[indexPath.row].colorCode, alpha: 1.0)
        colorDataSource[indexPath.row].isSelected = true
        delegate?.didColorTapped(colorCode: colorDataSource[indexPath.row].colorCode)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if colorDataSource[indexPath.row].isSelected {
            return CGSize(width: 56 , height: 40)
        } 
        return CGSize(width: 56 , height: 35)
    }
}
