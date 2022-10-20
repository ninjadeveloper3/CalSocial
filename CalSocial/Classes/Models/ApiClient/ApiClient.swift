//
//  APIClient.swift
//  Labour Choice
//
//  Created by Usama on 19/06/2017.
//  Copyright © 2017 Usama. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

let APIClientDefaultTimeOut = 40.0

let APIClientBaseURL = kStagingBaseUrl

class APIClient: APIClientHandler {

    fileprivate var clientDateFormatter: DateFormatter
    var manager: NetworkReachabilityManager?

    static let sharedClient: APIClient = {
        let baseURL = URL(string: APIClientBaseURL)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = APIClientDefaultTimeOut

        let instance = APIClient(baseURL: baseURL!, configuration: configuration)

        return instance
    }()

    // MARK: - init methods

    override init(baseURL: URL, configuration: URLSessionConfiguration, delegate: SessionDelegate = SessionDelegate(), serverTrustPolicyManager: ServerTrustPolicyManager? = nil) {
        clientDateFormatter = DateFormatter()

        super.init(baseURL: baseURL, configuration: configuration, delegate: delegate, serverTrustPolicyManager: serverTrustPolicyManager)

        //        clientDateFormatter.timeZone = NSTimeZone(name: "UTC")
        clientDateFormatter.dateFormat = "yyyy-MM-dd"
    }

    // MARK: Helper methods

    func apiClientDateFormatter() -> DateFormatter {
        return clientDateFormatter.copy() as! DateFormatter
    }

    fileprivate func normalizeString(_ value: AnyObject?) -> String {
        return value == nil ? "" : value as! String
    }

    fileprivate func normalizeDate(_ date: Date?) -> String {
        return date == nil ? "" : clientDateFormatter.string(from: date!)
    }

    // Login
    @discardableResult
    func logInUser(email: String, password: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {

        let serviceName = "signin"
        let parameters = [
        
            "email"     :   email,
            "password"  :   password
            
        ] as [String:AnyObject]

        
        return sendRequest(serviceName, parameters: parameters
            , methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    //Sign up
    
    @discardableResult
    func doSignUp(fname: String, lname: String, phone: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "signup"
        let parameters = [
            
            "first_name": fname,
            "last_name": lname,
            "phone": phone
        ]
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    //Activate account
    @discardableResult
    func activateAccount(userId: Int, code: String, playerId: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "activate_account"
        let parameters = [
            
            "user_id": userId,
            "code": code,
            "player_id": playerId
            
            ] as [String : Any]
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    //Activate account
    @discardableResult
    func verifyAccountForLogin(userId: Int, code: String, playerId: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "verify_login_code"
        let parameters = [
            
            "user_id": userId,
            "code": code,
            "player_id": playerId
            
            ] as [String : Any]
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    //resend Code
    
    @discardableResult
    func resendCode(userId: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "resend_activation_code"
        let parameters = [
            
            "user_id": userId,
            
            ] as [String : Any]
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    //Add Bio
    @discardableResult
    func addBio(address: String, bio: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "complete_profile"
        let parameters = [
            
            "address": address,
            "biography": bio,
            
            ] as [String : Any]
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    //save contacts
    @discardableResult
    func saveContactsList(contactsList: [Contacts], _ completionBlock: @escaping APIClientCompletionHandler) -> Request {

        let serviceName = "sync_user_contacts"
        let contactsArray = contactsList.map({[
            "name": $0.name,
            "phone_number": $0.phone
            ]})
        
        let parameters = [

            "contact": contactsArray

            ] as [String : Any]
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    //send bizee request contacts
    
    @discardableResult
    func sendBizeeRequest(contactsList: [BizeeContactsRequestModel], _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "send_hive_request"
        let contactsArray = contactsList.map({[
            "user_id": $0.id
            ]})
        
        let parameters = [
            
            "users": contactsArray
            
            ] as [String : Any]
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func sendBizeeAppRequest(phone: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "join_bizee"
        let parameters = [
            
            "phone": phone,
            
            ] as [String : Any]
        
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    //Sign In
    @discardableResult
    func doSignIn(phone: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "send_login_verification"
        let parameters = [
            
            "phone": phone,
            
            ] as [String : Any]
        
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    //Save Calendar Events Api
    
    @discardableResult
    func saveCalendarEvents(eventsList: [CalendarEvents], _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "sync_calender"
        let eventsArray = eventsList.map({[
            "start_date": $0.startDate,
            "start_time": $0.startTime,
            "end_time": $0.endTime,
            "title": $0.eventTitle
            ]})
        
        let parameters = [
            
            "event": eventsArray
            
            ] as [String : Any]
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    //Update My Profile
    
    @discardableResult
    func updateProfile(name: String, address: String, bio: String, bucketList: [String], _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "edit_user_profile"
        let bucket = bucketList.map({[
            "bucket_item": $0,
            ]})
        let parameters = [
            "full_name": name,
            "bio": bio,
            "address": address,
            "bucket_list": bucket,
            
            ] as [String : Any]
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    //Add to Hive
    
    @discardableResult
    func addToHive(userId: Int, type: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "add_to_hive"
        let parameters = [
            "user_id": userId,
            "confirmation": type
            ] as [String : Any]
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    //Set Account Privacy
    
    @discardableResult
    func setAccountPrivacy(status: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "set_account_privacy"
        let parameters = [
            "account_privacy": status,
            ] as [String : Any]
        
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    //Set Account Privacy
    
    @discardableResult
    func setAllowSuggest(status: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "set_settings"
        let parameters = [
            "allow_suggest": status,
            ] as [String : Any]
        
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    //Set Hive Connection Settings
    
    @discardableResult
    func setHiveConnectionsSettings(options: Settings, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "set_settings"
        let parameters = [
            "in_hive_members": options.inHiveMember,
            "out_hive_members": options.outHiveMember,
            "out_hive_my_profile": options.outHiveFromProfile,
            "out_hive_my_hive_members": options.outHiveMyHiveMember,
            "out_hive_invite_event" : options.outHiveMember,
            ] as [String : Any]
        
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func setNotificationsSettings(options: Settings, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "set_settings"
        let parameters = [
            "direct_messages": options.directMessageNotification,
            "hive_notifications": options.hiveNotifications,
            "event_notifications": options.eventNotifications,
            ] as [String : Any]
        
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func removeMyCalender(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "delete_calender"
        
        return sendRequest(serviceName, parameters: nil , methods: .delete, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func createSwarm(title: String, aboutUs: String, colorCode: String, members: [HiveModel],  _ completionBlock: @escaping APIClientCompletionHandler) -> Request {

        let serviceName = "create_swarm"
        
        let membersDatasource = members.map({[
            "member": $0.hiveMember.id,
            ]})
        
        let parameters = [
            "title": title,
            "about_us": aboutUs,
            "background_color": colorCode,
            "foreground_color": colorCode,
            "members": membersDatasource
            ] as [String : AnyObject]

         return sendRequest(serviceName, parameters: parameters, methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    //social hours
    @discardableResult
    func setSocialHours(hours: [BizeeSuggestions], _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "set_social_hours"
        
        let hoursArray = hours.map({[
            "slot_id": $0.slot,
            "day": $0.day,
            "status": $0.status
            ]})
        
        let parameters = [
            "slots": hoursArray
            ] as [String : Any]
        
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    //Block User
    @discardableResult
    func doBlockUser(userId: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "block_user"
        let parameters = [
            "to_user": userId,
            ] as [String : Any]
        
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func addComments(eventId: Int, userId: Int, comment: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "add_comment"
        
        let parameters = [
            
            "event_id": eventId,
            "user_id": userId,
            "comment": comment
            
            ] as [String : AnyObject]
        
        return sendRequest(serviceName, parameters: parameters, methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    //Block User
    @discardableResult
    func doUnBlockUser(userId: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "unblock_user"
        let parameters = [
            "to_user": userId,
            ] as [String : Any]
        
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    //Block User
    @discardableResult
    func doUnFavourite(userId: Int, type: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "un_favorite?type_id=\(userId)&type=\(type)"
        let parameters = [
            "type_id": userId,
            "type": type,
            ] as [String : Any]
        
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .delete, headers: nil, completionBlock: completionBlock)
    }
    
    //remove from hive
    @discardableResult
    func doRemoveFromMyHive(userId: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "remove_from_hive"
        let parameters = [
            "user_id": userId,
            ] as [String : Any]
        
        return sendRequest(serviceName, parameters: parameters as [String : AnyObject], methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func leaveEvent(eventId: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "leave_event?event_id=\(eventId)"
        
        return sendRequest(serviceName, parameters: nil, methods: .delete, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func setFavorite(id: Int, type: String, _ completionBlock: @escaping APIClientCompletionHandler ) -> Request {
        
        let serviceName = "favorites"
        
        let parameters = [
            
            "type_id": id,
            "type": type
            
            ] as [String : AnyObject]

        return sendRequest(serviceName, parameters: parameters , methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func removeFromHive(userId: Int, _ completionBlock: @escaping APIClientCompletionHandler ) -> Request {
        
        let serviceName = "remove_from_hive"
        
        let parameters = [
            
            "user_id": userId
            
            ] as [String : AnyObject]
        
        return sendRequest(serviceName, parameters: parameters , methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func doReadNotifications(notificationId: Int, _ completionBlock: @escaping APIClientCompletionHandler ) -> Request {
        
        let serviceName = "mark_read"
        
        let parameters = [
            
            "notification_id": notificationId
            
            ] as [String : AnyObject]
        
        return sendRequest(serviceName, parameters: parameters , methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func deleteNotification(notificationId: Int, _ completionBlock: @escaping APIClientCompletionHandler ) -> Request {
        
        let serviceName = "delete_notification"
        
        let parameters = [
            
            "notification_id": notificationId
            
            ] as [String : AnyObject]
        
        return sendRequest(serviceName, parameters: parameters , methods: .delete, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func suggestOtherTime(eventId: Int, date: String, startTime: String, endTime: String,  _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
    
        let serviceName = "suggest_event_time"
        
        let parameters = [
            
            "event_id": eventId,
            "date": date,
            "from_time": startTime,
            "to_time": endTime
            
            ] as [String : AnyObject]
        
        return sendRequest(serviceName, parameters: parameters , methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getMembers(userModel: BizeeUserModel, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_hive_swarm_members"
        var hivesArray = [Int]()
        var swarmArray = [Int]()
        var nonBizee = [Int]()
        hivesArray.removeAll()
        swarmArray.removeAll()
        nonBizee.removeAll()
        let _ = userModel.hives.map({[
            hivesArray.append($0.hiveMember.id)
            ]})
        
        let _ = userModel.swarms.map({[
            swarmArray.append($0.swarmId)
            ]})
        let _ = userModel.phoneContacts.map({[
            nonBizee.append($0.id)
            ]})
        
        let parameters = [
            
            "hives": hivesArray,
            "swarms": swarmArray,
            "non_bizee": nonBizee,
            
            ] as [String : AnyObject]
        
        return sendRequest(serviceName, parameters: parameters , methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func createEvent(date: String, startTime: String, endTime: String, title: String, location: String, hostNotes: String, userModel: BizeeUserModel, backgroudColor: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "create_event"
        
        var members = userModel.phoneContacts.map({[
            "guest_id": $0.id,
            "is_bizee": 0,
            "phone": $0.phone
            ]})
        
        let phoneMembers = userModel.hives.map({[
            "guest_id": $0.hiveMember.id,
            "is_bizee": 1,
            "phone": $0.hiveMember.phone
        ]})
        
        members.append(contentsOf: phoneMembers)
        
        let swarm = userModel.swarms.map({[
            "swarm_id": $0.swarmId
        ]})
        
        let parameters = [
            
            "date": date,
            "from_time": startTime,
            "to_time": endTime,
            "title": title,
            "is_bizee": 1,
            "is_swarm": 1,
            "location": location != "Add Location" ? location : "A location has not been determined.",
            "host_notes": hostNotes,
            "members": members,
            "swarm_id": swarm,
            "background_color": backgroudColor
            
            ] as [String : AnyObject]
        
        return sendRequest(serviceName, parameters: parameters , methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func editEvent(eventId: Int, date: String, startTime: String, endTime: String, title: String, location: String, hostNotes: String, userModel: BizeeUserModel, backgroudColor: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "edit_event"
        
        var members = userModel.phoneContacts.map({[
            "guest_id": $0.id,
            "is_bizee": 0,
            "phone": $0.phone
            ]})
        
        let phoneMembers = userModel.hives.map({[
            "guest_id": $0.hiveMember.id,
            "is_bizee": 1,
            "phone": $0.hiveMember.phone
            ]})
        
        members.append(contentsOf: phoneMembers)
        
        let swarm = userModel.swarms.map({[
            "swarm_id": $0.swarmId
            ]})
        
        let parameters = [
            
            "id": eventId,
            "date": date,
            "from_time": startTime,
            "to_time": endTime,
            "title": title,
            "is_bizee": 1,
            "is_swarm": 1,
            "location": location != "Add Location" ? location : "TBA",
            "host_notes": hostNotes,
            "members": members,
            "swarm_id": swarm,
            "background_color": backgroudColor
            
            ] as [String : AnyObject]
        
        return sendRequest(serviceName, parameters: parameters , methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getEventData(hostId: Int, guestIds: [Int], eventDate: String, startTime: String, endTime: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "get_event_data"
        
        let parameters = [
            
            "host_id": hostId,
            "guests": guestIds,
            "event_date": eventDate,
            "start_time": startTime,
            "end_time": endTime
            
            ] as [String : AnyObject]
        
        return sendRequest(serviceName, parameters: parameters , methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func setEventStatus(status: Int, eventId: Int,  _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "set_event_response"

        let parameters = [
            
            "status": status,
            "event_id": eventId
            
            ] as [String : AnyObject]
        
        return sendRequest(serviceName, parameters: parameters, methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func editSwarm(swarmId: Int, title: String, aboutUs: String, colorCode: String, members: [HiveModel],  _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "edit_swarm"
        
        let membersDatasource = members.map({[
            "member": $0.hiveMember.id,
            ]})
        
        let parameters = [
            "swarm_id": swarmId,
            "title": title,
            "about_us": aboutUs,
            "background_color": colorCode,
            "foreground_color": colorCode,
            "members": membersDatasource
            ] as [String : AnyObject]
        
        return sendRequest(serviceName, parameters: parameters, methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func setUnfavorite(id: Int, type: String, _ completionBlock: @escaping APIClientCompletionHandler ) -> Request {
        
        let serviceName = "un_favorite"
        
        let parameters = [
            
            "type_id": id,
            "type": type
            
            ] as [String : AnyObject]
        
        return sendRequest(serviceName, parameters: parameters , methods: .delete, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func deleteComment(eventId: Int,commentId: Int, _ completionBlock: @escaping APIClientCompletionHandler ) -> Request {
        
        let serviceName = "delete_comment"
        
        let parameters = [
            
            "event_id": eventId,
            "comment_id": commentId
            
            ] as [String : AnyObject]
        
        
        return sendRequest(serviceName, parameters: parameters, methods: .delete, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func deleteEvent(id: Int, _ completionBlock: @escaping APIClientCompletionHandler ) -> Request {
        
        let serviceName = "delete_event?event_id=\(id)"
        
        
        return sendRequest(serviceName, parameters: nil , methods: .delete, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func leaveSwarm(id: Int, _ completionBlock: @escaping APIClientCompletionHandler ) -> Request {
        
        let serviceName = "leave_swarm?swarm_id=\(id)"
        
        return sendRequest(serviceName, parameters: nil , methods: .delete, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func deleteSwarm(id: Int, _ completionBlock: @escaping APIClientCompletionHandler ) -> Request {
        
        let serviceName = "delete_swarm?swarm_id=\(id)"
        
        return sendRequest(serviceName, parameters: nil , methods: .delete, headers: nil, completionBlock: completionBlock)
    }
    
    
//    ****************** GET ******************
    
    @discardableResult
    func getBizeeUsersList(userId: Int,pageNo: Int,limit: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_user_bizee_contacts?page=\(pageNo)&limit=\(limit)"
        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getPhoneContactsList(userId: Int,pageNo: Int,limit: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_user_phone_contacts?user_id=\(userId)&page=\(pageNo)&limit=\(limit)&ios=1"
        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getBizeeContactsList(userId: Int,pageNo: Int,limit: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_all_users?user_id=\(userId)&page=\(pageNo)&limit=\(limit)"
        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getMyProfile(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_my_profile"
        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getUserProfile(userId: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_user_profile?user_id=\(userId)"
        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getCoverColors(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_bg_color"
        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getOtherHive(userId: Int,pageNo: Int,limit: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_other_hive?user_id=\(userId)&page=\(pageNo)&limit=\(limit)"
        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getSwarm(page: Int , limit: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
    let serviceName = "get_swarm?page=\(page)&limit=\(limit)"
    
    return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getAllSettings(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_settings"

        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    @discardableResult
    func getHive(page: Int , limit: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_my_hive?page=\(page)&limit=\(limit)"
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func doGetCalender(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_user_calender?page=\(0)&limit=\(30)&date=\(Date().toString())"
        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func doGetBlockedUsers(page: Int , limit: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_blocked_users_new?page=\(page)&limit=\(limit)"
        
        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func doSearchBlockedUsersList(searchUser: String,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "search_blocked_users?search_term=\(searchUser)"
        
        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func doSearchSwarm(searchUser: String,page: Int,limit: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "search_swarm?search=\(searchUser)&page=\(page)&limit=\(limit)"
        
        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func searchFromAllExistingUsers(searchUser: String,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "search_all_existing_users?search_term=\(searchUser)"
        
        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func doSearchHive(searchUser: String,page: Int,limit: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "search_my_hive?search_term=\(searchUser)&page=\(page)&limit=\(limit)"
        
        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func doSearchOtherHive(searchUser: String,hiveId: Int,page: Int,limit: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "search_other_hive?search_term=\(searchUser)&hive_owner=\(hiveId)&page=\(page)&limit=\(limit)"
        
        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func doSearchContacts(searchUser: String,page: Int,limit: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "search_phone_contact?search_term=\(searchUser)&page=\(page)&limit=\(limit)&ios=1"
        
        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func doSearchBizeeContacts(searchUser: String,page: Int,limit: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "search_bizee_users?search_term=\(searchUser)&page=\(page)&limit=\(limit)"
        
        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func doGetNotifications(page: Int,limit: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_all_notification?page=\(page)&limit=\(limit)"
        
        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func twillioAuthInput(inputId: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "twilio_auth?input=\(inputId)"
     
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
//    **********************************************
    
    
    @discardableResult
    func getAllExistingUsers(page: Int , limit: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_all_existing_users?page=\(page)&limit=\(limit)"
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getEventDetails(eventId: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_event?event_id=\(eventId)"
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getUserCalender(page: Int , limit: Int, userDate : Date = Date(), _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: userDate)
        
        let serviceName = "get_user_calender_ios?page=\(page)&limit=\(limit)&date=\(date)"
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getMutualEvents(swarmId : Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_mutual_event_with_swarm?swarm_id=\(swarmId)&ios=1"
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getUserEvents(userId : Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_shared_event_with_user?user_id=\(userId)&ios=1"
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func searchUserCalendar(searchTerm: String , userDate : Date = Date(), _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: userDate)
        let serviceName = "search_user_calender_ios?search_term=\(searchTerm)&date=\(date)"
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getUserHiveStatus(members: [AttMember], _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_user_hive_status"
        
        var users = [Int]()
        users.removeAll()
        
        for member in members {
            users.append(member.id)
        }
        
        let parameters = [
            
            "users": users
            
            ] as [String : AnyObject]
        
        return sendRequest(serviceName, parameters: parameters , methods: .post, headers: nil, completionBlock: completionBlock)
    }
    
//    *******************Images Uploading************
    
    func uploadProfileImage(image: UIImage, _ completionBlock: @escaping (_ success: Bool, _ response: AnyObject?) -> Void ) {
        
        guard let url = URL(string: "\(kStagingBaseUrl)upload_user_profile") else {
            return
        }
        
        var token = ""
        if Utility.isKeyPresentInUserDefaults(key: kToken) {
            token = UserDefaults.standard.object(forKey: kToken) as! String
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "image.jpeg" , mimeType: "image/*")
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("proses", progress.fractionCompleted)
                })
                
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error {
                        print("upload:", err)
                        completionBlock(true, response.result.value! as AnyObject)
                        
                    }
                    
                    if let s = response.result.value {
                        print("RESULT:", s)
                        completionBlock(true, response.result.value as AnyObject?)
                        
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completionBlock(false, error as AnyObject)
            }
        }
    }
    
    func uploadSwarmCoverImage(image: UIImage, swarmId: Int, _ completionBlock: @escaping (_ success: Bool, _ response: AnyObject?) -> Void ) {
        
        guard let url = URL(string: "\(kStagingBaseUrl)upload_swarm_picture") else {
            return
        }
        
        let parameters = [
            
        "swarm_id" : swarmId
        
        ] as [String:Any]
        
        var token = ""
        if Utility.isKeyPresentInUserDefaults(key: kToken) {
            token = UserDefaults.standard.object(forKey: kToken) as! String
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "image.jpeg" , mimeType: "image/*")
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("proses", progress.fractionCompleted)
                })
                
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error {
                        print("upload:", err)
                        completionBlock(true, response.result.value! as AnyObject)
                        
                    }
                    
                    if let s = response.result.value {
                        print("RESULT:", s)
                        completionBlock(true, response.result.value as AnyObject?)
                        
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completionBlock(false, error as AnyObject)
            }
        }
    }
    
    func uploadEventCoverImage(image: UIImage, eventId: Int, _ completionBlock: @escaping (_ success: Bool, _ response: AnyObject?) -> Void ) {
        
        guard let url = URL(string: "\(kStagingBaseUrl)upload_event_image") else {
            return
        }
        
        let parameters = [
            
            "event_id" : eventId
            
            ] as [String:Any]
        
        var token = ""
        if Utility.isKeyPresentInUserDefaults(key: kToken) {
            token = UserDefaults.standard.object(forKey: kToken) as! String
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "image.jpeg" , mimeType: "image/*")
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("proses", progress.fractionCompleted)
                })
                
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error {
                        print("upload:", err)
                        completionBlock(true, response.result.value! as AnyObject)
                        
                    }
                    
                    if let s = response.result.value {
                        print("RESULT:", s)
                        completionBlock(true, response.result.value as AnyObject?)
                        
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completionBlock(false, error as AnyObject)
            }
        }
    }
    
    func addCommentWithImage(image: UIImage, eventId: Int,userId: Int, comment: String, _ completionBlock: @escaping (_ success: Bool, _ response: AnyObject?) -> Void ) {
        
        guard let url = URL(string: "\(kStagingBaseUrl)add_comment") else {
            return
        }
        
        let parameters = [
            
            "event_id": eventId,
            "user_id": userId,
            "comment": comment
            
            ] as [String:Any]
        
        var token = ""
        if Utility.isKeyPresentInUserDefaults(key: kToken) {
            token = UserDefaults.standard.object(forKey: kToken) as! String
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "image.jpeg" , mimeType: "image/*")
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("proses", progress.fractionCompleted)
                })
                
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error {
                        print("upload:", err)
                        completionBlock(true, response.result.value! as AnyObject)
                        
                    }
                    
                    if let s = response.result.value {
                        print("RESULT:", s)
                        completionBlock(true, response.result.value as AnyObject?)
                        
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completionBlock(false, error as AnyObject)
            }
        }
    }
    
    
//    ***********************************************
    @discardableResult
    func getFavorites(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        
        let serviceName = "get_favorites"
        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    @discardableResult
    func getSwarmById(swarmId: Int,_ completionBlock: @escaping APIClientCompletionHandler) -> Request{
        let serviceName = "get_swarm_by_id?swarm_id=\(swarmId)"
        
        return sendRequest(serviceName, parameters: nil , methods: .get, headers: nil, completionBlock: completionBlock)
    }
    
    
    
//
//    func uploadImage(image: UIImage, _ completionBlock: @escaping (_ success: Bool) -> Void ) {
//        let rotatedImage = image.rotateImage()
//
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(rotatedImage.jpeg(.lowest)!, withName: "image", fileName: "file.jpeg", mimeType: "image/jpeg")
//
//        }, to: URL(string: "\(kStagingBaseUrl)mover/uploadFile")!) { (result) in
//
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.uploadProgress(closure: { (progress) in
//                    print(progress)
//                })
//
//                upload.responseJSON { response in
//
//                    if let json = response.result.value as? [String:Any] {
//
//                        if let data = Mapper<ProfileImage>().map(JSONObject: json) {
//                            print(data.imageUrl)
//                            User.shared.profileImageURL = data.imageUrl
//                            UserDefaults.standard.set(data.imageUrl, forKey: kUserProfileImageUrl)
//                            completionBlock(true)
//                        }
//                    }
//                }
//
//            case .failure(let encodingError):
//                completionBlock(false)
//                //print encodingError.description
//            }
//        }
//    }
//
//    func uploadDocImage(image: UIImage, _ completionBlock: @escaping (_ success: Bool, _ imageUrl: String) -> Void ) {
//
//        let rotatedImage = image.rotateImage()
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(rotatedImage.jpeg(.lowest)!, withName: "image", fileName: "file.jpeg", mimeType: "image/jpeg")
//
//        }, to: URL(string: "\(kStagingBaseUrl)mover/uploadFile")!) { (result) in
//
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.uploadProgress(closure: { (progress) in
//                    print(progress)
//                })
//
//                upload.responseJSON { response in
//
//                    if let json = response.result.value as? [String:Any] {
//
//                        if let data = Mapper<ProfileImage>().map(JSONObject: json) {
//                            print(data.imageUrl)
//                            completionBlock(true, data.imageUrl)
//                        }
//
//                    } else {
//                        completionBlock(false, "")
//                    }
//                }
//
//            case .failure(let encodingError):
//                completionBlock(false, "")
//                //print encodingError.description
//            }
//        }
//    }
}
