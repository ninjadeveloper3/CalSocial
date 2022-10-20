//
//  SocialHoursViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 08/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class SocialHoursViewController: UIViewController {
    
    //MARK:- Variables
    
    var settings = Mapper<Settings>().map(JSON: [:])!
    
    var slots = [BizeeSuggestions]()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var allowSuggest: UISwitch!
    
    //Social Hours Outlets
    @IBOutlet weak var monMorning: UIButton!
    @IBOutlet weak var friMorning: UIButton!
    @IBOutlet weak var satMorning: UIButton!
    @IBOutlet weak var sunMorning: UIButton!
    
    @IBOutlet weak var monAfternoon: UIButton!
    @IBOutlet weak var friAfternoon: UIButton!
    @IBOutlet weak var satAfternoon: UIButton!
    @IBOutlet weak var sunAfternoon: UIButton!
    
    @IBOutlet weak var monEvening: UIButton!
    @IBOutlet weak var friEvening: UIButton!
    @IBOutlet weak var satEvening: UIButton!
    @IBOutlet weak var sunEvening: UIButton!
    
    @IBOutlet weak var monNight: UIButton!
    @IBOutlet weak var friNight: UIButton!
    @IBOutlet weak var satNight: UIButton!
    @IBOutlet weak var sunNight: UIButton!
    
    
    //Work Hours
    
    @IBOutlet weak var monMorningWork: UIButton!
    @IBOutlet weak var friMorningWork: UIButton!
    @IBOutlet weak var satMorningWork: UIButton!
    @IBOutlet weak var sunMorningWork: UIButton!
    
    @IBOutlet weak var monAfternoonWork: UIButton!
    @IBOutlet weak var friAfternoonWork: UIButton!
    @IBOutlet weak var satAfternoonWork: UIButton!
    @IBOutlet weak var sunAfternoonWork: UIButton!
    
    @IBOutlet weak var monEveningWork: UIButton!
    @IBOutlet weak var friEveningWork: UIButton!
    @IBOutlet weak var satEveningWork: UIButton!
    @IBOutlet weak var sunEveningWork: UIButton!
    
    @IBOutlet weak var monNightWork: UIButton!
    @IBOutlet weak var friNightWork: UIButton!
    @IBOutlet weak var satNightWork: UIButton!
    @IBOutlet weak var sunNightWork: UIButton!
    
    
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func radioButtonTapped(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            
        } else {
            sender.isSelected = true
            sender.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        doUpdateDataModel(sender: sender)
    }
    
    //MARK: Private Methods
    
    func doUpdateDataModel(sender: UIButton){
        switch sender {
            
            //Social Hours
            //type 1 for social and 2 for work
            
        case monMorning:
            if sender.isSelected && monMorningWork.isSelected{
                monMorningWork.isSelected = false
                monMorningWork.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender, slot: 1, day: 4, type: 1)
        case friMorning:
            if sender.isSelected && friMorningWork.isSelected{
                friMorningWork.isSelected = false
                friMorningWork.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 1, day: 1, type: 1)
        case satMorning:
            if sender.isSelected && satMorningWork.isSelected{
                satMorningWork.isSelected = false
                satMorningWork.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 1, day: 2, type: 1)
        case sunMorning:
            if sender.isSelected && sunMorningWork.isSelected{
                sunMorningWork.isSelected = false
                sunMorningWork.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 1, day: 3, type: 1)
            
        case monAfternoon:
            if sender.isSelected && monAfternoonWork.isSelected{
                monAfternoonWork.isSelected = false
                monAfternoonWork.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 2, day: 4, type: 1)
        case friAfternoon:
            if sender.isSelected && friAfternoonWork.isSelected{
                friAfternoonWork.isSelected = false
                friAfternoonWork.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 2, day: 1, type: 1)
        case satAfternoon:
            if sender.isSelected && satAfternoonWork.isSelected{
                satAfternoonWork.isSelected = false
                satAfternoonWork.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 2, day: 2, type: 1)
        case sunAfternoon:
            if sender.isSelected && sunAfternoonWork.isSelected{
                sunAfternoonWork.isSelected = false
                sunAfternoonWork.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 2, day: 3, type: 1)
            
        case monEvening:
            if sender.isSelected && monEveningWork.isSelected{
                monEveningWork.isSelected = false
                monEveningWork.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 3, day: 4, type: 1)
        case friEvening:
            if sender.isSelected && friEveningWork.isSelected{
                friEveningWork.isSelected = false
                friEveningWork.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 3, day: 1, type: 1)
        case satEvening:
            if sender.isSelected && satEveningWork.isSelected{
                satEveningWork.isSelected = false
                satEveningWork.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 3, day: 2, type: 1)
        case sunEvening:
            if sender.isSelected && sunEveningWork.isSelected{
                sunEveningWork.isSelected = false
                sunEveningWork.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 3, day: 3, type: 1)
            
        case monNight:
            if sender.isSelected && monNightWork.isSelected{
                monNightWork.isSelected = false
                monNightWork.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 4, day: 4, type: 1)
        case friNight:
            if sender.isSelected && friNightWork.isSelected{
                friNightWork.isSelected = false
                friNightWork.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 4, day: 1, type: 1)
        case satNight:
            if sender.isSelected && satNightWork.isSelected{
                satNightWork.isSelected = false
                satNightWork.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 4, day: 2, type: 1)
        case sunNight:
            if sender.isSelected && sunNightWork.isSelected{
                sunNightWork.isSelected = false
                sunNightWork.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 4, day: 3, type: 1)
            
            //Work Hours
        
        case monMorningWork:
            if sender.isSelected && monMorning.isSelected{
                monMorning.isSelected = false
                monMorning.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender, slot: 1, day: 4, type: 2)
        case friMorningWork:
            if sender.isSelected && friMorning.isSelected{
                friMorning.isSelected = false
                friMorning.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 1, day: 1, type: 2)
        case satMorningWork:
            if sender.isSelected && satMorning.isSelected{
                satMorning.isSelected = false
                satMorning.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 1, day: 2, type: 2)
        case sunMorningWork:
            if sender.isSelected && sunMorning.isSelected{
                sunMorning.isSelected = false
                sunMorning.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 1, day: 3, type: 2)
            
        case monAfternoonWork:
            if sender.isSelected && monAfternoon.isSelected{
                monAfternoon.isSelected = false
                monAfternoon.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 2, day: 4, type: 2)
        case friAfternoonWork:
            if sender.isSelected && friAfternoon.isSelected{
                friAfternoon.isSelected = false
                friAfternoon.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 2, day: 1, type: 2)
        case satAfternoonWork:
            if sender.isSelected && satAfternoon.isSelected{
                satAfternoon.isSelected = false
                satAfternoon.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 2, day: 2, type: 2)
        case sunAfternoonWork:
            if sender.isSelected && sunAfternoon.isSelected{
                sunAfternoon.isSelected = false
                sunAfternoon.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 2, day: 3, type: 2)
            
        case monEveningWork:
            if sender.isSelected && monEvening.isSelected{
                monEvening.isSelected = false
                monEvening.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 3, day: 4, type: 2)
        case friEveningWork:
            if sender.isSelected && friEvening.isSelected{
                friEvening.isSelected = false
                friEvening.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 3, day: 1, type: 2)
        case satEveningWork:
            if sender.isSelected && satEvening.isSelected{
                satEvening.isSelected = false
                satEvening.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 3, day: 2, type: 2)
        case sunEveningWork:
            if sender.isSelected && sunEvening.isSelected{
                sunEvening.isSelected = false
                sunEvening.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 3, day: 3, type: 2)
            
        case monNightWork:
            if sender.isSelected && monNight.isSelected{
                monNight.isSelected = false
                monNight.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 4, day: 4, type: 2)
        case friNightWork:
            if sender.isSelected && friNight.isSelected{
                friNight.isSelected = false
                friNight.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 4, day: 1, type: 2)
        case satNightWork:
            if sender.isSelected && satNight.isSelected{
                satNight.isSelected = false
                satNight.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 4, day: 2, type: 2)
        case sunNightWork:
            if sender.isSelected && sunNight.isSelected{
                sunNight.isSelected = false
                sunNight.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            }
            updateData(sender: sender,slot: 4, day: 3, type: 2)
            
        default:
            print("default")
        }
    }
    
    func updateData(sender: UIButton, slot: Int, day: Int, type: Int){
    
        let object = Mapper<BizeeSuggestions>().map(JSON: [:])!
        if sender.isSelected { //add item in data model
            
            if slots.count > 0 {
                
                for item in slots {
                    if type == 1 {
                        if item.slot == slot && item.day == day && item.status == 2 {
                            if let index = slots.firstIndex(where: { $0.slot == item.slot &&  $0.day == item.day && $0.status == 2}) {
                                print("to remove",index)
                                slots.remove(at: index)
                            }
                        }
                    }
                    else{
                        if item.slot == slot && item.day == day && item.status == 1 {
                            if let index = slots.firstIndex(where: { $0.slot == item.slot &&  $0.day == item.day && $0.status == 1}) {
                                print("to remove",index)
                                slots.remove(at: index)
                            }
                        }
                    }
                }
                object.slot = slot
                object.day = day
                object.status = type
                slots.append(object)
            }
            else{
                object.slot = slot
                object.day = day
                object.status = type
                slots.append(object)
            }
            
            
        }
        else{ //remove item from data model
            for item in slots {
                if item.slot == slot && item.day == day && item.status == type {
                    if let index = slots.firstIndex(where: { $0.slot == item.slot &&  $0.day == item.day && $0.status == type}) {
                        print("to remove",index)
                        slots.remove(at: index)
                    }
                }
            }
        }
    }
    
    //MARK: - UIViewController Methods
    
    func setUpViewController() {
        
        self.title = "Set Your Social Hours"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        allowSuggest.isOn = settings.allowSuggest
        
        if settings.socialHours.count > 0 || settings.workHours.count > 0{
            setSocialHours()
        }
        
    }
    
    func setSocialHours() {
        if settings.socialHours.count > 0 {
            for hour in settings.socialHours {
                let object = Mapper<BizeeSuggestions>().map(JSON: [:])!
                object.slot = hour.slot
                object.day = hour.day
                object.status = hour.status
                slots.append(object)
                self.mapDataToSelection(slot: hour.slot, day: hour.day, type: hour.status)
            }
        }
        if settings.workHours.count > 0 {
            for hour in settings.workHours {
                let object = Mapper<BizeeSuggestions>().map(JSON: [:])!
                object.slot = hour.slot
                object.day = hour.day
                object.status = hour.status
                slots.append(object)
                self.mapDataToSelection(slot: hour.slot, day: hour.day, type: hour.status)
            }
        }
        
    }
    
    func mapDataToSelection(slot: Int, day: Int, type: Int){
        
        //Social Hours
        
        if (slot == 1 && day == 4 && type == 1){
            monMorning.isSelected = true
            monMorning.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 1 && day == 1 && type == 1){
            friMorning.isSelected = true
            friMorning.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 1 && day == 2 && type == 1){
            satMorning.isSelected = true
            satMorning.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 1 && day == 3 && type == 1){
            sunMorning.isSelected = true
            sunMorning.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 2 && day == 4 && type == 1){
            monAfternoon.isSelected = true
            monAfternoon.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 2 && day == 1 && type == 1){
            friAfternoon.isSelected = true
            friAfternoon.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 2 && day == 2 && type == 1){
            satAfternoon.isSelected = true
            satAfternoon.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 2 && day == 3 && type == 1){
            sunAfternoon.isSelected = true
            sunAfternoon.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 3 && day == 4 && type == 1){
            monEvening.isSelected = true
            monEvening.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 3 && day == 1 && type == 1){
            friEvening.isSelected = true
            friEvening.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 3 && day == 2 && type == 1){
            satEvening.isSelected = true
            satEvening.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 3 && day == 3 && type == 1){
            sunEvening.isSelected = true
            sunEvening.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 4 && day == 4 && type == 1){
            monNight.isSelected = true
            monNight.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 4 && day == 1 && type == 1){
            friNight.isSelected = true
            friNight.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 4 && day == 2 && type == 1){
            satNight.isSelected = true
            satNight.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 4 && day == 3 && type == 1){
            sunNight.isSelected = true
            sunNight.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        
        //Work Hours
        
        if (slot == 1 && day == 4 && type == 2){
            monMorningWork.isSelected = true
            monMorningWork.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 1 && day == 1 && type == 2){
            friMorningWork.isSelected = true
            friMorningWork.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 1 && day == 2 && type == 2){
            satMorningWork.isSelected = true
            satMorningWork.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 1 && day == 3 && type == 2){
            sunMorningWork.isSelected = true
            sunMorningWork.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 2 && day == 4 && type == 2){
            monAfternoonWork.isSelected = true
            monAfternoonWork.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 2 && day == 1 && type == 2){
            friAfternoonWork.isSelected = true
            friAfternoonWork.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 2 && day == 2 && type == 2){
            satAfternoonWork.isSelected = true
            satAfternoonWork.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 2 && day == 3 && type == 2){
            sunAfternoonWork.isSelected = true
            sunAfternoonWork.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 3 && day == 4 && type == 2){
            monEveningWork.isSelected = true
            monEveningWork.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 3 && day == 1 && type == 2){
            friEveningWork.isSelected = true
            friEveningWork.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 3 && day == 2 && type == 2){
            satEveningWork.isSelected = true
            satEveningWork.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 3 && day == 3 && type == 2){
            sunEveningWork.isSelected = true
            sunEveningWork.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 4 && day == 4 && type == 2){
            monNightWork.isSelected = true
            monNightWork.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 4 && day == 1 && type == 2){
            friNightWork.isSelected = true
            friNightWork.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 4 && day == 2 && type == 2){
            satNightWork.isSelected = true
            satNightWork.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        if (slot == 4 && day == 3 && type == 2){
            sunNightWork.isSelected = true
            sunNightWork.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
    }
    
    @IBAction func allowSuggestChanged(_ sender: UISwitch) {
        var allowSuggest = 0
        if sender.isOn {
            print("on")
            allowSuggest = 1
        }
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.setAllowSuggest(status: allowSuggest){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
            }
            else{
                
            }
        }
    }
    
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.setSocialHours(hours: slots){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
            }
            else{
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
