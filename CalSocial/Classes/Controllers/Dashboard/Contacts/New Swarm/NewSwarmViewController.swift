//
//  NewSwarmViewController.swift
//  CalSocial
//
//  Created by DevBatch on 01/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

protocol  NewSwarmViewControllerDelegate {
    func didCreateNewSwarm()
}

class NewSwarmViewController: UIViewController {
    
    //MARK: - Variables
    
    var pickerController = UIImagePickerController()
    
    var delegate: NewSwarmViewControllerDelegate?
    
    let headerCell = NewSwarmHeaderTableViewCell.instanceFromNib()
    
    let addMemberCell = NewSwarmAddMemberTableViewCell.instanceFromNib()
    
    var contactsDatasource = [HiveModel]()
    
    var swarmDataSource = Mapper<SwarmData>().map(JSON: [:])!
    
    var isLoadData = false
    
    var colorCode = ""
    
    var myProfilePic = ""
    
    var myFirstName = ""
    
    var myLastName = ""
    
    var imageHolder = [UIImage]()
    
    var isCreatingSwarm = false
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isLoadData {
            let index = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: index, at: .top, animated: true)
            
        }
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        self.navigationItem.title = "New Swarm"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(doneTapped(sender:)))
        self.navigationItem.leftBarButtonItem?.setFontStyle()
        self.navigationItem.rightBarButtonItem?.setBoldFontStyle()
        tableView.separatorStyle = .none
        getCoverColor()
        
//        UserDefaults.standard.set(self.profileDatasouce.profilePic, forKey: kUserProfileImageUrl)
//        UserDefaults.standard.set(self.profileDatasouce.fname, forKey: kUserFirstName)
//        UserDefaults.standard.set(self.profileDatasouce.lname, forKey: kUserLastName)
        
        if Utility.isKeyPresentInUserDefaults(key: kUserId) {
            if let profilePic  = UserDefaults.standard.object(forKey: kUserProfileImageUrl) as? String {
                self.myProfilePic = profilePic
            }
            if let myFirstname  = UserDefaults.standard.object(forKey: kUserFirstName) as? String {
                self.myFirstName = myFirstname
            }
            if let myLastname  = UserDefaults.standard.object(forKey: kUserLastName) as? String {
                self.myLastName = myLastname
            }
        }
    }
    
    //MARK: - Private Methods
    
    @objc func cancelTapped(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneTapped(sender: UIBarButtonItem) {
        
        
        if contactsDatasource.count > 0 {
            if !isCreatingSwarm {
                isCreatingSwarm = true
                Utility.showLoading(viewController: self)
                APIClient.sharedClient.createSwarm(title: headerCell.swarmTitleTextField.text!, aboutUs: headerCell.aboutUsTextView.text!, colorCode: self.colorCode, members: contactsDatasource) { (response, result, error, message) in
                    Utility.hideLoading(viewController: self)
                    self.isCreatingSwarm = false
                    if error != nil {
                        error?.showErrorBelowNavigation(viewController: self)
                        
                    } else {
                        if let data = Mapper<SwarmData>().map(JSONObject: result?["Swarm"]) {
                            self.swarmDataSource = data
                            if self.imageHolder.count > 0 {
                                self.doUploadSwarmCover(swarmId: self.swarmDataSource.id)
                            
                            } else {
                                self.dismiss(animated: true, completion: {
                                    self.delegate?.didCreateNewSwarm()
                                })
                            }
                        }
                    }
                }
            }
            
        } else {
            NSError.showErrorWithMessage(message: "Please add contacts to create swarm", viewController: self, type: .error, isNavigation: true)
        }
    }
    
    func doUploadSwarmCover(swarmId: Int){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.uploadSwarmCoverImage(image: self.imageHolder[0],swarmId: swarmId) { (success, response) in
            Utility.hideLoading(viewController: self)
            if success {
                NSError.showErrorWithMessage(message: "Submitted Successfully!", viewController: self, type: .success, isNavigation: true)
                self.dismiss(animated: true, completion: {
                    self.delegate?.didCreateNewSwarm()
                })
            }
        }
    }
    
    func getCoverColor() {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getCoverColors { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showServerErrorInViewController(self)
                
            } else {
                if let data = Mapper<ColorModel>().mapArray(JSONObject: result) {
                    self.isLoadData = true
                    if data.count > 0 {
                        self.colorCode = data[0].colorCode
                    }
                    self.headerCell.setColors(colors: data)
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension NewSwarmViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoadData {
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return contactsDatasource.count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            headerCell.delegate = self
            return headerCell
        }
        
        if indexPath.section == 2 {
            addMemberCell.delegate = self
            return addMemberCell
        }
        let cell = HiveListTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        if indexPath.row == 0 {
            cell.contactNameLabel.text = "You"
            cell.notHiveLabel.text = "Swarm Owner"
            cell.hiveImageView.isHidden = true
            if self.myProfilePic == "" {
                cell.emptyImageView.isHidden = false
                cell.emptyImageLabel.text = myFirstName.getFirstChar()+myLastName.getFirstChar()
                
            } else {
                cell.emptyImageView.isHidden = true
                if let url = URL(string: "\(kImageDownloadBaseUrl)\(self.myProfilePic)") {
                    print("url",url)
                    cell.contactImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                }
            }
            
        } else {
            cell.contactNameLabel.text = "\(contactsDatasource[indexPath.row-1].hiveMember.firstName) \(contactsDatasource[indexPath.row-1].hiveMember.lastName)"
            cell.notHiveLabel.text = ""
            cell.hiveImageView.isHidden = true
            //            cell.hiveImageView.isHidden = true
            
            
            if contactsDatasource[indexPath.row-1].hiveMember.profilePicture == "" {
                cell.emptyImageView.isHidden = false
                cell.emptyImageLabel.text = contactsDatasource[indexPath.row-1].hiveMember.firstName.getFirstChar()+contactsDatasource[indexPath.row-1].hiveMember.lastName.getFirstChar()
                
            } else {
                cell.emptyImageView.isHidden = true
                if let url = URL(string: "\(kImageDownloadBaseUrl)\(contactsDatasource[indexPath.row-1].hiveMember.profilePicture)") {
                    print("url",url)
                    cell.contactImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                }
            }
            
        }
        return cell
    }
}
extension NewSwarmViewController: NewSwarmAddMemberTableViewCellDelegate {
    func didTapAddMember() {
        let addguestViewController = addGuestViewController()
        addguestViewController.isMessage = true
        addguestViewController.delegate = self
        addguestViewController.selectedContacts = self.contactsDatasource
        self.navigationController?.pushViewController(addguestViewController, animated: true)
        
    }
}

extension NewSwarmViewController: addGuestViewControllerDelegate {
    func didAddUserContacts(userContacts: BizeeUserModel) {
        
    }
    
    func didAddContacts(contacts: [HiveModel]) {
        print(contacts.count)
        self.contactsDatasource.removeAll()
        self.contactsDatasource = contacts
        self.tableView.reloadData()
    }
}

extension NewSwarmViewController: NewSwarmHeaderTableViewCellDelegate {
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

extension NewSwarmViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
