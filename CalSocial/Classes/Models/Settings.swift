//
//  Settings.swift
//  CalSocial
//
//  Created by Moiz Amjad on 19/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class Settings: Mappable {
    var id = 0
    var inHiveMember = false
    var outHiveMember = false
    var outHiveFromProfile = false
    var outHiveMyHiveMember = false
    var accountPrivacy = false
    var allowSuggest = false
    var directMessageNotification = false
    var hiveNotifications = false
    var eventNotifications = false
    var socialHours = [SocialHours]()
    var workHours = [WorkHours]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id                          <-  map["id"]
        inHiveMember                <-  map["in_hive_members"]
        outHiveMember               <-  map["out_hive_members"]
        outHiveFromProfile          <-  map["out_hive_my_profile"]
        outHiveMyHiveMember         <-  map["out_hive_my_hive_members"]
        accountPrivacy              <-  map["account_privacy"]
        allowSuggest                <-  map["allow_suggest"]
        directMessageNotification      <-  map["direct_messages"]
        hiveNotifications             <-  map["hive_notifications"]
        eventNotifications            <-  map["event_notifications"]
        socialHours                 <- map["play"]
        workHours                 <- map["work"]
        
    }
}

class SocialHours: Mappable {
    
    var slot = 0
    var day = 0
    var status = 0
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        slot          <-  map["slot_id"]
        day           <-  map["day"]
        status           <-  map["status"]

    }
}

class WorkHours: Mappable {
    
    var slot = 0
    var day = 0
    var status = 0
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        slot          <-  map["slot_id"]
        day           <-  map["day"]
        status           <-  map["status"]
        
    }
}


class BizeeSuggestions: Mappable {
    var slot = 0
    var day = 0
    var status = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        slot               <-  map["slot_id"]
        day                <-  map["day"]
        status              <-  map["status"]
        
    }
}

class BlockedUsers: Mappable {
    var id = 0
    var firstName = ""
    var lastName = ""
    var profilePic = ""

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        id               <-  map["user_id"]
        firstName        <-  map["first_name"]
        lastName         <-  map["last_name"]
        profilePic       <-  map["profile_picture"]

    }
}


