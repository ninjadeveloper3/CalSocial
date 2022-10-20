//
//  ContactModel.swift
//  CalSocial
//
//  Created by Moiz Amjad on 03/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class Contacts: Mappable {
    
    var name = ""
    var phone = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        name             <-  map["name"]
        phone          <-  map["phone_number"]
    }
}
//Bizee contacts model
class BizeeContactsModel: Mappable {
    
    var id = 0
    var name = ""
    var isSelected = false

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id             <-  map["id"]
        name          <-  map["name"]
    }
}

//Bizee contacts model
class BizeeContactsRequestModel: Mappable {
    
    var id = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id             <-  map["id"]
    }
}

//get contacts from server

class PhoneContacts: Mappable {
    
    var id = 0
    var ifContactId = 0
    var name = ""
    var phone = ""
    var isBizee = 0
    var isPhone = 0
    var status = ""
    var contactStatus = 0
    var isSelected = false
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id            <-  map["id"]
        ifContactId   <-  map["if_contact_id"]
        name          <-  map["name"]
        phone         <-  map["phone_number"]
        isBizee       <-  map["is_bizee"]
        isPhone       <-  map["is_phone"]
        status        <-  map["status"]
        contactStatus <- map["status"]
    }
}

//get bizee contacts from server

class BizeeContacts: Mappable {
    
    var id = 0
    var name = ""
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id            <-  map["id"]
        name          <-  map["name"]

    }
}

//get all bizee contacts on network

class AllBizeeContactsonNetwork: Mappable {
    
    var id = 0
    var fname = ""
    var lname = ""
    var pic = ""
    var status = 0
    var color = ""
    var canBeInvited = 1
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id            <-  map["id"]
        fname          <-  map["first_name"]
        lname          <-  map["last_name"]
        pic          <-  map["profile_picture"]
        status         <-   map["status"]
        color         <-   map["color"]
        canBeInvited         <-   map["can_be_invited"]
    }
}

//Hive mapper

class Hive: Mappable {
    
    var id = 0
    var hiveMember = 0
    var isActive = Bool()
    var hiveOwner = 0
    var isSender = Bool()
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id            <-  map["id"]
        hiveMember    <-  map["hive_member"]
        isActive      <-  map["is_active"]
        hiveOwner     <-  map["hive_owner"]
        isSender      <-  map["is_sender"]
        
    }
}
