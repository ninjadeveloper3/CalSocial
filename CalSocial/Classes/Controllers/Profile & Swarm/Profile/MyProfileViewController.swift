//
//  MyProfileViewController.swift
//  CalSocial
//
//  Created by Moiz Amjad on 10/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireImage

class MyProfileViewController: UIViewController {
    
    //MARK-: Variables
    
    var barButton = UIBarButtonItem()
    
    let userInfoCell = MyUserTableViewCell.instanceFromNib()
    
    let viewHiveCell = ViewHiveTableViewCell.instanceFromNib()
    
    let settingCell = UserSettingsTableViewCell.instanceFromNib()
    
    var profileDatasouce =  Mapper<Profile>().map(JSON: [:])!
    
    var isLoadData = false
    
    //MARK-: IBActions
    
    @IBOutlet weak var bucketTableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        doGetMyProfile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Profile"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        barButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(menuButtonTapped(sender:)))
        self.navigationItem.rightBarButtonItem = barButton
        self.navigationItem.rightBarButtonItem?.setFontStyle()
        bucketTableView.separatorStyle = .none
        bucketTableView.delegate = self
        bucketTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.profile = self.profileDatasouce
        self.navigationController?.pushViewController(editProfileViewController, animated: true)
    }
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    func doGetMyProfile(){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getMyProfile(){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
            }
            else{
                self.isLoadData = true
                if let data = Mapper<Profile>().map(JSONObject: result) {
                    
                    self.profileDatasouce = data
                    print("data",self.profileDatasouce)
                    UserDefaults.standard.set(self.profileDatasouce.profilePic, forKey: kUserProfileImageUrl)
                    UserDefaults.standard.set(self.profileDatasouce.fname, forKey: kUserFirstName)
                    UserDefaults.standard.set(self.profileDatasouce.lname, forKey: kUserLastName)
                    self.bucketTableView.reloadData()
                }
            }
        }
    }
}

extension MyProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoadData {
            return 4
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoadData {
            if section == 0 {
                return 1
            }
            if section == 1 {
                return self.profileDatasouce.bucketItems.count
            }
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            if self.profileDatasouce.profilePic == "" {
                userInfoCell.emptyImageView.isHidden = false
                userInfoCell.imagePlaceholderName.text = self.profileDatasouce.fname.getFirstChar()+self.profileDatasouce.lname.getFirstChar()
                if Utility.isKeyPresentInUserDefaults(key: kUserColorCode) {
                    if let color = UserDefaults.standard.object(forKey: kUserColorCode) as? String {
                        userInfoCell.emptyImageView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(color, alpha: 1.0)
                    }
                    
                } else {
                    userInfoCell.emptyImageView.backgroundColor = UIColor.appThemeColor()
                }
            }
            else{
                userInfoCell.emptyImageView.isHidden = true
                if let url = URL(string: "\(kImageDownloadBaseUrl)\(self.profileDatasouce.profilePic)") {
                    print("url",url)
                    userInfoCell.profileImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                }
            }
            userInfoCell.fullName.text = self.profileDatasouce.fname+" "+self.profileDatasouce.lname
            userInfoCell.address.text = self.profileDatasouce.address != "" ? self.profileDatasouce.address : "No Address"
            userInfoCell.bio.text = self.profileDatasouce.bio != "" ? self.profileDatasouce.bio : "No Bio Added"
            return userInfoCell
        }
        
        if indexPath.section == 1 {
            let bucketCell = BucketTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            bucketCell.bucketItemLabel.text = self.profileDatasouce.bucketItems[indexPath.row].value
            return bucketCell
        }
        if indexPath.section == 2 {
            return viewHiveCell
        }
        return settingCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let backGView = UIView(frame: CGRect(x: 25, y: 0, width: tableView.frame.size.width-20, height: 40))
            let label =  UILabel(frame: CGRect(x: 25, y: 10, width: tableView.frame.size.width-20, height: 30))
            label.font = UIFont.montserratMedium(15.0)
            label.textColor = #colorLiteral(red: 0.3176162243, green: 0.317666769, blue: 0.3176051378, alpha: 1)
            label.text = "My Bucket List"
            backGView.backgroundColor = UIColor.white
            backGView.addSubview(label)
            return backGView
        }
        
        if section > 1 {
            let backView = UIView(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width-30, height: 30))
            let borderView = UIView(frame: CGRect(x: 15, y: 15, width: tableView.frame.size.width-30, height: 0.5))
            borderView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            backView.addSubview(borderView)
            return backView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40
        }
        if section > 1 {
            return 30
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            let hiveListViewController = HiveListViewController()
            hiveListViewController.userId = profileDatasouce.id
            hiveListViewController.userName = profileDatasouce.fname
            hiveListViewController.myHive = true
            self.navigationController?.pushViewController(hiveListViewController, animated: true)
        }
        if indexPath.section == 3 {
            let newEventViewController = SettingsViewController()
            let newEventNavigationController = UINavigationController()
            newEventNavigationController.setupAppThemeNavigationBar()
            newEventNavigationController.viewControllers = [newEventViewController]
            newEventViewController.userName = self.profileDatasouce.fname+" "+self.profileDatasouce.lname
            self.present(newEventNavigationController, animated: true, completion: nil)
        }
    }
}
