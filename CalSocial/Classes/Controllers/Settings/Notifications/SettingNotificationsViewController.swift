//
//  SettingNotificationsViewController.swift
//  CalSocial
//
//  Created by DevBatch on 25/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class SettingNotificationsViewController: UIViewController {

    //MARK: - Variables
    
    var settings = Mapper<Settings>().map(JSON: [:])!
    
    //MARK: - IBoutlets
    
    @IBOutlet weak var pauseAllNotifications: UISwitch!
    
    @IBOutlet weak var directMessages: UISwitch!
    
    @IBOutlet weak var hiveNotifications: UISwitch!
    
    @IBOutlet weak var eventNotifications: UISwitch!
    
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        self.title = "Notifications"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)) )
        if(settings.directMessageNotification && settings.hiveNotifications && settings.eventNotifications) {
            pauseAllNotifications.isOn = true
        }
        directMessages.isOn = settings.directMessageNotification
        hiveNotifications.isOn = settings.hiveNotifications
        eventNotifications.isOn = settings.eventNotifications
    }
    
    //MARK: - IBActions
    
    @IBAction func pauseAllNotificationsChanged(_ sender: UISwitch) {
        if sender.isOn{
            directMessages.isOn = true
            hiveNotifications.isOn = true
            eventNotifications.isOn = true
            
            settings.directMessageNotification = true
            settings.hiveNotifications = true
            settings.eventNotifications = true
        }
        else{
            directMessages.isOn = false
            hiveNotifications.isOn = false
            eventNotifications.isOn = false
            
            settings.directMessageNotification = false
            settings.hiveNotifications = false
            settings.eventNotifications = false
        }
    }
    
    @IBAction func directMessagesChanged(_ sender: UISwitch) {
        if sender.isOn{
            if hiveNotifications.isOn && eventNotifications.isOn {
            pauseAllNotifications.isOn = true
            }
            settings.directMessageNotification = true
        }
        else{
            pauseAllNotifications.isOn = false
            settings.directMessageNotification = false
        }
    }
    
    @IBAction func hiveConnectionsChanged(_ sender: UISwitch) {
        if sender.isOn{
            if directMessages.isOn && eventNotifications.isOn {
                pauseAllNotifications.isOn = true
            }
            settings.hiveNotifications = true
        }
        else{
            pauseAllNotifications.isOn = false
            settings.hiveNotifications = false
        }
    }
    
    @IBAction func eventNotificationsChanged(_ sender: UISwitch) {
        if sender.isOn{
            if hiveNotifications.isOn && directMessages.isOn {
                pauseAllNotifications.isOn = true
            }
            settings.eventNotifications = true
        }
        else{
            pauseAllNotifications.isOn = false
            settings.eventNotifications = false
        }
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.setNotificationsSettings(options: settings){ (response, result, error, message) in
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
