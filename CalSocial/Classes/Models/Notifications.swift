//
//  Notifications.swift
//  CalSocial
//
//  Created by Moiz Amjad on 07/01/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//


import Foundation
import ObjectMapper

class NotificationsModel: Mappable {
    
    
    var id = 0
    var message = ""
    var status = 0
    var title = ""
    var notificationType = 0
    var apnsNotificationType = 0
    var createdAt = ""
    var fromId = 0
    var swarm = [SwarmObject]()
    var event = Mapper<EventObject>().map(JSON: [:])!
    var hive = Mapper<HiveObject>().map(JSON: [:])!
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id                      <-  map["id"]
        message                 <-  map["notify_body"]
        status                  <-  map["notify_status"]
        title                   <-  map["title"]
        notificationType        <-  map["notify_type"]
        apnsNotificationType    <-  map["notification_type"]
        createdAt               <-  map["created_at"]
        fromId                  <-  map["notify_from"]
        swarm                   <-  map["Swarm"]
        event                   <-  map["Event"]
        hive                    <-  map["Hive"]
        
    }
}

class SwarmObject : Mappable {
    
    var id = 0
    var userName = ""
    var firstName = ""
    var lastName = ""
    var profilePicture = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        userName        <-  map["user_name"]
        firstName       <-  map["first_name"]
        lastName        <-  map["last_name"]
        profilePicture  <-  map["profile_picture"]
    }
}

class EventObject : Mappable {
    
    var id = 0
    var coverPhoto = ""
    var title = ""
    var bgColor = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        coverPhoto        <-  map["cover_photo"]
        title       <-  map["title"]
        bgColor        <-  map["background_color"]
    }
}


class HiveObject : Mappable {
    
    var id = 0
    var userName = ""
    var firstName = ""
    var lastName = ""
    var profilePicture = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        userName        <-  map["user_name"]
        firstName       <-  map["first_name"]
        lastName        <-  map["last_name"]
        profilePicture  <-  map["profile_picture"]
    }
}
