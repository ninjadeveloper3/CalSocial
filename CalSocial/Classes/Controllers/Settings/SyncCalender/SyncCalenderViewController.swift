//
//  SyncCalenderViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 01/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import EventKit
import ObjectMapper

class SyncCalenderViewController: UIViewController {
    
    //MARK: - Variables
    
    var eventStore = EKEventStore()
    var calendarArray:[EKCalendar]!
    var calendarDatasouce = [CalendarEvents]()
    var calenderDataSource = Mapper<CalenderModel>().map(JSON: [:])!
    var userName = ""
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var calenderImage: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var calenderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - UIViewController Methods
    
    func setUpViewController() {
        
        doCheckMyCalenderExist()
        
        self.title = "Sync Calendar"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        
    }
    
    //MARK: - Private Methods
    
    func doCheckMyCalenderExist(){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.doGetCalender(){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
            }
            else{
                
                if let data = Mapper<CalenderModel>().map(JSONObject: result) {
                    self.calenderDataSource = data
                    if !self.calenderDataSource.isCalenderSynced{
                        self.calenderImage.isHidden = true
                        self.removeButton.isHidden  = true
                        self.calenderLabel.text = "None added yet"
                        self.calenderLabel.textAlignment = .center
                    }
                    else{
                        self.calenderImage.isHidden = false
                        self.removeButton.isHidden  = false
                        self.calenderLabel.text = self.userName+"'s Calender"
                    }
                    
                }
            }
        }
    }
    
    @IBAction func syncCalenderTapped(_ sender: Any) {
        if !self.calenderDataSource.isCalenderSynced {
            eventStore.requestAccess(to: .event, completion: {
                (granted, error) in
                
                if granted {
                    print("granted \(granted)")
                    self.fetchEvents()
                }else {
                    print("error \(error!)")
                }
                
            })
        }
        else{
            NSError.showErrorWithMessage(message: "Calender already synced!", viewController: self, type: .success, isNavigation: true)
        }
    }
    
    
    @IBAction func removeTapped(_ sender: Any) {
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.removeMyCalender(){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
            }
            else{
                self.setUpViewController()
            }
        }
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
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
            for event in events {
                let eventObject = Mapper<CalendarEvents>().map(JSON: [:])!
                eventObject.startDate = event.startDate.toString()
                eventObject.startTime = event.startDate.timeFormatter()
                eventObject.endTime =   event.endDate.timeFormatter()
                eventObject.eventTitle = event.title
                calendarDatasouce.append(eventObject)
            }
        }
        doSaveCalendarApi()
    }
    
    func doSaveCalendarApi(){
        
        APIClient.sharedClient.saveCalendarEvents(eventsList: calendarDatasouce){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.setUpViewController()
                NotificationCenter.default.post(name: Notification.Name("NewEventCreated"), object: nil, userInfo: nil)
            }
        }
    }
}
