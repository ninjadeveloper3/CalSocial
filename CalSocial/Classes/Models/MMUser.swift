//
//  MBUser.swift
//  Mobi Mover
//
//  Created by New User on 2/8/18.
//  Copyright © 2018 Usama. All rights reserved.
//

import Foundation
import ObjectMapper

class AttMember : Mappable {
    var id = 0
    var name = ""
    var picture = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id                  <- map["id"]
        name                <- map["name"]
        picture             <- map["picture"]
    }
}

class MMUser: Mappable {
    
    // MARK: Local Variable
    
    var id = ""
    var firstName = ""
    var lastName = ""
    var mobileNumber = ""
    var email = ""
    var profileImageURL = ""
    var dateOfBirth = ""
    var homeAddress = ""
    var city = ""
    var state = ""
    var postalCode = ""
    var gender = ""
    var jobType = [String]()
    var hourlyRate = 0
    var ssnNumber = ""
    var bio = ""
    var jobTypeString = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id                  <- map["userId"]
        firstName           <- map["firstName"]
        lastName            <- map["lastName"]
        email               <- map["email"]
        mobileNumber        <- map["phoneNumber"]
        gender              <- map["gender"]
        dateOfBirth         <- map["dateOfBirth"]
        homeAddress         <- map["address.streetAddress"]
        city                <- map["address.city"]
        state               <- map["address.state"]
        postalCode          <- map["address.postalCode"]
        profileImageURL     <- map["profileImage"]
        jobType             <- map["servicesOffered"]
        hourlyRate          <- map["hourlyRate"]
        ssnNumber           <- map["socialSecurityNuumber"]
        bio                 <- map["bio"]
        
        postMapping()
    }
    
    func postMapping() {
        if jobType.count == 1 {
            jobTypeString = jobType[0]
            
        } else if jobType.count == 2 {
            
            for jobs in jobType {
                
                if jobTypeString == "" {
                    jobTypeString = jobs
                    
                } else {
                    jobTypeString = jobTypeString + "," + jobs
                }
            }
        }
    }
}
