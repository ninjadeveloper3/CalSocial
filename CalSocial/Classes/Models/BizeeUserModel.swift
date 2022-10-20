//
//  BizeeUserModel.swift
//  CalSocial
//
//  Created by DevBatch on 01/01/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class BizeeUserModel: Mappable {
    
    
    var phoneContacts = [PhoneContacts]()
    
    var swarms = [SwarmModel]()
    
    var hives = [HiveModel]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
     
        phoneContacts   <-  map["PhoneContacts"]
        swarms          <-  map["Swarms"]
        hives           <-  map["Hives"]
    }
}

