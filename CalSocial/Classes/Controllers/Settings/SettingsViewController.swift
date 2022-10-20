//
//  SettingsViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 01/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class SettingsViewController: UIViewController {
    
    //MARK: - Variables
    var userName = ""
    
    var settingsDatasource = Mapper<Settings>().map(JSON: [:])!
    
    //MARK: - IBoutlets
    
    @IBOutlet weak var syncCalendar: UIButton!
    
    @IBOutlet weak var suggestionPrivacy: UIButton!
    
    @IBOutlet weak var profileVisibility: UIButton!
    
    @IBOutlet weak var notifications: UIButton!
    
    @IBOutlet weak var tour: UIButton!
    
    @IBOutlet weak var findFriends: UIButton!
    
    @IBOutlet weak var help: UIButton!
    
    @IBOutlet weak var privacyPolicy: UIButton!
    
    @IBOutlet weak var terms: UIButton!
    
    @IBOutlet weak var logout: UIButton!
    
    //MARK: - UIViewController Methods
    
    override func viewWillAppear(_ animated: Bool) {
        dogetMyAllSettings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        self.title = "Settings"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)) )
    }
    
    //MARK: - IBActions
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func syncCalendarTapped(_ sender: Any) {
        let sync = SyncCalenderViewController()
        sync.userName = self.userName
        self.navigationController?.pushViewController(sync, animated: true)
        
    }
    
    @IBAction func suggestionPrivacyTapped(_ sender: Any) {
        let suggestion = SocialHoursViewController()
        suggestion.settings = self.settingsDatasource
        self.navigationController?.pushViewController(suggestion, animated: true)
    }
    
    @IBAction func profileVisibilityTapped(_ sender: Any) {
        let privacyNavigation = SetPrivacyViewController()
        privacyNavigation.settings = self.settingsDatasource
        self.navigationController?.pushViewController(privacyNavigation, animated: true)
    }
    
    @IBAction func notificationsTapped(_ sender: Any) {
        let notifications = SettingNotificationsViewController()
        notifications.settings = self.settingsDatasource
        self.navigationController?.pushViewController(notifications, animated: true)
    }
    
    @IBAction func tourTapped(_ sender: Any) {
        let baseNavigation = BaseViewController()
        baseNavigation.isTour = true
        self.navigationController?.pushViewController(baseNavigation, animated: true)
    }
    
    @IBAction func findFriendsTapped(_ sender: Any) {
        let newEventViewController = AddNewContactViewController()
        newEventViewController.modalPresentationStyle = .fullScreen
        let newEventNavigationController = UINavigationController()
        newEventNavigationController.setupAppThemeNavigationBar()
        newEventViewController.findFriends = true
        newEventNavigationController.viewControllers = [newEventViewController]
        newEventNavigationController.modalPresentationStyle = .fullScreen
        self.present(newEventNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func helpTapped(_ sender: Any) {
        let contactUs = ContactUsViewController()
        self.navigationController?.pushViewController(contactUs, animated: true)
    }
    
    @IBAction func privacyPolicyTapped(_ sender: Any) {
    }
    
    @IBAction func termsTapped(_ sender: Any) {
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getAllSettings(){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            
            Utility.deleteAllUserDefaults()
            let navigationController = UINavigationController()
            navigationController.navigationBar.isTranslucent = false
            let baseViewController = BaseViewController()
            navigationController.viewControllers = [baseViewController]
            navigationController.navigationBar.isHidden = true
            UIApplication.shared.keyWindow!.replaceRootViewControllerWith(navigationController, animated: true, completion: nil)
        }
    }
    
    //MARK:- Private Methods
    
    func dogetMyAllSettings(){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getAllSettings(){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
            }
            else{
                
                if let data = Mapper<Settings>().map(JSONObject: result) {
                    self.settingsDatasource = data
                    
                }
            }
        }
    }
}
