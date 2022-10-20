//
//  ChatMembersModel.swift
//  CalSocial
//
//  Created by DevBatch on 28/02/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class ChatMembersModel: Mappable {
    
    var id = 0//typeId
    var fname = ""
    var lname = ""
    var profilePic = ""
    var status = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id          <-  map["user_id"]
        fname       <-  map["first_name"]
        lname       <-  map["last_name"]
        profilePic  <-  map["profile_picture"]
        status      <-  map["status"]
    }
    

}
