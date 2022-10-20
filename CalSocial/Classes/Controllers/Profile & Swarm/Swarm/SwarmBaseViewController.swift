 //
 //  SwarmBaseViewController.swift
 //  CalSocial
 //
 //  Created by DevBatch on 03/10/2019.
 //  Copyright © 2019 DevBatch. All rights reserved.
 //
 
 import UIKit
 import ObjectMapper
 import TwilioChatClient
 import TwilioAccessManager
 
 protocol SwarmBaseViewControllerDelegate {
    func didSwarmModifications()
    func didDeleteSwarm(swarmId : Int)
 }
 
 class SwarmBaseViewController: UIViewController {
    
    //MARK: - Variables
    
    var isAllMember = true
    
    var isAllEvents = true
    
    let headerCell = SwarmHeaderTableViewCell.instanceFromNib()
    
    let membersHeaderCell = MemberHeaderTableViewCell.instanceFromNib()
    
    let eventHeaderCell = EventsHeaderTableViewCell.instanceFromNib()
    
    var dataSource = Mapper<SwarmWithIdModel>().map(JSON: [:])!
    
    var eventsDataSource = [BizeeEventData]()
    
    var swarmId = 0
    
    var isLoadData = false
    
    var swarmTitle = ""
    
    var isFavourite = 0
    
    var roleId = 0
    
    var myId = 0
    
    var isPerformedAction = false
    
    var selectedContact = [BizeeContactsRequestModel]()
    
    var delegate : SwarmBaseViewControllerDelegate?
    
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
        getSwarmByIdApi()
        getMutualEvents()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        self.navigationItem.title = swarmTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "create-message-1"), style: .plain, target: self, action: #selector(addButtonTapped(sender:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        tableView.separatorStyle = .none
        
        if Utility.isKeyPresentInUserDefaults(key: kUserId){
            self.myId = UserDefaults.standard.object(forKey: kUserId) as! Int
        }
    }
    
    //MARK: - Private Methods
    
    @objc func addButtonTapped(sender: UIBarButtonItem) {
        let alert = UIAlertController.init(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        var addAction = UIAlertAction()
        var blockAction = UIAlertAction()
        
        if self.isFavourite == 1 {
            addAction = UIAlertAction(title: "Remove from favorites", style: UIAlertAction.Style.default) { (action) in
                self.doUnFavourite(id: self.swarmId,type: "Swarm")
            }
        }
        else{
            addAction = UIAlertAction(title: "Add to your favorites", style: UIAlertAction.Style.default) { (action) in
                self.doFavourite(id: self.swarmId,type: "Swarm")
            }
        }
        
        if roleId == 1 { //yor are the owner of this swarm
            blockAction = UIAlertAction(title: "Delete Swarm", style: UIAlertAction.Style.destructive) {
                (action) in
                let popUp = RemoveConfirmViewController()
                popUp.removal = .DeleteSwarm
                
                popUp.modalPresentationStyle = .overCurrentContext
                popUp.delegate = self
                self.present(popUp, animated: true, completion: nil)
            }
        }
        else{
            blockAction = UIAlertAction(title: "Leave Swarm", style: UIAlertAction.Style.destructive) {
                (action) in
                let popUp = RemoveConfirmViewController()
                popUp.removal = .LeaveSwarm
                
                popUp.modalPresentationStyle = .overCurrentContext
                popUp.delegate = self
                self.present(popUp, animated: true, completion: nil)
                
            }
        }
        
        
        let editSwarm = UIAlertAction(title: "Edit Swarm", style: UIAlertAction.Style.default) {
            (action) in
            
            var contactDataSource = [HiveModel]()
            
            for swarmMember in self.dataSource.swarmMembers {
                let contact = Mapper<HiveModel>().map(JSON: [:])!
                contact.id = swarmMember.memberId
                contact.hiveMember.id = swarmMember.user.id
                contact.hiveMember.firstName = swarmMember.user.firstName
                contact.hiveMember.lastName = swarmMember.user.lastName
                contact.hiveMember.profilePicture = swarmMember.user.profilePicture
                contact.hiveMember.phone = swarmMember.user.phone
                contact.isSelected = true
                contactDataSource.append(contact)
            }
            
            let editSwarmViewController = EditSwarmViewController()
            editSwarmViewController.swarmId = self.dataSource.id
            editSwarmViewController.swarmTitle = self.dataSource.title
            editSwarmViewController.swarmNotes = self.dataSource.aboutUs
            editSwarmViewController.coverPhoto = self.dataSource.coverPicture
            editSwarmViewController.selectedBackgroundColor = self.dataSource.backgroundColor
            editSwarmViewController.delegate = self
            var editContactDataSource = [HiveModel]()
            if contactDataSource.count > 0 {
                for (index,contacts) in contactDataSource.enumerated() {
                    if index != 0 {
                        editContactDataSource.append(contacts)
                    }
                }
                editSwarmViewController.contactsDataSource = editContactDataSource
            }
            let editNavigationController = UINavigationController()
            editNavigationController.setupAppThemeNavigationBar()
            editNavigationController.viewControllers = [editSwarmViewController]
            self.present(editNavigationController, animated: true, completion: nil)
        }
        
        
        //        let blockAction = UIAlertAction(title: "Leave Swarm", style: UIAlertAction.Style.destructive) {
        //            (action) in
        //        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        if roleId == 1 {
            alert.addAction(editSwarm)
        }
        alert.addAction(addAction)
        alert.addAction(blockAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            if self.isPerformedAction {
                self.delegate?.didSwarmModifications()
            }
        }
    }
    
    @objc func createNewEventButtonTapped(sender: UITapGestureRecognizer) {
        let userDatasource = Mapper<BizeeUserModel>().map(JSON: [:])!
        let swarm = Mapper<SwarmModel>().map(JSON: [:])!
        swarm.swarmId = self.swarmId
        
        for swarmMember in dataSource.swarmMembers {
            let tempSwarmMember = Mapper<SwarmMember>().map(JSON: [:])!
            tempSwarmMember.userId = swarmMember.user.id
            swarm.swarm.swarmMembers.append(tempSwarmMember)
        }
        
        userDatasource.swarms.append(swarm)
        let newEventViewController = EventFormViewController()
        let newEventNavigationController = UINavigationController()
        newEventNavigationController.setupAppThemeNavigationBar()
        newEventViewController.userContactDataSource = userDatasource
        newEventViewController.titleReload = true
        newEventViewController.isOneToOneEvent = true
        newEventNavigationController.viewControllers = [newEventViewController]
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.present(newEventNavigationController, animated: true, completion: nil)
        }
    }
    
    func getSwarmByIdApi(){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getSwarmById(swarmId: self.swarmId) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<SwarmWithIdModel>().map(JSONObject: result) {
                    self.isLoadData = true
                    self.dataSource = data
                    self.tableView.reloadData()
                    self.navigationItem.title = self.dataSource.title
                    self.tableView.reloadData()
                }
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
                self.isFavourite = 1
                self.tableView.reloadData()
            }
        }
    }
    
    func leaveGroup(id: Int) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.leaveSwarm(id: id) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.dismiss(animated: true){
                    self.delegate?.didSwarmModifications()
                }
            }
        }
    }
    
    func deleteSwarm(id: Int){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.deleteSwarm(id: id) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.dismiss(animated: true){
                    self.delegate?.didSwarmModifications()
                }
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
                self.isFavourite = 0
                self.tableView.reloadData()
            }
        }
    }
    
    func getMutualEvents() {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getMutualEvents(swarmId: swarmId) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<BizeeEventData>().mapArray(JSONObject: result) {
                    if data.count == 0 {
                        self.isAllEvents = false
                    }
                    self.eventsDataSource = data
                    self.tableView.reloadData()
                    
                } else {
                    self.isAllEvents = false
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func createNewEvent() {
        let userDatasource = Mapper<BizeeUserModel>().map(JSON: [:])!
        let swarm = Mapper<SwarmModel>().map(JSON: [:])!
        swarm.swarmId = self.swarmId
        for swarmMember in dataSource.swarmMembers {
            let tempSwarmMember = Mapper<SwarmMember>().map(JSON: [:])!
            tempSwarmMember.userId = swarmMember.user.id
            swarm.swarm.swarmMembers.append(tempSwarmMember)
        }
        userDatasource.swarms.append(swarm)
        let newEventViewController = EventFormViewController()
        let newEventNavigationController = UINavigationController()
        newEventNavigationController.setupAppThemeNavigationBar()
        newEventViewController.userContactDataSource = userDatasource
        newEventViewController.swarmTitle = dataSource.title
        newEventViewController.isSwarm = true
        newEventViewController.titleReload = true
        newEventViewController.isOneToOneEvent = true
        newEventNavigationController.viewControllers = [newEventViewController]
        self.present(newEventNavigationController, animated: true, completion: nil)
    }
    
    func sendHiveRequest(){
        APIClient.sharedClient.sendBizeeRequest(contactsList: selectedContact){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else{
                
            }
        }
    }
 }
 
 extension SwarmBaseViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoadData {
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
            
        } else if section == 1 {
            if isAllMember {
                return self.dataSource.swarmMembers.count + 1
                
            } else {
                if self.dataSource.swarmMembers.count > 0 {
                    return 2
                }
                return 0
            }
            
        } else if section == 2 {
            if isAllEvents {
                return self.eventsDataSource.count + 1
                
            } else {
                if self.eventsDataSource.count > 0 {
                    return 2
                }
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            headerCell.aboutUsLabel.text = dataSource.aboutUs
            headerCell.swarmTitleLabel.text = dataSource.title
            if self.isFavourite == 1 {
                headerCell.favStar.image = #imageLiteral(resourceName: "star")
            }
            else{
                headerCell.favStar.image = #imageLiteral(resourceName: "Favorite-F (1)")
            }
            
            headerCell.delegate = self
            if dataSource.coverPicture.isEmpty {
                headerCell.backgroundImageView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(dataSource.backgroundColor, alpha: 1.0)
                
            } else {
                headerCell.backgroundImageView.backgroundColor = .clear
                if let url = URL(string: "\(kImageDownloadBaseUrl)\(self.dataSource.coverPicture)") {
                    headerCell.backgroundImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "loading-placeholder"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                }
            }
            return headerCell
            
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                membersHeaderCell.delegate = self
                if self.dataSource.swarmMembers.count > 1 {
                    membersHeaderCell.noOfMembers.text = "\(self.dataSource.swarmMembers.count) Members"
                    
                } else {
                    membersHeaderCell.noOfMembers.text = "\(self.dataSource.swarmMembers.count) Member"
                }
                return membersHeaderCell
            }
            let cell = HiveListTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            let swarmInfo = dataSource.swarmMembers[indexPath.row-1]
            cell.delegate = self
            cell.contactNameLabel.text = "\(swarmInfo.user.firstName) \(swarmInfo.user.lastName)"
            if swarmInfo.role == .SwarmOwner {
                cell.notHiveLabel.text = "Swarm Owner"
                cell.hiveImageView.isHidden = true
                
            } else {
                if self.myId == swarmInfo.user.id {
                    swarmInfo.status = -1
                }
                cell.notHiveLabel.text = ""
                cell.setStatus(status: swarmInfo.status)
            }
            
            if swarmInfo.user.profilePicture == "" {
                cell.emptyImageView.isHidden = false
                if swarmInfo.user.firstName != "" && swarmInfo.user.lastName != "" {
                    cell.emptyImageLabel.text = swarmInfo.user.firstName.getFirstChar()+swarmInfo.user.lastName.getFirstChar()
                    cell.emptyImageView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(swarmInfo.user.color, alpha: 1.0)
                    
                } else {
                    cell.emptyImageLabel.text = "A"
                }
                
            } else {
                cell.emptyImageView.isHidden = true
                if let url = URL(string: "\(kImageDownloadBaseUrl)\(swarmInfo.user.profilePicture)") {
                    print("url",url)
                    cell.contactImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                }
            }
            return cell
            
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                eventHeaderCell.eventLabel.text = "\(self.eventsDataSource.count) Total Events Scheduled"
                eventHeaderCell.delegate = self
                return eventHeaderCell
            }
        }
        
        let swarmEventCell = SwarmEventTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        if self.eventsDataSource[indexPath.row - 1].swarms.members.count != 0 {
            swarmEventCell.initData(dataSource: self.eventsDataSource[indexPath.row - 1],dateFormat: false)
            return swarmEventCell
        }
        else{
            let cell = EventTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            cell.initData(dataSource: eventsDataSource[indexPath.row - 1],dateFormat: false)
            
            cell.setStatus(status: eventsDataSource[indexPath.row - 1].status)
            
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row > 0 {
                if self.myId != self.dataSource.swarmMembers[indexPath.row - 1].user.id {
                    let userProfileViewController = UserProfileViewController()
                    let profileNavigationController = UINavigationController()
                    profileNavigationController.setupAppThemeNavigationBar()
                    userProfileViewController.userId = self.dataSource.swarmMembers[indexPath.row - 1].memberId
                    userProfileViewController.userName = self.dataSource.swarmMembers[indexPath.row - 1].user.firstName+" "+self.dataSource.swarmMembers[indexPath.row - 1].user.lastName
                    userProfileViewController.firstName = self.dataSource.swarmMembers[indexPath.row - 1].user.firstName
                    
                    let status = self.dataSource.swarmMembers[indexPath.row - 1].status
                    if status == 0 { //add to hive
                        userProfileViewController.profileType = .AddHive
                    }
                    if status == 1 { //in your hive
                        userProfileViewController.profileType = .InHive
                    }
                    if status == 2 { //request received
                        userProfileViewController.profileType = .AcceptDecline
                    }
                    if status == 3 { //request Sent
                        userProfileViewController.profileType = .RequestSent
                    }
                    profileNavigationController.viewControllers = [userProfileViewController]
                    self.present(profileNavigationController, animated: true, completion: nil)
                }
            }
        }
        if indexPath.section == 2 {
            if indexPath.row > 0 {
                let index = self.eventsDataSource[indexPath.row-1]
                let newEventViewController = EventOwnerViewController()
                let newEventNavigationController = UINavigationController()
                newEventNavigationController.setupAppThemeNavigationBar()
                newEventViewController.id = index.id
                newEventViewController.eventTitle = index.title
                newEventNavigationController.viewControllers = [newEventViewController]
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.present(newEventNavigationController, animated: true, completion: nil)
                }
            }
        }
    }
 }
 
 extension SwarmBaseViewController: EventsHeaderTableViewCellDelegate {
    func didTapExpandButton() {
        isAllEvents = !isAllEvents
        eventHeaderCell.expandHide(isHide: isAllEvents)
        let indices: IndexSet = [2]
        if self.eventsDataSource.count > 1 {
            //            tableView.reloadSections(indices, with: .none)
            tableView.reloadData()
        }
    }
 }
 
 extension SwarmBaseViewController: MemberHeaderTableViewCellDelegate {
    func didTapExpandMemberButton() {
        isAllMember = !isAllMember
        membersHeaderCell.expandHide(isHide: isAllMember)
        let indices: IndexSet = [1]
        if self.dataSource.swarmMembers.count > 1 {
            //            tableView.reloadSections(indices, with: .none)
            tableView.reloadData()
        }
    }
 }
 
 extension SwarmBaseViewController: EditSwarmViewControllerDelegate {
    func didUpdateSwarm() {
        getSwarmByIdApi()
    }
    
    func didDeleteSwarm() {
        self.dismiss(animated: true) {
            self.delegate?.didDeleteSwarm(swarmId: self.dataSource.id)
        }
    }
 }
 
 extension SwarmBaseViewController: SwarmHeaderTableViewCellDelegate {
    func didTapCreateEvent() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.createNewEvent()
        }
    }
    
    func didTapMessage() {
        Utility.showLoading(viewController: self)
        MessagingManager.sharedManager().chatClientDelegate = self
        var swarmUsers = [AttMember]()
        swarmUsers.removeAll()
        for swarmMembers in dataSource.swarmMembers {
            let user = Mapper<AttMember>().map(JSON: [:])!
            user.id = swarmMembers.user.id
            user.name = "\(swarmMembers.user.firstName) \(swarmMembers.user.lastName)"
            user.picture = swarmMembers.user.profilePicture
            swarmUsers.append(user)
        }
        //        swarmUsers.append(Utility.getUserModel())
        MessagingManager.sharedManager().setUpChannels(users: swarmUsers, viewController: self)
        
    }
    
 }
 
 extension SwarmBaseViewController: confirmPopUpSelectionDelegate {
    func didSelectOption(selection: Bool) {
        if selection {
            self.dismiss(animated: true, completion: nil)
            if roleId == 1 {
                self.deleteSwarm(id: self.swarmId)
            }
            else{
                self.leaveGroup(id: self.swarmId)
            }
            
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
 }
 
 extension SwarmBaseViewController : HiveListTableViewCellDelegate{
    func didFinishTask(cell: HiveListTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let contactObject = Mapper<BizeeContactsRequestModel>().map(JSON: [:])!
            contactObject.id = self.dataSource.swarmMembers[indexPath.row - 1].memberId
            selectedContact.append(contactObject)
            sendHiveRequest()
        }
    }
 }
 
 extension SwarmBaseViewController : MessagingManagerDelegate {
    
    func didNotDeleteChannel() {
        
    }
    
    func didDeleteChannel(client: TwilioChatClient) {
        
    }
    
    func didGetChatList(client: TwilioChatClient) {
        
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
