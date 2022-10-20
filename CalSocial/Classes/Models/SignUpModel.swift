//
//  SignUpModel.swift
//  CalSocial
//
//  Created by Moiz Amjad on 02/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper
class SignUpUser: Mappable {
    
    var id = 0
    var address = ""
    var biography = ""
    var fname = ""
    var is_activate = 0
    var lname = ""
    var phone = ""
    var profilePic = ""
    var displayName = ""
    var isBlocked = Bool()
    var token = ""
    var color = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id             <-  map["id"]
        token          <-  map["token"]
        isBlocked      <-  map["is_blocked"]
        address         <-  map["address"]
        biography       <-  map["biography"]
        fname           <-  map["first_name"]
        is_activate      <-  map["is_activate"]
        lname           <-  map["last_name"]
        phone           <-  map["phone"]
        profilePic       <-  map["profile_picture"]
        displayName      <-  map["user_name"]
        color           <-  map["color"]
    }
}
