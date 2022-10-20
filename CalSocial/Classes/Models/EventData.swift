//
//  EventData.swift
//  CalSocial
//
//  Created by DevBatch on 08/01/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class EventData: Mappable {
    
    var eventDate = ""
    var startTime = ""
    var endTime = ""
    var score : Float = 0.0
    var guests = [Guests]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        eventDate   <-  map["event_date"]
        startTime   <-  map["start_time"]
        endTime     <-  map["end_time"]
        score       <-  map["score"]
        guests      <-  map["guests"]
        
    }
}

class Guests: Mappable {
    
    var guestId = 0
    var score : Float = 0.0
    var firstName = ""
    var lastName = ""
    var profilePicture = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        guestId         <-  map["guest_id"]
        score           <-  map["score"]
        firstName       <-  map["first_name"]
        lastName        <-  map["last_name"]
        profilePicture  <-  map["profile_picture"]
    }
}

class EventMember: Mappable {
    
    var Id = 0
    var firstName = ""
    var lastName = ""
    var profilePicture = ""
    var color = ""
    var score: Float = 0.0
    var isBizee = 1
    
    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
    
        Id              <-  map["id"]
        firstName       <-  map["first_name"]
        lastName        <-  map["last_name"]
        profilePicture  <-  map["profile_picture"]
        color           <-  map["color"]
        score           <-  map["score"]
        isBizee       <-  map["is_bizee"]
    }
}
