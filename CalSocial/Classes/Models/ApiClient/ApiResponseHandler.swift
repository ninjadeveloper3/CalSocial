//
//  LCApiResponseHandler.swift
//  Labour Choice
//
//  Created by Usama on 19/06/2017.
//  Copyright © 2017 Usama. All rights reserved.
//

import Foundation
import ObjectMapper

class LCResponseHandler: Mappable {

    // MARK: - Properties

    var status = false
    var success = false
    var message = ""
    var responseMessage = ""
    var data: AnyObject? // data can be nil
    var error = ""
    var errorDescription: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        status              <- (map["ResponseHeader.ResponseCode"], transform)
        success             <- (map["ResponseHeader.ResponseCode"], transform)
        message             <- map["ResponseHeader.ResponseMessage"]
        responseMessage     <- map["ResponseBody.ResponseMessage"]
        data                <- map["ResponseBody.data"]
        error               <- map["error"]
        errorDescription    <- map["error_description"]

    }

    // MARK: Transforms

    let transform = TransformOf<Bool, Int>(fromJSON: { (value: Int?) -> Bool? in

        if value == 200 {
            return true
        }

        return false

    }, toJSON: { (value: Bool?) -> Int? in

        if let value = value {

            if value == true {
                return 200
            }

            return 404
        }

        return 404
    })
}
