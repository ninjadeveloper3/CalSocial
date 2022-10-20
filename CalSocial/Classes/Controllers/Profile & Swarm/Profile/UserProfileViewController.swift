//
//  UserProfileViewController.swift
//  CalSocial
//
//  Created by DevBatch on 12/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper
import TwilioChatClient
import TwilioAccessManager

protocol UserProfileViewControllerDelegate {
    func didUpdateUserProfile()
}

class UserProfileViewController: UIViewController {
    
    //MARK: - Variables
    
    let userInfoCell = UserInfoTableViewCell.instanceFromNib()
    
    let viewHiveCell = ViewHiveTableViewCell.instanceFromNib()
    
    let settingCell = UserSettingsTableViewCell.instanceFromNib()
    
    var profileDatasouce =  Mapper<Profile>().map(JSON: [:])!
    
    var selectedContact = [BizeeContactsRequestModel]()
    
    var eventDataSource = [BizeeEventData]()
    
    var userId = 0
    
    var userName = ""
    
    var firstName = ""
    
    var fName = ""
    
    var lName = ""
    
    var isLoadData = false
    
    var inHive = false
    
    var canIvited = 1
    
    var barButton = UIBarButtonItem()
    
    var profileType: ProfileType = .UserProfile
    
    var delegate: UserProfileViewControllerDelegate?
    
    var isPerformedAction = false

    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        self.title = self.userName
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)) )
        barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "More"), style: .plain, target: self, action: #selector(menuButtonTapped(sender:)) )
        self.navigationItem.rightBarButtonItem = barButton
        if canIvited == 0 {
            userInfoCell.eventIcon.isHidden = true
            userInfoCell.eventLabel.isHidden = true
            userInfoCell.eventButton.isHidden = true
        }
        else{
            userInfoCell.eventIcon.isHidden = false
            userInfoCell.eventLabel.isHidden = false
            userInfoCell.eventButton.isHidden = false
        }
        
        doGetUserProfile()
        getUserEvents()
        userInfoCell.delegate = self
    }
    
    //MARK:- Private Methods
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            if self.isPerformedAction {
                self.delegate?.didUpdateUserProfile()
            }
        }
    }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        
        
        if profileType == .InHive {
        
            let alert = UIAlertController.init(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
            var addAction = UIAlertAction()
            var removeAction = UIAlertAction()
            if self.profileDatasouce.isFavourite == 1 {
                addAction = UIAlertAction(title: "Remove from favorites", style: UIAlertAction.Style.default) { (action) in
                    self.doUnFavourite(id: self.profileDatasouce.id,type: "Hive")
                }
            }
            else{
                addAction = UIAlertAction(title: "Add to your favorites", style: UIAlertAction.Style.default) { (action) in
                    self.doFavourite(id: self.profileDatasouce.id,type: "Hive")
                }
            }
            
            removeAction = UIAlertAction(title: "Remove from hive", style: UIAlertAction.Style.default) { (action) in
                self.removeFromHive()
            }
            
            let blockAction = UIAlertAction(title: "Block", style: UIAlertAction.Style.destructive) {
                (action) in
                
                self.doBlockThisUser()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            alert.addAction(addAction)
            alert.addAction(removeAction)
            alert.addAction(blockAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
        
        if profileType == .AddHive {

            let alert = UIAlertController.init(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)

            let blockAction = UIAlertAction(title: "Block", style: UIAlertAction.Style.destructive) {
                (action) in
                
                self.doBlockThisUser()
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            alert.addAction(blockAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
        
        if profileType == .AcceptDecline {
            
            let alert = UIAlertController.init(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
            
            let blockAction = UIAlertAction(title: "Block", style: UIAlertAction.Style.destructive) {
                (action) in
                
                self.doBlockThisUser()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            alert.addAction(blockAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
            
        }
        
        if profileType == .RequestSent {
            
            let alert = UIAlertController.init(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
            
            let blockAction = UIAlertAction(title: "Block", style: UIAlertAction.Style.destructive) {
                (action) in
                
                self.doBlockThisUser()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            alert.addAction(blockAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
            
        }
    }
    
    func removeFromHive(){
        APIClient.sharedClient.doRemoveFromMyHive(userId: self.profileDatasouce.id){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
            }
            else{
                self.dismiss(animated: true, completion: {
                    self.delegate?.didUpdateUserProfile()
                })
            }
        }
    }
    
    func doBlockThisUser(){
        APIClient.sharedClient.doBlockUser(userId: self.profileDatasouce.id){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
            }
            else{
                NotificationCenter.default.post(name: Notification.Name("UpdateHiveList"), object: nil, userInfo: nil)
                self.dismiss(animated: true, completion: {
                    self.delegate?.didUpdateUserProfile()
                })
            }
        }
    }
    
    func doFavourite(id: Int,type: String){
        APIClient.sharedClient.setFavorite(id: id, type: type){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
            }
            else{
                NSError.showErrorWithMessage(message: message ?? "Added to your favourites", viewController: self, type: .success, isNavigation: false)
                self.isPerformedAction = true
        
            }
        }
    }
    
    func doUnFavourite(id: Int,type: String){
        APIClient.sharedClient.doUnFavourite(userId: id, type: type){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
            }
            else{
                NSError.showErrorWithMessage(message: message ?? "Added to your favourites", viewController: self, type: .success, isNavigation: false)
                self.isPerformedAction = true
            }
        }
    }
    
    func doGetUserProfile(){
        APIClient.sharedClient.getUserProfile(userId: userId){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
            }
            else{
                self.isLoadData = true
                if let data = Mapper<Profile>().map(JSONObject: result) {
                    
                    self.profileDatasouce = data
                    print("data",self.profileDatasouce)
                    if self.profileDatasouce.profilePic == "" || self.profileDatasouce.profilePic == nil {
                        self.userInfoCell.emptyImageView.isHidden = false
                        self.userInfoCell.emptyImageLabelText.text = self.fName.getFirstChar()+self.lName.getFirstChar()
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func sendHiveRequest(){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.sendBizeeRequest(contactsList: selectedContact){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            }
            else{
                self.doGetUserProfile()
            }
        }
    }
    
    func actionOnRequest(type: Int){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.addToHive(userId: self.profileDatasouce.id,type: type){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            }
            else{
                self.doGetUserProfile()
            }
        }
    }
    
    func getUserEvents() {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getUserEvents(userId: self.userId) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                
            } else {
                if let data = Mapper<BizeeEventData>().mapArray(JSONObject: result) {
                    self.eventDataSource = data
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func createNewEvent() {
        let userDatasource = Mapper<BizeeUserModel>().map(JSON: [:])!
        let hiveModel = Mapper<HiveModel>().map(JSON: [:])!
        hiveModel.hiveMember.id = self.userId
        userDatasource.hives.append(hiveModel)
        let newEventViewController = EventFormViewController()
        let newEventNavigationController = UINavigationController()
        newEventNavigationController.setupAppThemeNavigationBar()
        newEventViewController.userContactDataSource = userDatasource
        newEventViewController.titleReload = true
        if profileType == .InHive {
        newEventViewController.withNonHive = false
        }
        else{
        newEventViewController.withNonHive = true
        }
        newEventViewController.inMyHive = true
        newEventNavigationController.viewControllers = [newEventViewController]
        self.present(newEventNavigationController, animated: true, completion: nil)
    }
}

extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoadData {
            return 4
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoadData{
            if section == 0 {
                return 1
            }
            if section == 1 {
                if self.profileDatasouce.bucketItems.count <= 5 {
                return self.profileDatasouce.bucketItems.count
                }
                else{
                    return 5
                }
                
            }
            if section == 2 {
                return self.eventDataSource.count
            }
            if section == 3 {
                return 1
            }
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let profileCell = userInfoCell
            profileCell.delegate = self
            
            profileCell.address.text = "\(profileDatasouce.address != "" ? profileDatasouce.address : "No Address")"
            profileCell.bio.text = profileDatasouce.bio != "" ? profileDatasouce.bio : "No Bio provided"
            if self.profileDatasouce.profilePic == "" {
                profileCell.emptyImageView.isHidden = false
                let fname = self.profileDatasouce.fname.getFirstChar()
                let lname = self.profileDatasouce.lname.getFirstChar()
                if fname != "" {
                    profileCell.emptyImageLabelText.text = fname+lname
                }
                
            }
            else{
                profileCell.emptyImageView.isHidden = true
                if let url = URL(string: "\(kImageDownloadBaseUrl)\(self.profileDatasouce.profilePic)") {
                    print("url",url)
                    profileCell.profileImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                }
            }
            if self.profileDatasouce.status == 2 {
                profileCell.statusButton.isHidden = true
                profileCell.requestAcceptButton.isHidden = false
                profileCell.requestDeclineButton.isHidden = false
            }
            else{
                profileCell.statusButton.isHidden = false
                profileCell.requestAcceptButton.isHidden = true
                profileCell.requestDeclineButton.isHidden = true
                profileCell.messageIcon.isHidden = false
                profileCell.messageLabel.isHidden = false
                var status = self.profileDatasouce.status
                if inHive {
                    status = 1
                    
                }
                if self.profileDatasouce.status == 1 {
                    profileType = .InHive
                }
                profileCell.setStatus(status: status)
            }
            userInfoCell.delegate = self
            return userInfoCell
        }
        
        if indexPath.section == 1 {
            let bucketCell = BucketTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            if self.profileDatasouce.bucketItems.count > 0 {
            bucketCell.bucketItemLabel.text = self.profileDatasouce.bucketItems[indexPath.row].value
            }
            return bucketCell
        }
        
        if indexPath.section == 2 {
            
            
            let swarmEventCell = SwarmEventTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            if self.eventDataSource[indexPath.row].swarms.members.count != 0 {
                swarmEventCell.initData(dataSource: self.eventDataSource[indexPath.row],dateFormat: false)
                return swarmEventCell
            }
            else{
                let eventCell = EventTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                eventCell.initData(dataSource: self.eventDataSource[indexPath.row],dateFormat: true)
                return eventCell
            }
        }
        if indexPath.section == 3 {
            viewHiveCell.viewHiveLabel.text = "View "+firstName+"'s Hive"
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
            label.text = "\(self.firstName)'s Bucket List"
            backGView.backgroundColor = UIColor.white
            backGView.addSubview(label)
            return backGView
        }
        
        if section > 1 {
            
            let backView = UIView(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width-25, height: 30))
            let borderView = UIView(frame: CGRect(x: 20, y: 15, width: tableView.frame.size.width-25, height: 0.5))
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
        
        if indexPath.section == 3 {
            let hiveListViewController = HiveListViewController()
            hiveListViewController.userId = self.profileDatasouce.id
            hiveListViewController.userName = self.profileDatasouce.fname+" "+self.profileDatasouce.lname
            hiveListViewController.fName = self.fName
            hiveListViewController.lName = self.lName
            
            self.navigationController?.pushViewController(hiveListViewController, animated: true)
        
        }
        
        if indexPath.section == 2 {
            let newEventViewController = EventOwnerViewController()
            let newEventNavigationController = UINavigationController()
            newEventNavigationController.setupAppThemeNavigationBar()
            newEventViewController.id = self.eventDataSource[indexPath.row].id
            newEventViewController.eventTitle = self.eventDataSource[indexPath.row].title
            newEventNavigationController.viewControllers = [newEventViewController]
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.present(newEventNavigationController, animated: true, completion: nil)
            }
        }
    }
}

extension UserProfileViewController : UserInfoTableViewCellDelegate{
    func didTappedMessageButton(cell: UserInfoTableViewCell) {
        Utility.showLoading(viewController: self)
        MessagingManager.sharedManager().chatClientDelegate = self
        let user = Mapper<AttMember>().map(JSON: [:])!
        user.id = userId
        user.name = userName
        user.picture = self.profileDatasouce.profilePic
        MessagingManager.sharedManager().setUpChannels(users: [user, Utility.getUserModel()], viewController: self)
    }
    
    func didTappedCreateEventButton() {
        createNewEvent()
    }
    
    
    func didClickStatusButton(cell: UserInfoTableViewCell,request: String) {
        
        if (self.profileDatasouce.status == 0){ //Add to Hive
            let contactObject = Mapper<BizeeContactsRequestModel>().map(JSON: [:])!
            contactObject.id = self.profileDatasouce.id
            selectedContact.append(contactObject)
            sendHiveRequest()
        }
        if (self.profileDatasouce.status == 1){ //User is in your Hive
            
        }
        if (self.profileDatasouce.status == 2){ //request received
            if request == "Accept" {
                actionOnRequest(type: 1)
            }
            else{
                actionOnRequest(type: 0)
            }
            
        }
        if (self.profileDatasouce.status == 3){ //request already sent
            
        }
    }
}

extension UserProfileViewController: MessagingManagerDelegate {
   
    func didNotDeleteChannel() {
        
    }
    
    func didDeleteChannel(client: TwilioChatClient) {
        
    }
    
    func didGetChatList(client: TwilioChatClient) {
        print("Channel Update")
    }
    
    func didGetMessagesList(message: [TCHMessage]) {
        
    }
    
    func didListMessage(message: TCHMessage) {
        
    }
    
    func didJoinChannel(channel: TCHChannel) {
        Utility.hideLoading(viewController: self)
        let navigationViewController = UINavigationController()
        let messageViewController = NewMessageViewController()
        navigationViewController.setupAppThemeNavigationBar()
        messageViewController.channel = channel
        messageViewController.title = String().getChatTitle(attributes: channel.attributes()!)
        messageViewController.chatMembersDataSource = attributesMembers(attributes: channel.attributes()!)
        navigationViewController.viewControllers = [messageViewController]
        self.present(navigationViewController, animated: true, completion: nil)
    }
    
    func attributesMembers(attributes: [String:Any]) -> [AttMember] {
        var chatMembers = [AttMember]()
        chatMembers.removeAll()
        if let members = attributes["members"] as? [[String:Any]] {
            for member in members {
                let chatMember = Mapper<AttMember>().map(JSON: [:])!
                chatMember.id = (member["id"] as? Int)!
                chatMember.name = (member["name"] as? String)!
                chatMember.picture = (member["picture"] as? String)!
                chatMembers.append(chatMember)
            }
        }
        chatMembers = chatMembers.removingDuplicates(byKey: { $0.id })
        return chatMembers
    }
}
