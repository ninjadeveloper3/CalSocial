//
//  SwarmWithIdModel.swift
//  CalSocial
//
//  Created by DevBatch on 23/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class SwarmWithIdModel: Mappable {
    
    var id = 0
    var title = ""
    var aboutUs = ""
    var foregroundColor = ""
    var backgroundColor = ""
    var coverPicture = ""
    var creator = Mapper<CreatorModel>().map(JSON: [:])!
    var swarmMembers = [SwarmMemberModel]()
    var favourites  = [Favourites]()
    var isCreator = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        title           <-  map["title"]
        aboutUs         <-  map["about_us"]
        foregroundColor <-  map["foreground_color"]
        backgroundColor <-  map["background_color"]
        coverPicture    <-  map["cover_picture"]
        creator         <-  map["creator"]
        swarmMembers    <-  map["swarm_members"]
        favourites      <-  map["favourites"]
        isCreator       <-  map["is_creator"]
    }
}

class CreatorModel : Mappable {
    
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

class SwarmMemberModel: Mappable {
    
    var id = 0
    var swarmId = 0
    var memberId = 0
    var role : MemberRoles = .SwarmOwner
    var status = 0
    var user = Mapper<SwarmUser>().map(JSON: [:])!
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id          <-  map["id"]
        swarmId     <-  map["swarm_id"]
        role        <-  map["role"]
        status        <-  map["status"]
        memberId    <-  map["member_id"]
        user        <-  map["user"]
    }
}

class SwarmUser: Mappable {
    
    var id = 0
    var firstName = ""
    var lastName = ""
    var profilePicture = ""
    var phone = ""
    var color = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        firstName       <-  map["first_name"]
        lastName        <-  map["last_name"]
        profilePicture  <-  map["profile_picture"]
        phone           <-  map["phone"]
        color           <-  map["color"]
    }
}

