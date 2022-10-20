//
//  InboxViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 02/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import TwilioChatClient
import TwilioAccessManager
import ObjectMapper

class InboxViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var inboxTableView: UITableView!
    
    var chatClient : TwilioChatClient?
    
    var isLoadData = false
    
    var paginator : TCHChannelDescriptorPaginator?
    
    var channels = [TCHChannel]()
    
    var chatMembersDataSource  = [AttMember]()
    
    var userId = 0
    
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setUpViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.chatClient = MessagingManager.sharedManager().client
//        chatMembersDataSource.removeAll()
//        if self.chatClient == nil {
            loadData()
//        }
    }
    
    //MARK: - SetUp View Controller Methods
    
    func setUpViewController() {
        channels.removeAll()
        inboxTableView.delegate = self
        inboxTableView.dataSource = self
        inboxTableView.separatorStyle = .none
        
        self.navigationItem.title = "Messages"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "create-message"), style: .plain, target: self, action: #selector(newMessageButtonTapped(sender:)))
        connectChat()
    }
    
    func connectChat() {
        Utility.showLoading(viewController: self)
        MessagingManager.sharedManager().connectClientWithCompletion { (success, error) in
            //
            if error != nil {
                Utility.hideLoading(viewController: self)
                NSError.showErrorWithMessage(message: "Unable to login in Chat", viewController: self, type: .error, isNavigation: false)
                
            } else {
                MessagingManager.sharedManager().chatClientDelegate = self
            }
        }
    }
    
    //MARK: - Private Methods
    
    @objc func newMessageButtonTapped(sender: UIBarButtonItem) {
        self.chatMembersDataSource.removeAll()
        let addChatGuestViewController = AddChatGuestViewController()
        addChatGuestViewController.delegate = self
        self.navigationController?.pushViewController(addChatGuestViewController, animated: true)
    }
    
    func loadData() {
        self.chatClient = MessagingManager.sharedManager().client
        self.chatClient?.channelsList()?.publicChannelDescriptors(completion: { (result, paginator) in
            Utility.hideLoading(viewController: self)
            if result.isSuccessful() {
                self.channels.removeAll()
                for channel in (self.chatClient?.channelsList()?.subscribedChannels())! {
                    self.channels.append(channel)
                }
                self.isLoadData = true
                self.inboxTableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now()+5) {
                    self.inboxTableView.reloadData()
                }
            }
        })
    }
    
    func getMembers(userContacts: BizeeUserModel) {
        self.chatMembersDataSource.removeAll()
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getMembers(userModel: userContacts) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<EventMember>().mapArray(JSONObject: result) {
                    for dataMember in data {
                        let member = Mapper<AttMember>().map(JSON: [:])!
                        member.id = dataMember.Id
                        member.name = "\(dataMember.firstName) \(dataMember.lastName)"
                        member.picture = dataMember.profilePicture
                        self.chatMembersDataSource.append(member)
                    }
                }
                self.chatMembersDataSource.append(Utility.getUserModel())
                self.createNewChannel(members: self.chatMembersDataSource)
            }
        }
    }
    
    func createNewChannel(members: [AttMember]) {
        Utility.showLoading(viewController: self)
        MessagingManager.sharedManager().chatClientDelegate = self
        MessagingManager.sharedManager().setUpChannels(users: members, viewController: self)
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
    
    //MARK: - IBAction Methods
    
    @IBAction func createEventButtonTapped(_ sender: Any) {
        
        let newEventViewController = EventFormViewController()
        let newEventNavigationController = UINavigationController()
        newEventNavigationController.setupAppThemeNavigationBar()
        newEventViewController.emptyEventForm = true
        newEventNavigationController.viewControllers = [newEventViewController]
        self.present(newEventNavigationController, animated: true, completion: nil)
    }
}

extension InboxViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if isLoadData {
                return self.channels.count
            }
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            var chatMembers = attributesMembers(attributes: self.channels[indexPath.row].attributes() ?? [String:Any]())
            if Utility.isKeyPresentInUserDefaults(key: kUserId) {
                if let userid  = UserDefaults.standard.object(forKey: kUserId) as? Int {
                    userId = userid
                }
            }
            
            chatMembers = chatMembers.filter({ $0.id != userId })
            if chatMembers.count == 1 {
                let cell = InboxTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.chatTitleLabel.text = String().getChatTitle(attributes: self.channels[indexPath.row].attributes()!)
                cell.initData(channel: channels[indexPath.row], member: chatMembers)
                return cell
                
            } else if chatMembers.count == 2 {
                let cell = TwoMemberInboxTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.chatTitleLabel.text = String().getChatTitle(attributes: self.channels[indexPath.row].attributes()!)
                cell.initData(channel: channels[indexPath.row], member: chatMembers)
                return cell
                
            } else if chatMembers.count == 3 {
                let cell = ThreeMemberInboxTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.chatTitelLabel.text = String().getChatTitle(attributes: self.channels[indexPath.row].attributes()!)
                cell.initData(channel: channels[indexPath.row], member: chatMembers)
                return cell
                
            } else {
                let cell = FourMemberInboxTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                
                cell.chatTitleLabel.text = String().getChatTitle(attributes: self.channels[indexPath.row].attributes() ?? [:])
                cell.initData(channel: channels[indexPath.row], member: chatMembers)
                return cell
            }
            
        } else {
            let dummyCell = DummyTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            return dummyCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.channels.count > 0 {
            let navigationViewController = UINavigationController()
            let messageViewController = NewMessageViewController()
            navigationViewController.setupAppThemeNavigationBar()
            messageViewController.channel = self.channels[indexPath.row]
            messageViewController.title = String().getChatTitle(attributes: self.channels[indexPath.row].attributes() ?? [:])
            messageViewController.chatMembersDataSource = attributesMembers(attributes: self.channels[indexPath.row].attributes() ?? [:])
            navigationViewController.viewControllers = [messageViewController]
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.present(navigationViewController, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 0 {
            let action =  UIContextualAction(style: .normal, title: "Files", handler: { (action,view,completionHandler ) in
                Utility.showLoading(viewController: self)
                let options = TCHMessageOptions().withBody("")
                
                guard let author = UserDefaults.standard.object(forKey: kUserFirstName) as? String else {
                    return
                }
                
                guard let userId = UserDefaults.standard.object(forKey: kUserId) as? Int else {
                    return
                }
                
                let attributes = ["author": "\(author)", "user_id": "\(userId)", "profile_picture": "", "message_type": "\(BTMessageType.leave.rawValue)"] as [String: Any]
                options.withAttributes(attributes, completion: nil)
                self.channels[indexPath.row].messages?.sendMessage(with: options, completion: { (result, message) in
                    if result.isSuccessful() {
                        self.channels[indexPath.row].leave { (result) in
                            Utility.hideLoading(viewController: self)
                            if result.isSuccessful() {
                                self.channels.remove(at: indexPath.row)
                                
                            } else {
                                NSError.showErrorWithMessage(message: "Unable to leave chat", viewController: self, type: .error, isNavigation: true)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() ) {
                                self.inboxTableView.reloadData()
                            }
                        }
                        
                        completionHandler(true)
                    }
                })
            })
            action.image = #imageLiteral(resourceName: "cross-color")
            action.backgroundColor = #colorLiteral(red: 0.8274844289, green: 0.379353106, blue: 0.209089905, alpha: 1)
            let confrigation = UISwipeActionsConfiguration(actions: [action])
            confrigation.performsFirstActionWithFullSwipe = false
            return confrigation
        }
        let confrigation = UISwipeActionsConfiguration(actions: [])
        return confrigation
    }
}

extension InboxViewController: MessagingManagerDelegate {
    
    func didNotDeleteChannel() {
        Utility.hideLoading(viewController: self)
        NSError.showErrorWithMessage(message: "Unable to Delete Channel", viewController: self, type: .error, isNavigation: true)
    }
    
    func didDeleteChannel(client: TwilioChatClient) {
        Utility.hideLoading(viewController: self)
        loadData()
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
    
    func didListMessage(message: TCHMessage) {
        
    }
    
    func didGetMessagesList(message: [TCHMessage]) {
    }
    
    func didGetChatList(client: TwilioChatClient) {
        loadData()
    }
}

extension InboxViewController: AddChatGuestViewControllerDelegate {
    func didAddUserContacts(userContacts: BizeeUserModel) {
        self.getMembers(userContacts: userContacts)
    }
}

