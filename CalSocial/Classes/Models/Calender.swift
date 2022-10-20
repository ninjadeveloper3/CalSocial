//
//  Calender.swift
//  CalSocial
//
//  Created by Moiz Amjad on 23/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class CalenderModel: Mappable {
    
    var isCalenderSynced = false
    
    var phoneEvents = [PhoneEvents]()
    
    var bizeeEvents = [PhoneEvents]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        phoneEvents        <-  map["phoneEvent"]
        isCalenderSynced  <-  map["is_calendar_sync"]
        bizeeEvents  <-  map["bizeeEvent"]
    }
}

class PhoneEvents: Mappable {
    
    var id = 0
    var title = ""
    var startDate = ""
    var endDate = ""
    var user = Mapper<SwarmUser>().map(JSON: [:])!
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id          <-  map["id"]
        title       <-  map["title"]
        startDate   <-  map["start_date"]
        endDate     <-  map["end_time"]
        user        <- map["users"]
    }
}
