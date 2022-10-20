//
//  ColorModel.swift
//  CalSocial
//
//  Created by DevBatch on 16/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class ColorModel : Mappable {
    
    var id = 0
    var colorCode = ""
    var isSelected = false
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        id          <-  map["id"]
        colorCode   <-  map["color_code"]
    }
    
    
}
