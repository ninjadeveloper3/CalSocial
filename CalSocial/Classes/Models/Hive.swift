//
//  Hive.swift
//  CalSocial
//
//  Created by Moiz Amjad on 17/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class HiveUser: Mappable {
    var id = 0
    var isActive = 0
    var status = 0
    var member = Mapper<Member>().map(JSON: [:])!
    var isSelected = false
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id            <-  map["id"]
        isActive      <-  map["is_active"]
        status        <-  map["status"]
        member        <-  map["hive_member"]
    }
}

class Member: Mappable {

    var id = 0//typeId
    var fname = ""
    var lname = ""
    var profilePic = ""


    required init?(map: Map) {

    }

    func mapping(map: Map) {

        id          <-  map["id"]
        fname       <-  map["first_name"]
        lname       <-  map["last_name"]
        profilePic  <-  map["profile_picture"]
    }
}

