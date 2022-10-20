//
//  AppDelegate.swift
//  CalSocial
//
//  Created by DevBatch on 27/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GooglePlaces
import OneSignal
import UserNotifications
import ObjectMapper

protocol MainAppDelegate {
    func didPresentNotification()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    var mainDelegate : MainAppDelegate?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false,
                                     kOSSettingsKeyInAppAlerts: false,
                                     kOSSettingsKeyInAppLaunchURL: false]

        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "20ddadea-59e3-4b67-9851-6ddea81d9c56",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification

        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        MessagingManager.sharedManager().connectClientWithCompletion { (success, error) in
            
            if error != nil {
                print("///////////////////////Error////////////////////")
                
            } else {
                
            }
        }
        
        setUpAppLibraries()
        setUpApplication()
        setupPushNotification(application: application)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register push notification \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) { completionHandler([.alert,.sound])
        mainDelegate?.didPresentNotification()
        print("\n Register push notification \(notification)\n")
        debugPrint("Centre \(center)")
        if  let arrayOfTabBarItems = Utility.tabController.tabBar.items as AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[4] as? UITabBarItem {
            
            tabBarItem.badgeValue = "●"
            tabBarItem.badgeColor = .clear
            tabBarItem.setBadgeTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.red], for: .normal)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        if  let arrayOfTabBarItems = Utility.tabController.tabBar.items as AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[4] as? UITabBarItem {
            
            tabBarItem.badgeValue = "●"
            tabBarItem.badgeColor = .clear
            tabBarItem.setBadgeTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.red], for: .normal)
        }
        
        
        if let notification = userInfo["custom"] as? NSDictionary {
            
            print("Notification: \(notification)")
            
            if let data = Mapper<NotificationsModel>().map(JSONObject: notification) {
                Utility.isAPNs = true
                if  let arrayOfTabBarItems = Utility.tabController.tabBar.items as AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[4] as? UITabBarItem {
                    
                    tabBarItem.badgeValue = "●"
                    tabBarItem.badgeColor = .clear
                    tabBarItem.setBadgeTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): #colorLiteral(red: 0.8274844289, green: 0.379353106, blue: 0.209089905, alpha: 1)], for: .normal)
                }
                switch data.apnsNotificationType{
                case 0:
                    //hive request received
                    
                    let visibaleViewController = Utility.getVisibleViewController(self.window?.rootViewController)
                    let userProfileViewController = UserProfileViewController()
                    let navigationController = UINavigationController()
                    
                    userProfileViewController.userId = data.fromId
                    userProfileViewController.userName = data.title
                    userProfileViewController.firstName = data.title
                    userProfileViewController.profileType = .AcceptDecline
                    
                    navigationController.setupAppThemeNavigationBar()
                    navigationController.viewControllers = [userProfileViewController]
                    
                    visibaleViewController?.present(navigationController, animated: true, completion: nil)
                    
                    break;
                    
                case 1:
                    //Event Invite
                    
                    let visibaleViewController = Utility.getVisibleViewController(self.window?.rootViewController)
                    let newEventViewController = EventOwnerViewController()
                    let navigationController = UINavigationController()
                    
                    newEventViewController.id = data.event.id
                    newEventViewController.eventTitle = data.event.title
                    newEventViewController.isEventInvite = true
                    
                    navigationController.setupAppThemeNavigationBar()
                    navigationController.viewControllers = [newEventViewController]
                    visibaleViewController?.present(navigationController, animated: true, completion: nil)
                    
//                    self.present(peventNavigationController, animated: true, completion: nil)
                    
                    break;
                case 2:
                    //New message
                    break;
                case 3:
                    //Event Cancel
                    break;
                case 4:
                    //You are added in Swarm
                    
                    
                    let visibaleViewController = Utility.getVisibleViewController(self.window?.rootViewController)
                    let swarmBaseViewController = SwarmBaseViewController()
                    let navigationController = UINavigationController()
                    swarmBaseViewController.swarmId = data.fromId
                    swarmBaseViewController.swarmTitle = data.title
                    
                    navigationController.setupAppThemeNavigationBar()
                    navigationController.viewControllers = [swarmBaseViewController]
                    visibaleViewController?.present(navigationController, animated: true, completion: nil)
                    
//                    self.present(swarmBaseNavigationController, animated: true, completion: nil)
                    break;
                case 5:
                    //Hive request Accepted
                    
                    
                    let visibaleViewController = Utility.getVisibleViewController(self.window?.rootViewController)
                    let userProfileViewController = UserProfileViewController()
                    let navigationController = UINavigationController()
                    userProfileViewController.userId = data.fromId
                    userProfileViewController.userName = data.title
                    userProfileViewController.firstName = data.title
                    userProfileViewController.profileType = .InHive
                    
                    navigationController.setupAppThemeNavigationBar()
                    navigationController.viewControllers = [userProfileViewController]
                    visibaleViewController?.present(navigationController, animated: true, completion: nil)
                    
//                    self.present(profileNavigationController, animated: true, completion: nil)
                    break;
                case 6:
                    //You are removed from an event
                    break;
                case 7:
                    //Event Updated
                    break;
                case 8:
                    //Comment on an Event
                    break;
                case 9:
                    //owner updated the swarm, should navigate to swarm
                    
                    let visibaleViewController = Utility.getVisibleViewController(self.window?.rootViewController)
                    let swarmBaseViewController = SwarmBaseViewController()
                    let navigationController = UINavigationController()
                    swarmBaseViewController.swarmId = data.fromId
                    swarmBaseViewController.swarmTitle = data.title
                    
                    navigationController.setupAppThemeNavigationBar()
                    navigationController.viewControllers = [swarmBaseViewController]
                    visibaleViewController?.present(navigationController, animated: true, completion: nil)
                    
//                    self.present(swarmBaseNavigationController, animated: true, completion: nil)
                    
                    break;
                    
                case 10,11:
                    //Event Update
                    let visibaleViewController = Utility.getVisibleViewController(self.window?.rootViewController)
                    let newEventViewController = EventOwnerViewController()
                    let navigationController = UINavigationController()
                    newEventViewController.id = data.event.id
                    newEventViewController.eventTitle = data.event.title
                    navigationController.setupAppThemeNavigationBar()
                    navigationController.viewControllers = [newEventViewController]
                    
                    visibaleViewController?.present(navigationController, animated: true, completion: nil)
                    
                    break;
                    
                default:
                    
                    break
                }
                
            }
            
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        debugPrint("Data: \(response)")
        
        if  let arrayOfTabBarItems = Utility.tabController.tabBar.items as AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[4] as? UITabBarItem {
            
            tabBarItem.badgeValue = "●"
            tabBarItem.badgeColor = .clear
            tabBarItem.setBadgeTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): #colorLiteral(red: 0.8274844289, green: 0.379353106, blue: 0.209089905, alpha: 1)], for: .normal)
        }
        print("Did Recive push notification:  \(response.notification.request.content.userInfo)")
        
        if let notification = response.notification.request.content.userInfo["custom"] as? NSDictionary {
            
            print("Notification: \(notification)")
            
            if let data = Mapper<NotificationsModel>().map(JSONObject: notification["a"]) {
                
                print("Data: \(data)")
            }
            
        }
    }
    
    func setUpAppLibraries() {
        IQKeyboardManager.shared.enable = true
        GMSPlacesClient.provideAPIKey("AIzaSyBOuTUEwBF4kBmTAOTQ3LR_QnB_CxtlkZU")
    }
    
    func setUpApplication() {
        if #available(iOS 13.0, *) {
//            window?.overrideUserInterfaceStyle = .light
        }
        
        if Utility.isKeyPresentInUserDefaults(key: kToken) {
            Utility.setUpNavDrawerController()
            window?.rootViewController = Utility.tabController

        } else {
            let navigationController = UINavigationController()
            let baseViewController = BaseViewController()
            navigationController.navigationBar.isHidden = true
            navigationController.viewControllers = [baseViewController]
            window?.rootViewController = navigationController
        }
    }
    
    func setupPushNotification(application: UIApplication) {
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        UIApplication.shared.applicationIconBadgeNumber = 0
        center.removeAllDeliveredNotifications()
        
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
    }
}

