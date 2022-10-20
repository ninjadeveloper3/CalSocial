//
//  LCConstants.swift
//  passManager
//
//  Created by Usama on 6/19/17.
//  Copyright © 2017 Usama. All rights reserved.
//

import Foundation
import UIKit

enum LCMessageType: Int {
    case error = 0
    case success
    case info
}

enum EventStatus: Int {
    case didntJoin = 0
    case joined = 1
    case maybe = 2
    case waiting = 3
}

enum ProfileType: Int {
    case AcceptDecline 
    case InHive
    case RequestSent
    case UserProfile
    case AddHive
    
}

enum EventSchedule: Int {
    case Date
    case StartTime
    case EndTime
}

enum MemberRoles: Int {
    case SwarmOwner = 1
    case HiveMember = 2
    case NotHiveMember = 3
}

enum BTMessageType: String {
    case normal = "NORMAL_MESSAGE_TYPE"
    case leave = "LEAVE_MESSAGE_TYPE"
    case header = "DATE_HEADER"
}

let kIsUserLoggedIn = "kIsUserLoggedIn"
let kLiveBaseUrl = ""
let kStagingBaseUrl = "https://bizee-api-staging.onrender.com/api/"
let kLocalUrl = "http://192.168.0.11:8080/api/"
let kImageLocalUrl = "http://192.168.0.11:8080/storage/"
let kImageStagingUrl = "https://bizee-api-staging.onrender.com/storage/"
let kImageDownloadBaseUrl = kImageStagingUrl
let kJobAddress = "kJobAddress"
let kShouldLoadRejectJobData = "kShouldLoadRejectJobData"
let kLat = "KLat"
let KLong = "KLong"
let kDuration = "KDuration"
let kDescription = "kDescription"
let kStartTime = "kStartTime"
let kUserFirstName = "kUserFirstName"
let kUserLastName = "kUserLastName"
let kUserEmail = "kUserEmail"
let kUserId = "kUserId"
let kUserMobile = "kUserMobile"
let kUserProfileImageUrl = "kUserProfileImageUrl"
let kIsCardInfoAdded = "kIsCardInfoAdded"
let kSession = "kSession"
let kUserName = "kUserName"
let kProfileImage = "kProfileImage"
let kServicesOffered = "kServicesOffered"
let kHourlyRate = "kHourlyRate"
let kToken  = "kToken"
let kUserColorCode = "kUserColorCode"
let kDeviceToken = "kDeviceToken"

enum BadgePosition: String {
    case topRight
    case topLeft
    case right
    case left
}

enum AlertRemove: Int {
    case RemoveHive
    case LeaveSwarm
    case DeleteSwarm
    case CancelEvent
}

// NSNotification
enum NotificationType: String {
    case jobChat = "jobChat"
    case jobOffer = "jobOffer"
    case jobRemove = "userRemovedJob"
    case jobCancelled = "userCancelledJob"
    case jobTimeOut = "spJobTimeOut"
    case accountBlock = "accountBlock"
    case accountUnblock = "accountUnblock"
    case accountRejected = "accountRejected"
    case accountAccepted = "accountAccepted"
    case SomeDummyIdentifier = "SomeDummyIdentifier"
}

let kLCDidTapHomeNotification = "kLCDidTapHomeNotification"
let kLCAppDidEnterForeground = "kLCAppDidEnterForeground"
let KLCReloadJobsNotification = "KLCReloadJobsNotification"
let kLCJobRejectedNotification = "kLCJobRejectedNotification"
let kLCLabourCompletedWorkNotification = "kLCLabourCompletedWorkNotification"
let kLCLabourOnWayNotification = "kLCLabourOnWayNotification"
let kLCJobCanceledNotification = "kLCJobCanceledNotification"
let kLCJobAcceptedNotification = "kLCJobAcceptedNotification"
let kLCJobClosedNotification = "kLCJobClosedNotification"
let kLCHomeJobRejectedNotification = "kLCHomeJobRejectedNotification"
let kLCHomeJobAcceptedNotification = "kLCHomeJobAcceptedNotification"
let kLCLabourStartedWorkNotification = "kLCLabourStartedWorkNotification"
let kLCLabourReachedNotification = "kLCLabourReachedNotification"
let kLCResetFiltersNotification = "kLCResetFiltersNotification"
let kLCNewMessageWhileChatingNotificaton = "kLCNewMessageWhileChatingNotificaton"
let kLCRefreshscheduledJobsNotification = "kLCRefreshscheduledJobsNotification"
let kLCUpdateBadgeValueNotification = "kLCUpdateBadgeValueNotification"

let kNewMessagePush = "Your received a message on "

// MARK: - Images

let kHamburgerImage = "icon_menu"
let kDoneNavigationBarImage = "icon_done"
let kFilterNavigationBarImage = "filter"
let kMarkerImage = "labour_icon"
let kPointerImage = "pointer"
let kAddCardImage = "add_card"
let kNonActiveCardImage = "non_active_card"
let kActiveCardImage =  "active_card"
let kCancelImage = "cancel"
let kSendButtonImage = "message_send_btn"
let kCalendarImage = "icon_date_time"
let kLocationImage = "icon_location"
let kLocationImage1 = "icon_location_2"
let kLocationImage2 = "icon_location_3"
let kLocationImage3 = "icon_location_4"

let kNoJobsImage = "no_scheduled_jobs"
let kDefaultCard = "default_card"
let kNoMessageImage = "no_msg"

let kCornerRadius : CGFloat = 2.0
var kOffSet = 20
let kLocation = "location"
let kSavedCookies = "savedCookies"
let kChatToken = "chatToken"

let kNotificationLoadDoneJobs = "kNotificationLoadDoneJobs"
let kNotificationChangeBarButton = "kNotificationChangeBarButton"
let kNotificationUpdateProfileImage = "kNotificationUpdateProfileImage"
let kNotificationOpenPaymentiewController = "kNotificationOpenPaymentiewController"

let kIsChatThreadCreated = "kIsChatThreadCreated"
let kErrorSessionExpired = "User is not authenticated."
