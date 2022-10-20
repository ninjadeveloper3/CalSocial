//
//  SwarmModel.swift
//  CalSocial
//
//  Created by DevBatch on 16/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class SwarmModel: Mappable {
    
    var id = 0
    var swarmId = 0
    var memberId = 0
    var role = 0
    var swarm = Mapper<SwarmData>().map(JSON: [:])!
    var isSelected = false
    var isFavorites = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id          <-  map["id"]
        swarmId     <-  map["swarm_id"]
        memberId    <-  map["member_id"]
        role        <-  map["role"]
        swarm       <-  map["swarm"]
        isFavorites <-  map["is_favorite"]
    }
}

class SwarmData: Mappable {
    
    var id = 0
    var swarmCreator = 0
    var title = ""
    var aboutUs = ""
    var backgroundColor = ""
    var foregroundColor = ""
    var coverPicture = ""
    var swarmMembers = [SwarmMember]()
    var isCreator = 0
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        swarmCreator    <-  map["swarm_creator"]
        title           <-  map["title"]
        aboutUs         <-  map["about_us"]
        backgroundColor <-  map["background_color"]
        foregroundColor <-  map["foreground_color"]
        coverPicture    <-  map["cover_picture"]
        swarmMembers    <-  map["swarm_members"]
    }
}

class SwarmMember: Mappable {
    
    var id = 0
    var swarmId = 0
    var memberId = 0
    var role = 0
    var userId = 0
    var firstName = ""
    var lastName = ""
    var profilePicture = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        swarmId         <-  map["swarm_id"]
        role            <-  map["role"]
        memberId        <-  map["member_id"]
        userId          <-  map["user_id"]
        firstName       <-  map["first_name"]
        lastName        <-  map["last_name"]
        profilePicture  <-  map["profile_picture"]
    }
}

