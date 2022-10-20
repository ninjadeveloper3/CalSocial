//
//  MessagingManager.swift
//  CalSocial
//
//  Created by DevBatch on 17/02/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import Foundation
import UIKit
import TwilioChatClient
import TwilioAccessManager
import ObjectMapper

protocol MessagingManagerDelegate {
    func didGetChatList(client: TwilioChatClient)
    func didGetMessagesList(message: [TCHMessage])
    func didListMessage(message: TCHMessage)
    func didJoinChannel(channel: TCHChannel)
    func didDeleteChannel(client: TwilioChatClient)
    func didNotDeleteChannel()
}

class MessagingManager: NSObject {
    
    static let _sharedManager = MessagingManager()
    
    var client : TwilioChatClient?
    var delegate:ChannelManager?
    var connected = false
    var chatClientDelegate : MessagingManagerDelegate?
    
    
    var userIdentity:String {
        return TwillioSessionManager.getUsername()
    }
    
    var hasIdentity: Bool {
        return TwillioSessionManager.isLoggedIn()
    }
    
    override init() {
        super.init()
        delegate = ChannelManager.sharedManager
    }
    
    class func sharedManager() -> MessagingManager {
        return _sharedManager
    }
    
    func presentRootViewController() {
        if (!hasIdentity) {
            presentViewControllerByName(viewController: "LoginViewController")
            return
        }
        
        if (!connected) {
            connectClientWithCompletion { success, error in
                debugPrint("Delegate method will load views when sync is complete")
                if (!success || error != nil) {
                    DispatchQueue.main.async {
                        self.presentViewControllerByName(viewController: "LoginViewController")
                    }
                }
            }
            return
        }
        presentViewControllerByName(viewController: "RevealViewController")
    }
    
    func presentViewControllerByName(viewController: String) {
        presentViewController(controller: storyBoardWithName(name: "Main").instantiateViewController(withIdentifier: viewController))
    }
    
    func presentLaunchScreen() {
        presentViewController(controller: storyBoardWithName(name: "LaunchScreen").instantiateInitialViewController()!)
    }
    
    func presentViewController(controller: UIViewController) {
        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = controller
    }
    
    func storyBoardWithName(name:String) -> UIStoryboard {
        return UIStoryboard(name:name, bundle: Bundle.main)
    }
    
    // MARK: User and session management
    
    func loginWithUsername(username: String,
                           completion: @escaping (Bool, NSError?) -> Void) {
        TwillioSessionManager.loginWithUsername(username: username)
        connectClientWithCompletion(completion: completion)
    }
    
    func logout() {
        TwillioSessionManager.logout()
        DispatchQueue.global(qos: .userInitiated).async {
            self.client?.shutdown()
            self.client = nil
        }
        self.connected = false
    }
    
    // MARK: Twilio Client
    
    func loadGeneralChatRoomWithCompletion(completion:@escaping (Bool, NSError?) -> Void) {
        for channel in (client?.channelsList()?.subscribedChannels())! {
            ChannelManager.sharedManager.joinGeneralChatRoomWithCompletion(channelName: channel.uniqueName ?? channel.friendlyName ?? "" ) { succeeded in
                if succeeded {
                    completion(succeeded, nil)
                
                } else {
                    let error = self.errorWithDescription(description: "Could not join General channel", code: 300)
                    completion(succeeded, error)
                }
            }
        }
    }
    
    func connectClientWithCompletion(completion: @escaping (Bool, NSError?) -> Void) {
        if (client != nil) {
            logout()
        }
        
        requestTokenWithCompletion { succeeded, token in
            if let token = token, succeeded {
                UserDefaults.standard.set(token, forKey: kChatToken)
                self.initializeClientWithToken(token: token)
                completion(succeeded, nil)
            }
            else {
                let error = self.errorWithDescription(description: "Could not get access token", code:301)
                completion(succeeded, error)
            }
        }
    }
    
    func initializeClientWithToken(token: String) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        TwilioChatClient.chatClient(withToken: token, properties: nil, delegate: self) { [weak self] result, chatClient in
            guard (result.isSuccessful()) else { return }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self?.connected = true
            self?.client = chatClient
            self?.client?.channelsList()?.publicChannelDescriptors(completion: { (result, paginator) in
                if result.isSuccessful() {
                    
                    self?.chatClientDelegate?.didGetChatList(client: (self?.client ?? nil)!)
                    for channal in (paginator?.items())! {
                        
                        print("MChannel: \(channal.uniqueName ?? "No Unique")")
                        print("MAttributes: \(channal.attributes() ?? [:])")
                    }
                }
            })
        }
    }
    
    func requestTokenWithCompletion(completion:@escaping (Bool, String?) -> Void) {
        
        if Utility.isKeyPresentInUserDefaults(key: kUserId) {
            if let id = UserDefaults.standard.object(forKey: kUserId) as? Int {
                TokenRequestHandler.fetchToken(params: [ "identity":"\(id)"]) {response,error in
                    var token: String?
                    token = response["token"] as? String
                    completion(token != nil, token)
                }
            }
        }
    }
    
    func fetchChannelMessages(_ channel: TCHChannel) {

        channel.getMessagesCount { (_, count) in
            let messagesCount = count
            if messagesCount > 0 {
                channel.messages?.getLastWithCount(messagesCount, completion: { [weak self]  (result, messages) in
                    if result.isSuccessful() {
                        if let message = messages {
                            self?.chatClientDelegate?.didGetMessagesList(message: message)
                        }
                    }
                })
                
            } else {
                self.chatClientDelegate?.didGetMessagesList(message: [])
                debugPrint("Unable to Get Messages")
            }
        }
    }
    
    
    func errorWithDescription(description: String, code: Int) -> NSError {
        let userInfo = [NSLocalizedDescriptionKey : description]
        return NSError(domain: "app", code: code, userInfo: userInfo)
    }
    
    func setUpChannels(users: [AttMember], viewController: UIViewController) {
        if self.client == nil {
            Utility.hideLoading(viewController: viewController)
            NSError.showErrorWithMessage(message: "Please wait connecting to chat server", viewController: viewController, type: .info, isNavigation: true)
            return
        }
        
        for channel in (self.client?.channelsList()?.subscribedChannels())! {
            var channelCountMemeberExist = 0
            if let members = channel.attributes()?["members"] as? [[String:Any]] {
                for member in members {
                    for user in users {
                        if let userId = member["id"] as? Int {
                            if userId == user.id {
                                channelCountMemeberExist = channelCountMemeberExist + 1
                            }
                        }
                    }
                }
                
                if members.count == channelCountMemeberExist && users.count == members.count {
                    Utility.hideLoading(viewController: viewController)
                    self.chatClientDelegate?.didJoinChannel(channel: channel)
                    return
                }
            }
        }
        
        var channelName = ""
        for (index,user) in users.enumerated() {
            
            if index == users.count-1 {
             channelName = channelName + " & \(user.name)"
                
            } else {
                channelName = channelName + "\(user.name),"
            }
        }
        ChannelManager.sharedManager.createChannelWithName(name: channelName, users: users) { (success, channel) in
            if success {
                self.chatClientDelegate?.didJoinChannel(channel: channel!)
//                channel?.join(completion: { (result) in
//                    if result.isSuccessful() {
//                        
//                    }
//                })
            }
        }
    }
    
    func deleteChannel(channel: TCHChannel) {
        channel.destroy { (result) in
            if result.isSuccessful() {
                debugPrint("Channel Deleted")
                
            } else {
                self.chatClientDelegate?.didNotDeleteChannel()
                debugPrint("Channel Not Deleted")
            }
        }
    }
}

// MARK: - TwilioChatClientDelegate
extension MessagingManager : TwilioChatClientDelegate {
    func chatClient(_ client: TwilioChatClient, channelAdded channel: TCHChannel) {
        debugPrint("///////////////////Channel Added////////////////////")
        self.chatClientDelegate?.didGetChatList(client: client)
    }
    
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, updated: TCHChannelUpdate) {
        self.delegate?.chatClient(client, channel: channel, updated: updated)
    }
    
    func chatClient(_ client: TwilioChatClient, channelDeleted channel: TCHChannel) {
       debugPrint("///////////////////Channel Delete////////////////////")
        self.chatClientDelegate?.didDeleteChannel(client: client)
    }
    
    func chatClient(_ client: TwilioChatClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {
        if status == TCHClientSynchronizationStatus.completed {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            ChannelManager.sharedManager.channelsList = client.channelsList()
            ChannelManager.sharedManager.populateChannels()
            loadGeneralChatRoomWithCompletion { success, error in
                if success {
                    debugPrint("///////////////////Success////////////////////")
                }
            }
        }
        self.delegate?.chatClient(client, synchronizationStatusUpdated: status)
    }
    
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, messageAdded message: TCHMessage) {
        debugPrint("///////////////////Message Recieved////////////////////")
        chatClientDelegate?.didListMessage(message: message)
    }
}

// MARK: - TwilioAccessManagerDelegate
extension MessagingManager : TwilioAccessManagerDelegate {
    func accessManagerTokenWillExpire(_ accessManager: TwilioAccessManager) {
        requestTokenWithCompletion { succeeded, token in
            if (succeeded) {
                accessManager.updateToken(token!)
            }
            else {
                debugPrint("Error while trying to get new access token")
            }
        }
    }
    
    func accessManager(_ accessManager: TwilioAccessManager!, error: Error!) {
        debugPrint("Access manager error: \(error.localizedDescription)")
    }
}
