//
//  SessionManager.swift
//  CalSocial
//
//  Created by DevBatch on 17/02/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import Foundation
import UIKit

class TwillioSessionManager {
    static let UsernameKey: String = "twilliousername"
    static let IsLoggedInKey: String = "twilliologgedIn"
    static let defaults = UserDefaults.standard
    
    class func loginWithUsername(username:String) {
        defaults.set(username, forKey: UsernameKey)
        defaults.set(true, forKey: IsLoggedInKey)
        
        defaults.synchronize()
    }
    
    class func logout() {
        defaults.set("", forKey: UsernameKey)
        defaults.set(false, forKey: IsLoggedInKey)
        defaults.synchronize()
    }
    
    class func isLoggedIn() -> Bool {
        let isLoggedIn = defaults.bool(forKey: IsLoggedInKey)
        if (isLoggedIn) {
            return true
        }
        return false
    }
    
    class func getUsername() -> String { // Make Changes for User ID
        if let username = defaults.object(forKey: kUserId) as? String {
            return username
        }
        return ""
    }
}
