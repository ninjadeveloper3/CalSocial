//
//  CalendarModel.swift
//  CalSocial
//
//  Created by Moiz Amjad on 05/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class CalendarEvents: Mappable {
    var eventTitle = ""
    var startDate = ""
    var startTime = ""
    var endTime = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        eventTitle            <- map["title"]
        startDate             <-  map["startDate"]
        startTime             <-  map["startTime"]
        endTime               <-  map["endTime"]
    }
}
