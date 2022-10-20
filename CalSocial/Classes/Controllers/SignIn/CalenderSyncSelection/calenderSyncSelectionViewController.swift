//
//  calenderSyncSelectionViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 30/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import EventKit
import ObjectMapper

class calenderSyncSelectionViewController: UIViewController {

    //MARK: - Varibales
    
    var eventStore = EKEventStore()
    var calendarArray:[EKCalendar]!
    var calendarDatasouce = [CalendarEvents]()
    
    
    //MARK: - IBOutlets
    override func viewDidLoad() {
        super.viewDidLoad()
        eventStore = EKEventStore.init()
        
        

        // Do any additional setup after loading the view.
    }


    //MARK: - IBAction Methods
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
//        checkCalendarAuthorizationStatus()
        
        eventStore.requestAccess(to: .event, completion: {
            (granted, error) in
            
            if granted {
                print("granted \(granted)")
                self.fetchEvents()
            }else {
                print("error \(error!)")
            }
            
        })
//        self.navigationController?.pushViewController(CreateEventsViewController(), animated: true)
    }
    
    func setUpTabController(isCreateEvent: Bool) {
        Utility.setUpNavDrawerController(isCreateEvent: isCreateEvent)
        self.present(Utility.tabController, animated: true, completion: nil)
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        setUpTabController(isCreateEvent: false)
    }
    
    //MARK: - Private Methods
    
    
    func fetchEvents(){
        
        // Date
        let now = Date()
        let calendar = Calendar.current
        var dateComponents = DateComponents.init()
        dateComponents.year = 1 // how many
        let date2daysFromNow = calendar.date(byAdding: dateComponents, to: now)
        
        // Calendars
        self.calendarArray = self.eventStore.calendars(for: .event)
        
        for calendar in self.calendarArray {
            
            let eventsPredicate = self.eventStore.predicateForEvents(withStart: now, end: date2daysFromNow!, calendars: [calendar])
            
            let events = self.eventStore.events(matching: eventsPredicate)
            
            print("calendar: \(calendar.title)")
            
            for event in events{
                let eventObject = Mapper<CalendarEvents>().map(JSON: [:])!
//                eventObject.startDate = event.startDate
//                eventObject.startTime = event.startDate
////                eventObject.endTime = event.startDate
                eventObject.startDate = event.startDate.toString()
                eventObject.startTime = event.startDate.timeFormatter()
                eventObject.endTime =   event.endDate.timeFormatter()
                eventObject.eventTitle = event.title
                calendarDatasouce.append(eventObject)
                print("event: \(event.title!)")
                
            }
        }
        doSaveCalendarApi()
    }
    func doSaveCalendarApi(){
        
        APIClient.sharedClient.saveCalendarEvents(eventsList: calendarDatasouce){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: false)
                
            } else {
                self.navigationController?.pushViewController(CreateEventsViewController(), animated: true)
            }
        }
    }
}
