//
//  HiveModel.swift
//  CalSocial
//
//  Created by DevBatch on 16/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class HiveModel: Mappable {
    
    var id = 0
    var hiveMember = Mapper<HiveMember>().map(JSON: [:])!
    var status = 0
    var isFavourite = 0
    var isSelected = false
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id          <-  map["id"]
        hiveMember  <-  map["hive_member"]
        status      <-  map["status"]
        isFavourite <-  map["is_favorite"]
    }
}

class HiveMember: Mappable {
    
    var id = 0
    var firstName = ""
    var phone = ""
    var lastName = ""
    var profilePicture = ""
    var color = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <-  map["id"]
        firstName       <-  map["first_name"]
        phone           <-  map["phone"]
        lastName        <-  map["last_name"]
        profilePicture  <-  map["profile_picture"]
        color           <-  map["color"]
    }
}
