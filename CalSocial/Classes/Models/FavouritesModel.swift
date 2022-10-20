//
//  FavouritesModel.swift
//  CalSocial
//
//  Created by DevBatch on 17/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class FavouritesModel: Mappable {
    
    var hive = [FavouriteHive]()
    
    var swarm = [FavouriteSwarm]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        hive    <-  map["hive"]
        swarm   <-  map["swarm"]
    }
}

class FavouriteHive: Mappable {
    
    var id = 0
    var userId = 0
    var firstName = ""
    var lastName = ""
    var profilePicture = ""
    var color = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        userId          <-  map["users.id"]
        firstName       <-  map["users.first_name"]
        lastName        <-  map["users.last_name"]
        profilePicture  <-  map["users.profile_picture"]
        color           <-  map["users.color"]
    }
}

class FavouriteSwarm: Mappable {
    
    var id = 0
    var title = ""
    var swarmMembers = [FavouriteSwarmMember]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["swarms.id"]
        title           <-  map["swarms.title"]
        swarmMembers    <-  map["swarms.swarm_members"]
    }
}


class FavouriteSwarmMember: Mappable {
    
    var profilePicture = ""
    var id = 0
    var firstName = ""
    var lastName = ""
    var color = ""
    var role = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id                  <-  map["user.id"]
        profilePicture      <-  map["user.profile_picture"]
        firstName           <-  map["user.first_name"]
        lastName           <-  map["user.last_name"]
        color           <-  map["user.color"]
        role           <-  map["role"]
    }
}

class Favourites: Mappable {
    
    var id = 0
    var type = ""
    var typeId = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id      <-  map["id"]
        type    <-  map["type"]
        typeId  <-  map["type_id"]
    }
}
