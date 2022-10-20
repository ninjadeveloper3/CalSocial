//
//  Utility.swift
//  passManager
//
//  Created by Usama on 6/19/17.
//  Copyright © 2017 Usama. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import BRYXBanner
import ObjectMapper
import UserNotifications
import NVActivityIndicatorView
import AudioToolbox
import AVFoundation
import EventKit

class Utility : NSObject {
    
    static var player: AVAudioPlayer?
    
    static var tabController = CurvedTabBarController()
    
    static var isContactsEditable = false
    
    static var isProfileEdit = false
    
    static var isAPNs = false
    
    static var isEventStatusChange = false

    class func addEventInCal(viewController: UIViewController, eventTitle: String, date: String, startTime: String, endTime: String) -> String {
        var id = ""        
        let startString = "\(date) \(startTime)"
        let endString = "\(date) \(endTime)"
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startDate = format.date(from: startString)
        let endDate = format.date(from: endString)
        
        let store = EKEventStore()
        store.requestAccess(to: .event) { (granted, error) in
            if !granted { return }
            let event = EKEvent(eventStore: store)
            event.title = eventTitle
            event.startDate = startDate
            event.endDate = endDate
            event.calendar = store.defaultCalendarForNewEvents
            do {
                try store.save(event, span: .thisEvent, commit: true)
                id = event.eventIdentifier
                
            } catch {
                NSError.showErrorWithMessage(message: "Unable to add event in iCal", viewController: viewController, type: .error, isNavigation: true)
            }
        }
         return id
    }
    
    class func setUpNavDrawerController(isCreateEvent: Bool = false) {
        
        tabController = CurvedTabBarController()
        
        tabController.modalPresentationStyle = .fullScreen
        
        let homeViewController = HomeViewController()
        homeViewController.isCreateEvent = isCreateEvent
        homeViewController.view.isUserInteractionEnabled = true
        homeViewController.modalPresentationStyle = .fullScreen
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "Home-1"), selectedImage: #imageLiteral(resourceName: "Home-1"))
        
        
        let contactViewController  = ContactsViewController()
        contactViewController.view.isUserInteractionEnabled = true
        contactViewController.modalPresentationStyle = .fullScreen
        contactViewController.tabBarItem = UITabBarItem(title: "Contacts", image: #imageLiteral(resourceName: "Layer 2 (1)"), selectedImage: #imageLiteral(resourceName: "Layer 2 (1)"))
        
        
        let inboxViewController = InboxViewController()
        inboxViewController.view.isUserInteractionEnabled = true
        inboxViewController.modalPresentationStyle = .fullScreen
        inboxViewController.tabBarItem = UITabBarItem(title: "Messages", image: #imageLiteral(resourceName: "Messages (1)"), selectedImage: #imageLiteral(resourceName: "Messages (1)"))
        
        let notificationViewController = NotificationsViewController()
        notificationViewController.view.isUserInteractionEnabled = true
        notificationViewController.modalPresentationStyle = .fullScreen
        notificationViewController.tabBarItem = UITabBarItem(title: "Notifications", image: #imageLiteral(resourceName: "Notifications"), selectedImage: #imageLiteral(resourceName: "Notifications"))
        
        let homeNavigationController = UINavigationController()
        homeNavigationController.navigationBar.isTranslucent = false
        homeNavigationController.setupAppThemeNavigation()
        homeNavigationController.viewControllers = [homeViewController]
        
        let contactNavigationController = UINavigationController()
        contactNavigationController.navigationBar.isTranslucent = false
        contactNavigationController.setupAppThemeNavigationBar()
        contactNavigationController.viewControllers = [contactViewController]
        
        let inboxNavigationController = UINavigationController()
        inboxNavigationController.navigationBar.isTranslucent = false
        inboxNavigationController.setupAppThemeNavigationBar()
        inboxNavigationController.viewControllers = [inboxViewController]
        
        let notificationNavigationController = UINavigationController()
        notificationNavigationController.navigationBar.isTranslucent = false
        notificationNavigationController.setupAppThemeNavigationBar()
        notificationNavigationController.viewControllers = [notificationViewController]
        
        
        
        tabController.viewControllers =
            [
                homeNavigationController,
                contactNavigationController,
                UINavigationController(),
                inboxNavigationController,
                notificationNavigationController
            ]
        
        if  let arrayOfTabBarItems = tabController.tabBar.items as AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[2] as? UITabBarItem {
            tabBarItem.isEnabled = false
        }
        
        var totalUnreadNotifications = 0
        APIClient.sharedClient.doGetNotifications(page: -1, limit: 1000) { (response, result, error, message) in

            if error != nil {
                
            } else {
                if let data = Mapper<NotificationsModel>().mapArray(JSONObject: result) {
                    if data.count > 0 {
                        for count in data{
                            if count.status == 0 {
                                totalUnreadNotifications+=1
                            }
                        }
                        if totalUnreadNotifications > 0 || isAPNs {
                            isAPNs = false
                            if  let arrayOfTabBarItems = tabController.tabBar.items as AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[4] as? UITabBarItem {
                                
                                tabBarItem.badgeValue = "●"
                                tabBarItem.badgeColor = .clear
                                tabBarItem.setBadgeTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): #colorLiteral(red: 0.8274844289, green: 0.379353106, blue: 0.209089905, alpha: 1)], for: .normal)
                            }
                        }
                    }
                }
            }
        }

        tabController.selectedIndex = 0
        tabController.tabBar.tintColor = #colorLiteral(red: 1, green: 0.7616637349, blue: 0.04396914691, alpha: 1)
        tabController.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }

    
    class func deviceUUID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    class func saveStringToUserDefaults(_ value: String?, Key: String) {
        
        if value != nil {
            UserDefaults.standard.set(value, forKey: Key)
            //UserDefaults.standard.synchronize()
        }
    }
    
    class func presentAlertOnViewController(_ title:String, message:String, viewController:UIViewController){
        
        let alertViewController = MBAlertViewController(title: title, message: message, style: .alert)
        let okAction = MBAlertAction(title: "Ok", style: .default) { (action) in
            
        }
        
        alertViewController.addAction(okAction)
        viewController.present(alertViewController, animated: true, completion: nil)
    }
    
    class func emptyTableViewMessage(imageName: String, message:String, isBannerView: Bool, viewController: UIViewController, tableView:UITableView) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewController.view.bounds.size.width, height: viewController.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.appThemeFontWithSize(15.0)
        messageLabel.sizeToFit()
        
        let noJobsView = NoJobsViews.instanceFromNib()
        noJobsView.imageView.image = UIImage(named: imageName)
        noJobsView.messageLabel.text = message
        noJobsView.messageLabel.font = UIFont.appThemeFontWithSize(15.0)
        
        tableView.backgroundView = noJobsView
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }
    
    class func emptyTableViewMessageWithImage(imageName: String, message: String, isBannerView: Bool, bannerText: String, viewController: UIViewController, tableView: UITableView) {
        let noJobsView = NoJobsViews.instanceFromNib()
        noJobsView.imageView.image = UIImage(named: imageName)
        noJobsView.messageLabel.text = message
        noJobsView.messageLabel.font = UIFont.appThemeFontWithSize(15.0)
        
        if isBannerView {
            noJobsView.bannerLabel.isHidden = false
            noJobsView.bannerView.isHidden = false
            noJobsView.bannerLabel.text = bannerText
            
        }
        
        tableView.backgroundView = noJobsView
        tableView.separatorStyle = .none
    }
    
    class func emptyHiveTableViewMessageWithImage(viewController: UIViewController, tableView: UITableView) {
        let noJobsView = HiveEmptyView.instanceFromNib()
        tableView.backgroundView = noJobsView
        tableView.separatorStyle = .none
    }
    
    class func emptycollectionViewMessageWithImage(message:String, collectionView: UICollectionView) {
        let noJobsView = NoJobsViews.instanceFromNib()
        noJobsView.imageView.image = UIImage(named: kNoMessageImage)
        noJobsView.messageLabel.text = message
        noJobsView.messageLabel.font = UIFont.appThemeFontWithSize(15.0)
        
        collectionView.backgroundView = noJobsView
    }
    
    class func unsycedSwarmTableView(label: String, titleButton: String,  viewController: UIViewController, tableView: UITableView) {
        
        let noJobsView = SwarmEmptyView.instanceFromNib()
        noJobsView.createSwarmButton.setTitle(titleButton, for: .normal)
        noJobsView.swarmLabel.text = label
        noJobsView.delegate = viewController as! SwarmEmptyViewDelegate 
        tableView.backgroundView = noJobsView
        tableView.separatorStyle = .none
    }
    
    class func unsycedSwarmTableView( viewController: UIViewController, tableView: UITableView) {
        
        let noJobsView = HiveEmptyView.instanceFromNib()
        tableView.backgroundView = noJobsView
        tableView.separatorStyle = .none
    }
    
    class func getUserModel() -> AttMember {
    
        let user = Mapper<AttMember>().map(JSON: [:])!
        
        if let id = UserDefaults.standard.object(forKey: kUserId) as? Int {
            user.id = id
        }
        var fname = ""
        var lname = ""
        if let name = UserDefaults.standard.object(forKey: kUserFirstName) as? String {
            fname = name
        }
        if let name = UserDefaults.standard.object(forKey: kUserLastName) as? String {
            lname = name
        }
        user.name = "\(fname) \(lname)"
        return user
    }
    
    
    class func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    class func getScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    class func isiphone5() -> Bool {
        
        if self.getScreenHeight() == 568 { // Iphone 5
            
            return true
        }
        return false
    }
    
    class func isiphone6() -> Bool {
        
        if self.getScreenHeight() == 667 { // Iphone 6/7
            return true
        }
        return false
    }
    
    class func isiphone6Plus() -> Bool {
        
        if self.getScreenHeight() == 736 { // Iphone 6+/ 7+
            return true
        }
        
        return false
    }
    
    class func isiphoneX() -> Bool {
        
        switch UIScreen.main.nativeBounds.height {  // Iphone X, XS, XS Max
        
        case 2436: // iPhone X, XS
            return true
            
        case 2688: // iPhone XS Max
            return true
            
        case 1792: // iPhone XR
            return true
            
        default:
            return false
        }
    }
    
    class func saveCookies(response: DataResponse<Any>) {
        
        if let headerFields = response.response?.allHeaderFields as? [String: String] {
            let url = response.response?.url
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url!)
            var cookieArray = [[HTTPCookiePropertyKey: Any]]()
            for cookie in cookies {
                cookieArray.append(cookie.properties!)
            }
            UserDefaults.standard.set(cookieArray, forKey: kSavedCookies)
            UserDefaults.standard.synchronize()
        }
    }
    
    class func loadCookies() {
        guard let cookieArray = UserDefaults.standard.array(forKey: kSavedCookies) as? [[HTTPCookiePropertyKey: Any]] else { return }
        for cookieProperties in cookieArray {
            if let cookie = HTTPCookie(properties: cookieProperties) {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }
    }
    
    class func removedCookies() {
        UserDefaults.standard.removeObject(forKey: kSavedCookies)
        UserDefaults.standard.synchronize()
    }
    
    class func openDialerWith(number phoneNumber: String) {
        
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    class func saveUserDataInDefaults(user: MMUser) {
        
        User.shared.firstName = user.firstName
        User.shared.lastName = user.lastName
        User.shared.email = user.email
        User.shared.mobileNumber = user.mobileNumber
        User.shared.id = user.id
        User.shared.profileImageURL = user.profileImageURL
        
        UserDefaults.standard.set(user.firstName, forKey: kUserFirstName)
        UserDefaults.standard.set(user.lastName, forKey: kUserLastName)
        UserDefaults.standard.set(user.email, forKey: kUserEmail)
        UserDefaults.standard.set(user.mobileNumber, forKey: kUserMobile)
        UserDefaults.standard.set(user.id, forKey: kUserId)
        UserDefaults.standard.set(user.profileImageURL, forKey: kUserProfileImageUrl)
    }
    
    class func getUserDataFromDefaults() {
        
        if let name = UserDefaults.standard.value(forKey: kUserFirstName) as? String {
            User.shared.firstName = name
        }
        
        if let name = UserDefaults.standard.value(forKey: kUserLastName) as? String {
            User.shared.lastName = name
        }
        
        if let email = UserDefaults.standard.value(forKey: kUserEmail) as? String {
            User.shared.email = email
        }
        
        if let mobileNumber = UserDefaults.standard.value(forKey: kUserMobile) as? String {
            User.shared.mobileNumber = mobileNumber
        }
        
        if let id = UserDefaults.standard.value(forKey: kUserId) as? String {
            User.shared.id = id
        }
        
        if let imageUrl = UserDefaults.standard.value(forKey: kUserProfileImageUrl) as? String {
            User.shared.profileImageURL = imageUrl
        }
    }
    
    
    class func formattedDateForMessage() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, hh:mma"
        return dateFormatter.string(from: Date())
        
    }
    
    class func showInAppNotification(title: String, message: String, identifier: String, userInfo: [AnyHashable: Any] = [:]) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = UNNotificationSound.default
        content.userInfo = userInfo
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    class func showBanner(titile: String = "", message: String) {
        let banner = Banner(title: titile, subtitle: message, image: nil, backgroundColor: UIColor.notificationBackgroundColor())
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
    
    class func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        
        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if rootVC?.presentedViewController == nil {
            return rootVC
        }
        
        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return getVisibleViewController(presented)
        }
        return nil
    }
    
    class func showLoading(viewController: UIViewController) {
        DispatchQueue.main.async {
            let superView = UIView(frame: CGRect(x: self.getScreenWidth()/2 - 35, y: self.getScreenHeight()/2 - 50, width: 70, height: 70))
            let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: superView.frame.width/2 - 20, y: superView.frame.height/2 - 20, width: 40, height: 40))
            
            // superView.center = viewController.view.center
            superView.backgroundColor = UIColor.lightGray
            superView.layer.cornerRadius = 10
            superView.tag = 9000
            
            activityIndicator.type = .ballTrianglePath
            activityIndicator.color = UIColor.appThemeColor()
            activityIndicator.startAnimating()
            
            superView.addSubview(activityIndicator)
            superView.bringSubviewToFront(activityIndicator)
            
            viewController.view.addSubview(superView)
            viewController.view.bringSubviewToFront(superView)
            viewController.view.setNeedsLayout()
            viewController.view.setNeedsDisplay()
        }
    }
    
    class func playNewJobSound() {
        guard let url = Bundle.main.url(forResource: "labourSound", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.stop()
            guard let player = player else { return }
            
            player.play()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    class func stopNewJobSound() {
        
        if player != nil {
            player?.stop()
        }
    }
    
    class func clearUser() {
        //User.shared.categories = Mapper<LCCategories>().map(JSONObject: [:])!
        User.shared.email = ""
        User.shared.id = ""
        User.shared.isChating = false
        User.shared.mobileNumber = ""
        User.shared.firstName = ""
        User.shared.lastName = ""
        User.shared.profileImageURL = ""
        
        UserDefaults.standard.removeObject(forKey: kShouldLoadRejectJobData)
        UserDefaults.standard.removeObject(forKey: kShouldLoadRejectJobData)
        UserDefaults.standard.removeObject(forKey: kIsUserLoggedIn)
        UserDefaults.standard.removeObject(forKey: kIsCardInfoAdded)
        UserDefaults.standard.removeObject(forKey: kUserId)
        UserDefaults.standard.removeObject(forKey: kUserId)
        UserDefaults.standard.removeObject(forKey: kUserId)
        UserDefaults.standard.removeObject(forKey: kUserId)
        UserDefaults.standard.removeObject(forKey: kUserId)
        UserDefaults.standard.removeObject(forKey: kUserId)
        UserDefaults.standard.removeObject(forKey: kUserId)
        UserDefaults.standard.removeObject(forKey: kUserId)
        UserDefaults.standard.removeObject(forKey: kUserId)
        
    }
    
    class func deleteAllUserDefaults() {
        UserDefaults.standard.removeObject(forKey: kToken)
        UserDefaults.standard.removeObject(forKey: kUserId)
        UserDefaults.standard.removeObject(forKey: kUserFirstName)
        UserDefaults.standard.removeObject(forKey: kUserLastName)
        UserDefaults.standard.removeObject(forKey: kUserColorCode)
        UserDefaults.standard.removeObject(forKey: kUserProfileImageUrl)
        UserDefaults.standard.set(false, forKey: kDeviceToken)
        UserDefaults.standard.removeObject(forKey: kUserEmail)
        UserDefaults.standard.removeObject(forKey: kUserMobile)
        UserDefaults.standard.synchronize()
    }
    
    class func hideLoading(viewController: UIViewController) {
        DispatchQueue.main.async {
            if let activityView = viewController.view.viewWithTag(9000) {
                activityView.removeFromSuperview()
            }
        }
    }
    
    class func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    class func showInAppNotification(title: String, message: String, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = UNNotificationSound.default
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    class func showSuccess(viewController: UIViewController, labelText: String, completion: @escaping () -> ()) {
        let superView = UIView(frame: CGRect(x: viewController.view.frame.width/2 , y: viewController.view.frame.height/2 , width: 180, height: 150))
        let imageView = UIImageView(frame: CGRect(x: superView.frame.width/2 - 35, y: superView.frame.height/2 - 35 , width: 70, height: 70))
        
        let label = UILabel(frame: CGRect(x: 0, y: imageView.frame.height + 35 , width: 180, height: 45))
        
        label.text = labelText
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 2
        imageView.image = UIImage(named:"circle_tick")
        
        superView.center = CGPoint(x: viewController.view.bounds.width/2 , y: viewController.view.bounds.height/2)
        superView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        superView.layer.cornerRadius = 10
        superView.tag = 8000
        
        superView.addSubview(imageView)
        superView.bringSubviewToFront(imageView)
        
        superView.addSubview(label)
        superView.bringSubviewToFront(label)
        
        viewController.view.addSubview(superView)
        viewController.view.bringSubviewToFront(superView)
        
        // remove from super view after durations
        let delay = DispatchTime.now() + Double(Int64(3.0 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            
            if let activityView = viewController.view.viewWithTag(8000) {
                activityView.removeFromSuperview()
                completion()
            }
        }
    }
    
}
