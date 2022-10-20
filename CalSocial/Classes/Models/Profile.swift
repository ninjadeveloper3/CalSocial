//
//  Profile.swift
//  CalSocial
//
//  Created by Moiz Amjad on 13/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class Profile: Mappable {
    var id = 0
    var fname = ""
    var lname = ""
    var profilePic = ""
    var bio = ""
    var address = ""
    var color = ""
    var status = 0
    var isFavourite = 0
    var bucketItems = [BucketItems]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id            <-  map["id"]
        fname         <-  map["first_name"]
        lname         <-  map["last_name"]
        profilePic    <-  map["profile_picture"]
        bio           <-  map["biography"]
        address       <-  map["address"]
        status       <-  map["status"]
        isFavourite  <-  map["is_favorite"]
        bucketItems   <-  map["bucket_items"]
        color           <-  map["color"]
    }
}

class BucketItems: Mappable {
    
    var id = 0
    var userId = 0
    var value = ""
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id         <-  map["id"]
        userId     <-  map["user_id"]
        value      <-  map["value"]
    }
}
