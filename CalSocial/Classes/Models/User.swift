//
//  User.swift
//  Labour Choice
//
//  Created by Usama on 10/07/2017.
//  Copyright © 2017 Usama. All rights reserved.
//

import Foundation
import ObjectMapper

final class User {

    // Can't init is singleton
    private init() { }

    // MARK: Shared Instance

    static let shared = User()

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
    var deviceToken = ""
    var gender = ""
    var badgeValue: Int = 0
    var isChating = false
    var jobId = ""
    var isChatingWithId = ""
    
    //var categories = Mapper<LCCategories>().map(JSONObject: [:])!

    
}
