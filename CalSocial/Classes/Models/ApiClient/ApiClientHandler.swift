//
//  APIClientHandler.swift
//  Labour Choice
//
//  Created by Usama on 19/06/2017.
//  Copyright © 2017 Usama. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

typealias APIClientCompletionHandler = (_ response: HTTPURLResponse?, _ result: AnyObject?, _ error: NSError?, _ message: String?) -> Void

enum APIClientHandlerErrorCode: Int {
    case general = 30001
    case noNetwork = 30002
    case timeOut = 30003
}

let APIClientHandlerErrorDomain = "com.bizee.webserviceerror"
let APIClientHandlerDefaultErrorDescription = "Task failed due to Server Maintenance" //"Operation failed"

class APIClientHandler: TSAPIClient {

    func sendRequest(_ methodName: String,
                     parameters: [String : AnyObject]?,
                     methods: HTTPMethod,
                     headers: [String : String]?,
                     completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        var token = ""
        if Utility.isKeyPresentInUserDefaults(key: kToken) {
            token = UserDefaults.standard.object(forKey: kToken) as! String
        }
        var head = [
            
            "Authorization" : "Bearer \(token)",
            "Accept" : "application/json"
            
            ] as [String : String]?
        
        debugPrint(head!)
        
//        if methodName != "complete_profile" && methodName != "sync_user_contacts" {
//            head = nil
//        }
        
        if methodName == "signin" || methodName == "signup" || methodName == "activate_account" || methodName == "resend_activation_code" || methodName == "send_login_verification" {
            head = nil
        }

        let request = self.serverRequest(methodName, parameters: parameters, methods: methods, headers: head) { (response, result, error) in
            debugPrint(result ?? "no result")
            if error != nil {
                
                var apiError = error
                if error?.code == NSURLErrorNotConnectedToInternet {
                    let userInfo : [AnyHashable: Any] = [NSLocalizedDescriptionKey : "No network found"]
                    apiError = self.createErrorWithErrorCode(APIClientHandlerErrorCode.noNetwork.rawValue, andErrorInfo: userInfo)

                } else {
                    let userInfo : [AnyHashable: Any] = [NSLocalizedDescriptionKey : "Connecting to network ...."]
                    apiError = self.createErrorWithErrorCode(APIClientHandlerErrorCode.timeOut.rawValue, andErrorInfo: userInfo)
                }

                DispatchQueue.main.async { // Correct
                    completionBlock(response, nil, apiError, "")
                }

            } else {

                var sendError = false
                var sendMessage = false
                var status = false
                var success = false
                var errorMessage = ""
                var message = ""
                var resultError: NSError?
                var resultData: AnyObject?

                if let responseHandler = Mapper<LCResponseHandler>().map(JSONObject:result) {
                    status = responseHandler.status
                    success = responseHandler.success
                    errorMessage = responseHandler.error
                    message = responseHandler.message + responseHandler.responseMessage

                    if status && success {
                        resultData = responseHandler.data

                        if resultData == nil {
                            resultData = true as AnyObject?
                        }

                    } else if !success && message != "" {
                        sendMessage = true

                    } else {
                        sendError = true
                    }

                } else {
                    sendError = true
                }

                if sendError {
                    resultError = self.createError(errorMessage)

                    DispatchQueue.main.async { // Correct
                        completionBlock(response, nil, resultError, message)
                    }

                } else if sendMessage {
                    resultError = self.createError(message)

                    DispatchQueue.main.async { // Correct
                        completionBlock(response, nil, resultError, message)
                    }
 
                } else {

                    DispatchQueue.main.async { // Correct
                        completionBlock(response, resultData, nil, message)
                    }
                }
            }
        }

        return request
    }

    // MARK: - Private methods

    func createError(_ errorDescription: String) -> NSError {
        var description = APIClientHandlerDefaultErrorDescription

        //debugPrint(errorDescription)
        if errorDescription.count > 0 {
            description = errorDescription
        }

        let userInfo : [AnyHashable: Any] = [NSLocalizedDescriptionKey : description]

        return createErrorWithErrorCode(APIClientHandlerErrorCode.general.rawValue, andErrorInfo: userInfo)
    }

    func createErrorWithErrorCode(_ code: Int, andErrorInfo info: [AnyHashable: Any]?) -> NSError {
        return NSError(domain: APIClientHandlerErrorDomain, code: code, userInfo: info as? [String : Any])
    }
    
}
