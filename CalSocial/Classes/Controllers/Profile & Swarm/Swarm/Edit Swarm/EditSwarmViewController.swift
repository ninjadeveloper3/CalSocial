//
//  EditSwarmViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 03/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

protocol EditSwarmViewControllerDelegate {
    
    func didUpdateSwarm()
    func didDeleteSwarm()
}

class EditSwarmViewController: UIViewController {
    
    //MARK: - Variables
    
    var delegate: EditSwarmViewControllerDelegate?
    
    var pickerController = UIImagePickerController()
    
    var colorDataSource = [ColorModel]()
    
    var contactsDataSource = [HiveModel]()
    
    let headerCell = EditSwarmHeaderTableViewCell.instanceFromNib()
    
    let buttonCell = EditSwarmButtonsTableViewCell.instanceFromNib()
    
    var swarmTitle = ""
    
    var swarmNotes = ""
    
    var isLoadData = false
    
    var colorCode = ""
    
    var selectedBackgroundColor = ""
    
    var swarmId = 0
    
    var coverPhoto = ""
    
    var imageHolder = [UIImage]()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var membersTableView: UITableView!
    
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isLoadData {
        let index = IndexPath(row: 0, section: 0)
        membersTableView.scrollToRow(at: index, at: .top, animated: true)
        }
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        membersTableView.delegate = self
        membersTableView.dataSource = self
        membersTableView.separatorStyle = .none
        
        self.navigationItem.title = "Edit Swarm"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(doneTapped(sender:)))
        self.navigationItem.leftBarButtonItem?.setFontStyle()
        self.navigationItem.rightBarButtonItem?.setBoldFontStyle()
        getCoverColor()
    }
    
    //MARK: - Private Methods
    
    @objc func cancelTapped(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneTapped(sender: UIBarButtonItem) {
        editSwarm()
    }
    
    func getCoverColor() {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getCoverColors { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<ColorModel>().mapArray(JSONObject: result) {
                    self.colorDataSource = data
                    self.headerCell.initData(coverPhoto: self.coverPhoto,selectedBackgroundColor: self.selectedBackgroundColor,colors: self.colorDataSource, title: self.swarmTitle, notes: self.swarmNotes)
                    self.isLoadData = true
                    self.colorCode = self.colorDataSource[0].colorCode
                    self.membersTableView.reloadData()
                }
            }
        }
    }
    
    func editSwarm() {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.editSwarm(swarmId: swarmId, title: headerCell.swarmTitleTextField.text!, aboutUs: headerCell.notesTextView.text!, colorCode: colorCode, members: self.contactsDataSource) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                
                if self.imageHolder.count > 0 {
                    self.doUploadSwarmCover(swarmId: self.swarmId)
                }
                else{
                    self.dismiss(animated: true, completion: {
                        self.delegate?.didUpdateSwarm()
                    })
                }
                
            }
        }
    }
    func doUploadSwarmCover(swarmId: Int){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.uploadSwarmCoverImage(image: self.imageHolder[0],swarmId: swarmId) { (success, response) in
            Utility.hideLoading(viewController: self)
            if success {
//                NSError.showErrorWithMessage(message: "Submitted Successfully!", viewController: self, type: .success, isNavigation: true)
                self.dismiss(animated: true, completion: {
                    self.delegate?.didUpdateSwarm()
                })
            }
        }
    }
    
}
extension EditSwarmViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoadData {
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoadData {
            if section == 0 {
                return 1
                
            } else if section == 1 {
                return self.contactsDataSource.count + 1
            }
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            headerCell.delegate = self
            return headerCell
            
        } else if indexPath.section == 1 {
            let contactCell = EditSwarmTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            if indexPath.row == 0 {
                
                if contactsDataSource[indexPath.row].hiveMember.profilePicture == "" {
                    contactCell.emptyView.isHidden = false
                    contactCell.emptyView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(contactsDataSource[indexPath.row].hiveMember.color, alpha: 1.0)
                    contactCell.emptyViewLabel.text = contactsDataSource[indexPath.row].hiveMember.firstName.getFirstChar()+contactsDataSource[indexPath.row].hiveMember.lastName.getFirstChar()
                    
                    
                } else {
                    contactCell.emptyView.isHidden = true
                    if let url = URL(string: "\(kImageDownloadBaseUrl)\(contactsDataSource[indexPath.row].hiveMember.profilePicture)") {
                        print("url",url)
                        contactCell.profilePicView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                        })
                    }
                }
                
                contactCell.contactNameLabel.text = "You"
                contactCell.deleteIconButton.isHidden = true
            
            } else {
                
                if contactsDataSource[indexPath.row - 1].hiveMember.profilePicture == "" {
                    contactCell.emptyView.isHidden = false
                    contactCell.emptyViewLabel.text = contactsDataSource[indexPath.row - 1].hiveMember.firstName.getFirstChar()+contactsDataSource[indexPath.row - 1].hiveMember.lastName.getFirstChar()
                    
                } else {
                    contactCell.emptyView.isHidden = true
                    if let url = URL(string: "\(kImageDownloadBaseUrl)\(contactsDataSource[indexPath.row - 1].hiveMember.profilePicture)") {
                        print("url",url)
                        contactCell.profilePicView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                        })
                    }
                }
                
                contactCell.contactNameLabel.text = "\(contactsDataSource[indexPath.row - 1].hiveMember.firstName) \(contactsDataSource[indexPath.row - 1].hiveMember.lastName)"
            }
            contactCell.delegate = self
            return contactCell
        }
        buttonCell.delegate = self
        return buttonCell
    }
}

extension EditSwarmViewController: EditSwarmTableViewCellDelegate {
    func didDeleteButtonTapped(cell: EditSwarmTableViewCell) {
        if let index = membersTableView.indexPath(for: cell) {
            self.contactsDataSource.remove(at: index.row - 1)
            self.membersTableView.reloadData()
        }
    }
}

extension EditSwarmViewController: EditSwarmButtonsTableViewCellDelegate {
    func didAddMemberButtonTapped() {
        let addguestViewController = addGuestViewController()
        addguestViewController.delegate = self
        addguestViewController.selectedContacts = self.contactsDataSource
        self.navigationController?.pushViewController(addguestViewController, animated: true)
    }
    
    func didDeleteSwarmButtonTapped() {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.deleteSwarm(id: swarmId) { (response, result, error, messagw) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.dismiss(animated: true, completion: {
                    self.delegate?.didDeleteSwarm()
                })
            }
        }
    }
}

extension EditSwarmViewController: addGuestViewControllerDelegate {
    func didAddContacts(contacts: [HiveModel]) {
        self.contactsDataSource = contacts
        self.membersTableView.reloadData()
    }
    
    func didAddUserContacts(userContacts: BizeeUserModel) {
        
    }
}

extension EditSwarmViewController: EditSwarmHeaderTableViewCellDelegate {
    
    func didColorTapped(colorCode: String) {
        self.colorCode = colorCode
    }
}

extension EditSwarmViewController: NewSwarmHeaderTableViewCellDelegate {
    func didTapUploadCover() {
        let alert = UIAlertController.init(title: "Select your preferred image source",message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { (action) in
            self.pickerController.delegate = self
            self.pickerController.allowsEditing = false
            self.pickerController.sourceType = .camera
            self.present(self.pickerController, animated: true, completion: nil)
            
        }
        
        let gelleryAction = UIAlertAction(title: "Photo Library", style: UIAlertAction.Style.default) { (action) in
            self.pickerController.delegate = self
            self.pickerController.allowsEditing = false
            self.pickerController.sourceType = .photoLibrary
            self.present(self.pickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(gelleryAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func didTapColor(color: ColorModel) {
        self.imageHolder = [UIImage]()
        self.colorCode = color.colorCode
        
    }
    
}

extension EditSwarmViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            print("image data")
            headerCell.backgroundImageView.image = image
            self.imageHolder = [image]
            pickerController.dismiss(animated: true, completion: nil)
            headerCell.resetColorSelection()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picker canceled")
        pickerController.dismiss(animated: true, completion: nil)
    }
}
