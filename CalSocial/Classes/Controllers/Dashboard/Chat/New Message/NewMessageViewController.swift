//
//  NewMessageViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 02/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import TwilioChatClient
import TwilioAccessManager

class NewMessageViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    
    //MARK: - Variables
    
    var channel : TCHChannel?
    
    var chatMessages : [TCHMessage]?
    
    var isLoadData = false
    
    var userId = 0
    
    var chatMembersDataSource  = [AttMember]()
    
    //MARK: -  UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
        
        if let id = UserDefaults.standard.object(forKey: kUserId) as? Int {
            self.userId = id
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.showLoading(viewController: self)
        MessagingManager.sharedManager().fetchChannelMessages(channel!)
        MessagingManager.sharedManager().chatClientDelegate = self
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        tableView.separatorStyle = .none
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        
        if self.chatMembersDataSource.count > 2 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "More"), style: .plain, target: self, action: #selector(messageDetailsButtonTapped(sender:)))
        }
        messageTextView.delegate = self
        chatMessages = [TCHMessage]()
        chatMessages?.removeAll()
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        
        
        if (messageTextView.text.trimmingCharacters(in: .whitespaces)) != "" {
            
            let options = TCHMessageOptions().withBody("\(messageTextView.text ?? "")")
            
            guard let author = UserDefaults.standard.object(forKey: kUserFirstName) as? String else {
                return
            }
            
            guard let userId = UserDefaults.standard.object(forKey: kUserId) as? Int else {
                return
            }
            
            let profileImage = UserDefaults.standard.object(forKey: kUserProfileImageUrl) as? String ?? ""
            
            let attributes = ["author": "\(author)", "user_id": "\(userId)", "profile_picture": "\(profileImage)", "message_type": "\(BTMessageType.normal.rawValue)"] as [String: Any]
            options.withAttributes(attributes, completion: nil)
            sendButton.isUserInteractionEnabled = false
            channel?.messages?.sendMessage(with: options, completion: { (result, message) in
                if result.isSuccessful() {
                    
                } else {
                    NSError.showErrorWithMessage(message: "Please try sending message again", viewController: self, type: .info, isNavigation: true)
                }
            })
        }
    }
    
    //MARK: - Private Methods
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func messageDetailsButtonTapped(sender: UIBarButtonItem) {
        
        let memberDetailsViewController = MemberDetailsViewController()
        memberDetailsViewController.members = self.chatMembersDataSource
        self.navigationController?.pushViewController(memberDetailsViewController, animated: true)
    }
}
extension NewMessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoadData {
             return (self.chatMessages?.count ?? 0)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (chatMessages?[indexPath.row].author?.contains("\(userId)"))! {
            let leftCell = LeftSideTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            if let chatMessage = chatMessages?[indexPath.row] {
                leftCell.initData(message: chatMessage)
            }
            return leftCell
            
        } else {
            let rightCell = RightSideTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            if let chatMessage = chatMessages?[indexPath.row] {
                rightCell.initData(message: chatMessage, membersFlag: self.chatMembersDataSource.count > 2)
            }
            return rightCell
        }
    }
}

//MARK: - Messaging Manager Delegate

extension NewMessageViewController: MessagingManagerDelegate {
    
    
    func didNotDeleteChannel() {
        
    }
    
    func didDeleteChannel(client: TwilioChatClient) {
        
    }
    
    func didJoinChannel(channel: TCHChannel) {
        
    }
    
    func didGetChatList(client: TwilioChatClient) {
        
    }
    
    func didGetMessagesList(message: [TCHMessage]) {
        
        Utility.hideLoading(viewController: self)
        
        if message.count == 0 {
            
        } else {
            chatMessages = message
            self.isLoadData = true
            tableView.reloadData()
            let index = IndexPath(row: self.chatMessages!.count-1, section: 0)
            self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
        }
    }
    
    func didListMessage(message: TCHMessage) {
        self.messageTextView.endEditing(true)
        self.isLoadData = true
        self.chatMessages?.append(message)
        self.tableView.reloadData()
        self.messageTextView.text = ""
        sendButton.isUserInteractionEnabled = true
        if self.chatMessages?.count ?? 0 > 0 {
            let index = IndexPath(row: self.chatMessages!.count-1, section: 0)
            self.tableView.scrollToRow(at: index, at: .bottom, animated: false)
        }
    }
}

extension NewMessageViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.text == "" {
            heightConstraint.constant = 35
        }
        
        if textView.numberOfLines() == 2 {
            heightConstraint.constant = 45
            
        } else if textView.numberOfLines() == 3 {
            heightConstraint.constant = 55
            
        } else if textView.numberOfLines() == 4 {
            heightConstraint.constant = 65
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            heightConstraint.constant = 35
        }
    }
}

extension UITextView {
    func numberOfLines() -> Int {
        let layoutManager = self.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0
        
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(
                forGlyphAt: index, effectiveRange: &lineRange
            )
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
}
