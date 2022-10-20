//
//  UserCalender.swift
//  CalSocial
//
//  Created by DevBatch on 10/01/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class UserCalender: Mappable {
    
    var date = ""
    var phoneEventData = [PhoneEventData]()
    var bizeeEventData = [BizeeEventData]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
     
        date            <-  map["date"]
        phoneEventData  <-  map["phoneEventData"]
        bizeeEventData  <-  map["bizeeEventData"]
    }
}

class PhoneEventData: Mappable {
    
    var id = 0
    var title = ""
    var startDate = ""
    var startTime = ""
    var endTime = ""
    var allDay = 0
    var users = Mapper<SwarmUser>().map(JSON: [:])!
    
    required init?(map: Map) {
       
    }
    
    func mapping(map: Map) {
        
        id          <-  map["id"]
        title       <-  map["title"]
        startDate   <-  map["start_date"]
        startTime   <-  map["start_time"]
        endTime     <-  map["end_time"]
        allDay     <-  map["all_day"]
        users       <-  map["users"]
        
    }
}

class BizeeEventData: Mappable {
    
    var id = 0
    var title = ""
    var location = ""
    var notes = ""
    var status : EventStatus = .didntJoin
    var eventDate = ""
    var startTime = ""
    var endTime = ""
    var backgroundColor = ""
    var coverPicture = ""
    var myStatus : EventStatus = .didntJoin
    var eventId = 0
    var members = [MembersData]()
    var swarms = Mapper<SwarmsData>().map(JSON: [:])!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        eventId         <-  map["event_id"]
        title           <-  map["title"]
        location        <-  map["location"]
        notes           <-  map["notes"]
        startTime       <-  map["start_time"]
        endTime         <-  map["end_time"]
        eventDate       <-  map["event_date"]
        status          <-  map["status"]
        myStatus        <-  map["my_status"]
        backgroundColor <-  map["background_color"]
        coverPicture   <-  map["cover_photo"]
        members        <-  map["members"]
        swarms         <-  map["swarms"]
    }
}

class MembersData: Mappable {
    
    var id = 0
    var role = 0
    var status = 0
    var isBizee = Bool()
    var phoneUsers = Mapper<PhoneUser>().map(JSON: [:])!
    var users = Mapper<UserData>().map(JSON: [:])!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id          <-  map["user_id"]
        role       <-  map["role"]
        status   <-  map["status"]
        isBizee   <-  map["is_bizee"]
        phoneUsers   <-  map["phoneguest"]
        users     <-  map["single_member"]
    }
}

class UserData: Mappable {
    
    var id = 0
    var firstName = ""
    var lastName = ""
    var profilePicture = ""
    var color = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        firstName       <-  map["first_name"]
        lastName        <-  map["last_name"]
        profilePicture  <-  map["profile_picture"]
        color           <-  map["color"]
    }
}

class PhoneUser: Mappable {
    
    var id = 0
    var firstName = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        firstName       <-  map["name"]
    }
}

class SwarmsData: Mappable {
    
    var id = 0
    var creator = 0
    var title = ""
    var members = [Members]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id          <-  map["user_id"]
        creator     <-  map["swarm_creator"]
        title       <-  map["title"]
        members     <-  map["members"]
    }
}

//class SwarmsModel: Mappable {
//
//
//    var title = ""
//    var member = [MemberDetails]()
//
//    required init?(map: Map) {
//
//    }
//
//    func mapping(map: Map) {
//
//        title      <-  map["title"]
//        member      <-  map["members"]
//    }
//}

class Members: Mappable {
    
    
    var role = 0
    var firstName = ""
    var lastName = ""
    var profilePic = ""
    var color = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        role      <-  map["role"]
        firstName      <-  map["user.first_name"]
        lastName      <-  map["user.last_name"]
        profilePic      <-  map["user.profile_picture"]
        color      <-  map["user.color"]
    }
}
