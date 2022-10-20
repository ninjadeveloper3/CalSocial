//
//  EventDetailsModel.swift
//  CalSocial
//
//  Created by DevBatch on 09/01/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class EventDetailsModel: Mappable {
    
    var eventDetails = Mapper<EventDetails>().map(JSON: [:])!
    var allData = Mapper<EventAllData>().map(JSON: [:])!
    var isConflict = -1
    var status = -1
    var isOwner = -1
    var unreadDot = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        eventDetails    <-  map["eventDetails"]
        allData         <-  map["allData"]
        isConflict      <-  map["is_conflict"]
        status          <-  map["my_status"]
        isOwner         <-  map["is_owner"]
        unreadDot         <-  map["unreadComment"]
    }
}

class EventDetails: Mappable {
    

    var id = 0
    var userId = 0
    var coverPicture = ""
    var eventDate = ""
    var startTime = "00:00:00"
    var endTime = "00:00:00"
    var title = ""
    var location = ""
    var notes = "I hope this date and time work for you.  Just message me if you have any questions, or leave a comment here, Cheers!"
    var isUnreadComment = 0
    var ownerImage = ""
    var status = ""
    var backgroundColor = ""
    var eventMembers = [EventMembers]()
    var eventComments = [EventComments]()
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        userId          <-  map["user_id"]
        coverPicture    <-  map["cover_photo"]
        eventDate       <-  map["event_date"]
        startTime       <-  map["start_time"]
        endTime         <-  map["end_time"]
        title           <-  map["title"]
        location        <-  map["location"]
        notes           <-  map["notes"]
        isUnreadComment <-  map["notify_status"]
        ownerImage      <-  map["owner.profile_picture"]
        status          <-  map["status"]
        backgroundColor <-  map["background_color"]
        eventMembers    <-  map["event_members"]
        eventComments   <-  map["event_comment"]
    }
}

class EventMembers: Mappable {
    
    var id = 0
    var userId = 0
    var eventId = 0
    var status = 0
    var going = 0
    var isBizee = true
    var firstName = ""
    var lastName = ""
    var profilePicture = ""
    var role = 0
    var color = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        userId          <-  map["user_id"]
        eventId         <-  map["event_id"]
        status          <-  map["status"]
        going           <-  map["going_status"]
        isBizee         <-  map["is_bizee"]
        firstName       <-  map["first_name"]
        lastName        <-  map["last_name"]
        profilePicture  <-  map["profile_picture"]
        role            <-  map["role"]
        color           <-  map["color"]
    }
}

class EventComments: Mappable {
    
    var id = 0
    var eventId = ""
    var userId = 0
    var userName = ""
    var color = ""
    var firstName = ""
    var lastName = ""
    var comment = ""
    var image = ""
    var profilePic = ""
    var createdAt = ""
    var isOwner = 0

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        eventId         <-  map["event_id"]
        userId          <-  map["user_id"]
        userName        <-  map["user_name"]
        color        <-  map["color"]
        comment         <-  map["comment"]
        image           <-  map["image"]
        profilePic      <-  map["profile_picture"]
        createdAt       <-  map["created_at"]
        isOwner         <-  map["is_owner"]
        firstName       <-  map["first_name"]
        lastName        <-  map["last_name"]
    }
}

class EventAllData: Mappable {
    
    var going = 0
    var maybe = 0
    var notGoing = 0
    var noResponse = 0
    var invited = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        going       <-  map["going"]
        maybe       <-  map["maybe"]
        notGoing    <-  map["not_going"]
        invited  <-  map["total_invited"]
    }
}

