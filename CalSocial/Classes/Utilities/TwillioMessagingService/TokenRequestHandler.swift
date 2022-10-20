//
//  TokenRequestHandler.swift
//  CalSocial
//
//  Created by DevBatch on 17/02/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import Foundation
import UIKit

class TokenRequestHandler {
    
    var token = ""
    
    class func postDataFrom(params:[String:String]) -> String {
        var data = ""
        
        for (key, value) in params {
            if let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
                let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                if !data.isEmpty {
                    data = data + "&"
                }
                data += encodedKey + "=" + encodedValue;
            }
        }
        
        return data
    }
    
    //API Call for Token Fetch

    
    //End
    
    class func fetchToken(params:[String:String], completion:@escaping (NSDictionary, NSError?) -> Void) {
        
        if Utility.isKeyPresentInUserDefaults(key: kUserId) {
            if let id = UserDefaults.standard.object(forKey: kUserId) as? Int {
                APIClient.sharedClient.twillioAuthInput(inputId: id) { (response, result, error, message) in
                    if error != nil {
                        completion(NSDictionary(), error as NSError?)
                        
                    } else {
                        if let _ = result?["token"] as? String {
                            completion((result as? NSDictionary)!, error as NSError?)
                        }
                    }
                }
            }
        }
        
        
//        if let filePath = Bundle.main.path(forResource: "Keys", ofType:"plist"),
//            let dictionary = NSDictionary(contentsOfFile:filePath) as? [String: AnyObject],
//            let tokenRequestUrl = dictionary["TokenRequestUrl"] as? String {
//
//            var request = URLRequest(url: URL(string: tokenRequestUrl)!)
//            request.httpMethod = "POST"
//            let postString = self.postDataFrom(params: params)
//            request.httpBody = postString.data(using: .utf8)
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let data = data, error == nil else {
//                    debugPrint("error=\(String(describing: error))")
//                    completion(NSDictionary(), error as NSError?)
//                    return
//                }
//
//                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                    completion(NSDictionary(), NSError(domain: "TWILIO", code: 1000, userInfo: [NSLocalizedDescriptionKey: "Incorrect return code for token request."]))
//                    return
//                }
//
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
//                    debugPrint("json = \(json)")
//                    completion(json as NSDictionary, error as NSError?)
//                } catch let error as NSError {
//                    completion(NSDictionary(), error)
//                }
//            }
//            task.resume()
//        }
//        else {
//            let userInfo = [NSLocalizedDescriptionKey : "TokenRequestUrl Key is missing"]
//            let error = NSError(domain: "app", code: 404, userInfo: userInfo)
//
//            completion(NSDictionary(), error)
//        }
    }
}
