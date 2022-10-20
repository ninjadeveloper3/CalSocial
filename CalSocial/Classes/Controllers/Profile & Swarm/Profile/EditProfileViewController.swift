//
//  EditProfileViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 01/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class EditProfileViewController: UIViewController {
    
    //MARK: - Variables
    
    var inputCounter = 1
    
    var profile = Mapper<Profile>().map(JSON: [:])!
    
    var bucket = [Profile]()
    
    var pickerController = UIImagePickerController()
    
    var imageHolder = UIImage()
    
    var isProfileImageUpdated = false
    
    var isCamera = false
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var EditProfileCollectionView: UICollectionView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var imagePlaceholderName: UILabel!
    
    @IBOutlet weak var emptyImageView: HMView!
    
    @IBOutlet weak var profilePicView: HMView!
    
    
    
    
    @IBOutlet weak var NameInput: BUITextField!{
        didSet{
            NameInput.setupPadding()
        }
    }
    
    @IBOutlet weak var LocationInput: BUITextField!{
        didSet{
            LocationInput.setupPadding()
        }
    }
    @IBOutlet weak var BucketOneInput: BUITextField!{
        didSet{
            BucketOneInput.setupPadding()
        }
    }
    
    @IBOutlet weak var BucketTwoInput: BUITextField!{
        didSet {
            BucketTwoInput.setupPadding()
        }
    }
    
    @IBOutlet weak var BucketThreeInput: BUITextField!{
        didSet {
            BucketThreeInput.setupPadding()
        }
    }
    
    @IBOutlet weak var addInputOne: BUITextField!{
        didSet {
            addInputOne.setupPadding()
        }
    }
    
    @IBOutlet weak var addInputTwo: BUITextField!{
        didSet {
            addInputTwo.setupPadding()
        }
    }
    
    @IBOutlet weak var BioInputTextField: UITextView!{
        didSet{
            BioInputTextField.placeholder = "A little bit about yourself..."
        }
    }
    
    @IBOutlet weak var bioOuterView: UIView!
    
    @IBOutlet weak var addButton: UIImageView!
    
    @IBOutlet weak var removeButton: UIImageView!
    
    
    //MARK : - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addInputOne.isHidden = true
        addInputTwo.isHidden = true
        removeButton.isHidden = true
        // Do any additional setup after loading the view.
        let selectImageViewGesture = UITapGestureRecognizer(target: self, action: #selector(selectImageViewTapped(sender:)))
        profilePicView.addGestureRecognizer(selectImageViewGesture)
        setUpViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        self.navigationItem.title = "Edit Profile"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(doneButtonTapped(sender:)))
        self.navigationItem.leftBarButtonItem?.setFontStyle()
        self.navigationItem.rightBarButtonItem?.setBoldFontStyle()
        
        let addImageViewGesture = UITapGestureRecognizer(target: self, action: #selector(addImageViewGesture(sender:)))
        addButton.addGestureRecognizer(addImageViewGesture)
        
        let removeImageViewGesture = UITapGestureRecognizer(target: self, action: #selector(removeImageViewGesture(sender:)))
        removeButton.addGestureRecognizer(removeImageViewGesture)
        
        setProfileData()
        
    }
    
    //MARK:- IBActions
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doneButtonTapped(sender: UIBarButtonItem) {
        
        if NameInput.text!.isEmpty{
            NSError.showErrorWithMessage(message: "Name cannot be empty!", viewController: self, type: .error, isNavigation: false)
            return
        }
//        if LocationInput.text!.isEmpty{
//            NSError.showErrorWithMessage(message: "Location cannot be empty!", viewController: self, type: .error, isNavigation: false)
//            return
//        }
        if BioInputTextField.text!.isEmpty{
            NSError.showErrorWithMessage(message: "Bio cannot be empty!", viewController: self, type: .error, isNavigation: false)
            return
        }
        
        var bucketList = [String]()
        
        if BucketOneInput.text != "" {
            bucketList.append(BucketOneInput.text!)
        }
        if BucketTwoInput.text != "" {
            bucketList.append(BucketTwoInput.text!)
        }
        if BucketThreeInput.text != "" {
            bucketList.append(BucketThreeInput.text!)
        }
        if addInputOne.text != "" {
            bucketList.append(addInputOne.text!)
        }
        if addInputTwo.text != "" {
            bucketList.append(addInputTwo.text!)
        }
        
        Utility.showLoading(viewController: self)
        
        APIClient.sharedClient.updateProfile(name: NameInput.text!, address: LocationInput.text!, bio: BioInputTextField.text!, bucketList: bucketList){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            Utility.isProfileEdit = true
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
            
            } else {
                if self.isProfileImageUpdated {
                    self.updateProfileImage()
                    
                } else {
                    self.pop()
                }
            }
        }
    }
    
    @objc func addImageViewGesture(sender: UITapGestureRecognizer){
        switch inputCounter {
        case 1:
            addInputOne.isHidden = false
            inputCounter+=1
            removeButton.isHidden = false
//            addButton.image = #imageLiteral(resourceName: "minus")
        case 2:
            addInputTwo.isHidden = false
            inputCounter+=1
            removeButton.isHidden = false
//            addButton.image = #imageLiteral(resourceName: "minus")
        default:
            print("counter limit excedded!")
        }
    }
    
    @objc func removeImageViewGesture(sender: UITapGestureRecognizer){
        switch inputCounter {
        case 2:
            addInputOne.isHidden = true
            inputCounter-=1
            removeButton.isHidden = true
            addInputOne.text = ""
        //            addButton.image = #imageLiteral(resourceName: "minus")
        case 3:
            addInputTwo.isHidden = true
            inputCounter-=1
            addInputTwo.text = ""
        //            addButton.image = #imageLiteral(resourceName: "minus")
        default:
            print("counter limit excedded!")
        }
    }
    
    //MARK:- Private Methods
    
    func setProfileData(){
        NameInput.text = self.profile.fname+" "+self.profile.lname
        LocationInput.text = self.profile.address
        if self.profile.bio != "" {
            BioInputTextField.placeholder = ""
            BioInputTextField.text = self.profile.bio
        }
        if self.profile.profilePic == "" {
            emptyImageView.isHidden = false
            imagePlaceholderName.text = self.profile.fname.getFirstChar()+self.profile.lname.getFirstChar()
        }
        else{
            emptyImageView.isHidden = true
            if let url = URL(string: "\(kImageDownloadBaseUrl)\(self.profile.profilePic)") {
                print("url",url)
                profileImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                })
            }
        }
        for (index,_) in self.profile.bucketItems.enumerated() {
            if index == 0 {
                BucketOneInput.text =  self.profile.bucketItems[index].value
            }
            if index == 1 {
                BucketTwoInput.text =  self.profile.bucketItems[index].value
                
            }
            if index == 2 {
                BucketThreeInput.text =  self.profile.bucketItems[index].value
                
            }
            if index == 3 {
                addInputOne.isHidden = false
                inputCounter = 2
                addInputOne.text =  self.profile.bucketItems[index].value
                removeButton.isHidden = false
            }
            if index == 4 {
                addInputTwo.isHidden = false
                inputCounter = 3
                addInputTwo.text =  self.profile.bucketItems[index].value
                removeButton.isHidden = false
            }
        }
    }
    
    @objc func selectImageViewTapped(sender: UITapGestureRecognizer){
        
        let alert = UIAlertController.init(title: "Select your preferred image source",message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { (action) in
            self.pickerController.delegate = self
            self.pickerController.allowsEditing = true
            self.pickerController.sourceType = .camera
            self.isCamera = true
            self.present(self.pickerController, animated: true, completion: nil)
            
        }
        
        let gelleryAction = UIAlertAction(title: "Photo Library", style: UIAlertAction.Style.default) { (action) in
            self.pickerController.delegate = self
            self.pickerController.allowsEditing = true
            self.pickerController.sourceType = .photoLibrary
            self.isCamera = false
            self.present(self.pickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(gelleryAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func updateProfileImage(){
        Utility.showLoading(viewController: self)
        self.imageHolder = self.imageHolder.resized(withPercentage: 0.1)!
        APIClient.sharedClient.uploadProfileImage(image: self.imageHolder) { (success, response) in
            Utility.hideLoading(viewController: self)
            if success {
                NSError.showErrorWithMessage(message: "Profile Updated Successfully!", viewController: self, type: .success, isNavigation: true)
                Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.pop), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc func pop()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension EditProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let coverCell = CoverCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
        return coverCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 56 , height: 32)
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            print("image data")
            emptyImageView.isHidden = true
            self.profileImageView.image = image
            self.imageHolder = image
            self.isProfileImageUpdated = true
            pickerController.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picker canceled")
        pickerController.dismiss(animated: true, completion: nil)
    }
}
