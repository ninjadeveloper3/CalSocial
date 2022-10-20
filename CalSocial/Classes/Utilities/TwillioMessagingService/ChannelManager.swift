//
//  ChannelManager.swift
//  CalSocial
//
//  Created by DevBatch on 17/02/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import Foundation
import UIKit
import TwilioChatClient

class ChannelManager: NSObject {
    
    static let sharedManager = ChannelManager()
    static let defaultChannelUniqueName = "general"
    static let defaultChannelName = "General Channel"
    
    var channelsList:TCHChannels?
    var channels:NSMutableOrderedSet?
    var generalChannel:TCHChannel!
    
    override init() {
        super.init()
        channels = NSMutableOrderedSet()
    }
    
    // MARK: - General channel
    
    func joinGeneralChatRoomWithCompletion(channelName: String, completion: @escaping (Bool) -> Void) {
        
        let uniqueName = channelName
        if let channelsList = self.channelsList {
            channelsList.channel(withSidOrUniqueName: uniqueName) { result, channel in
                self.generalChannel = channel
                
                if self.generalChannel != nil {
                    self.joinGeneralChatRoomWithUniqueName(channel: self.generalChannel, completion: completion)
                    
                } else {
                    self.createGeneralChatRoomWithCompletion(channelName: uniqueName) { succeeded in
                        if (succeeded) {
                            self.joinGeneralChatRoomWithUniqueName(channel: self.generalChannel, completion: completion)
                            return
                        }
                        completion(false)
                    }
                }
            }
        }
    }
    
    func joinGeneralChatRoomWithUniqueName(channel: TCHChannel, completion: @escaping (Bool) -> Void) {
        channel.join { result in
            if ((result.isSuccessful())) {
                self.setGeneralChatRoomUniqueNameWithCompletion(completion: completion)
                return
            }
            completion((result.isSuccessful()))
        }
    }
    
    func createGeneralChatRoomWithCompletion(channelName: String, completion: @escaping (Bool) -> Void) {
        let channelName = channelName
        let options = [
            TCHChannelOptionFriendlyName: channelName,
            TCHChannelOptionType: TCHChannelType.public.rawValue
            ] as [String : Any]
        channelsList!.createChannel(options: options) { result, channel in
            if (result.isSuccessful()) {
                self.generalChannel = channel
            }
            completion((result.isSuccessful()))
        }
    }
    
    func setGeneralChatRoomUniqueNameWithCompletion(completion:@escaping (Bool) -> Void) {
        generalChannel.setUniqueName(ChannelManager.defaultChannelUniqueName) { result in
            completion((result.isSuccessful()))
        }
    }
    
    // MARK: - Populate channels
    
    func populateChannels() {
        channels = NSMutableOrderedSet()
        
        channelsList?.userChannelDescriptors { result, paginator in
            self.channels?.addObjects(from: paginator!.items())
            self.sortChannels()
        }
        
        channelsList?.publicChannelDescriptors { result, paginator in
            self.channels?.addObjects(from: paginator!.items())
            self.sortChannels()
        }
    }
    
    func sortChannels() {
        let sortSelector = #selector(NSString.localizedCaseInsensitiveCompare(_:))
        let descriptor = NSSortDescriptor(key: "friendlyName", ascending: true, selector: sortSelector)
        channels!.sort(using: [descriptor])
    }
    
    // MARK: - Create channel
    
    func createChannelWithName(name: String, users: [AttMember], completion: @escaping (Bool, TCHChannel?) -> Void) {
        if (name == ChannelManager.defaultChannelName) {
            completion(false, nil)
            return
        }
        
        let members = users.map({[
            "id"        :   $0.id,
            "name"      :   $0.name,
            "picture"   :   $0.picture
            ]})
        
        let channelOptions = [
            TCHChannelOptionUniqueName : name+"\(Date().timeIntervalSince1970)",
            TCHChannelOptionFriendlyName: name,
            TCHChannelOptionAttributes : [
                "members"   :   members
            ],
            TCHChannelOptionType: TCHChannelType.public.rawValue
            ] as [String : Any]
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        self.channelsList?.createChannel(options: channelOptions) { result, channel in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            for user in users {
                channel?.members?.add(byIdentity: "\(user.id)", completion: { (result) in
                    
                })
            }
            completion((result.isSuccessful()), channel)
        }
    }
    
    
    
}

// MARK: - TwilioChatClientDelegate
extension ChannelManager : TwilioChatClientDelegate {
    func chatClient(_ client: TwilioChatClient, channelAdded channel: TCHChannel) {
        DispatchQueue.main.async {
            if self.channels != nil {
                self.channels!.add(channel)
                self.sortChannels()
            }
//            debugPrint(client)
            debugPrint("Channel Added")
        }
    }
    
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, updated: TCHChannelUpdate) {
        debugPrint(client)
    }
    
    func chatClient(_ client: TwilioChatClient, channelDeleted channel: TCHChannel) {
        DispatchQueue.main.async {
            if self.channels != nil {
                self.channels?.remove(channel)
            }
        }
    }
    
    func chatClient(_ client: TwilioChatClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {
        debugPrint("Channel Sync")
    }
}
