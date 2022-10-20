//
//  NotificationsViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 02/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

import ObjectMapper

class NotificationsViewController: UIViewController {
    
    //MARK: - Variables
    
    var notificationsDataSource = [NotificationsModel]()
    
    var isDataLoading:Bool=false
    
    var pageNo : Int = 1
    
    var limit : Int = 100
    
    var offset : Int = 0 //pageNo*limit
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var NotificationController: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNotificationList(pageNo: pageNo, limit: limit, isAppear: true)
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        NotificationController.delegate = self
        NotificationController.dataSource = self
        NotificationController.separatorStyle = .none
        self.navigationItem.title = "Notifications"
        self.notificationsDataSource.removeAll()
    }
    
    //MARK: - Private Methods
    
    @objc func editButtonTapped(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getNotificationList(pageNo: Int, limit: Int, isAppear: Bool){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.doGetNotifications(page: pageNo, limit: limit) { (response, result, error, message) in
            if isAppear {
                self.notificationsDataSource.removeAll()
            }
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self,isNavigation: true)
                
            } else {
                if let data = Mapper<NotificationsModel>().mapArray(JSONObject: result) {
                    if data.count > 0 {
                        self.notificationsDataSource.append(contentsOf: data)
                        var isunread = false
                        for count in self.notificationsDataSource {
                            if count.status == 0 {
                                isunread = true
                                break
                            }
                        }
                        if !isunread {
                            if  let arrayOfTabBarItems = self.tabBarController?.tabBar.items as AnyObject as? NSArray, let tabBarItem = arrayOfTabBarItems[4] as? UITabBarItem {
                                tabBarItem.badgeValue = ""
                                tabBarItem.badgeColor = .clear
                            }
                        }
                        self.NotificationController.reloadData()
                    }
                }
            }
        }
    }
    
    func readNotification(notificationId: Int){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.doReadNotifications(notificationId: notificationId) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self,isNavigation: true)
                
            } else {
                
            }
        }
    }
    @IBAction func createEventButtonTapped(_ sender: Any) {
        let newEventViewController = EventFormViewController()
        let newEventNavigationController = UINavigationController()
        newEventNavigationController.setupAppThemeNavigationBar()
        newEventViewController.emptyEventForm = true
        newEventNavigationController.viewControllers = [newEventViewController]
        self.present(newEventNavigationController, animated: true, completion: nil)
        
    }
    
    func doDeleteNotification(notificationId: Int){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.deleteNotification(notificationId: notificationId) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self,isNavigation: true)
                
            } else {
                self.notificationsDataSource = self.notificationsDataSource.filter({$0.id != notificationId})
                
                self.NotificationController.reloadData()
            }
        }
    }
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.notificationsDataSource.count
            
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let notificationCell = NotificationsTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            notificationCell.loadCell(dataSource: notificationsDataSource[indexPath.row])
            return notificationCell
            
        } else {
            let dummyCell = DummyTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            return dummyCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let row = notificationsDataSource[indexPath.row]
            if row.status == 0 {
                self.readNotification(notificationId: row.id)
            }
            switch notificationsDataSource[indexPath.row].notificationType{
            case 0:
                //hive request received
                
                let userProfileViewController = UserProfileViewController()
                let profileNavigationController = UINavigationController()
                profileNavigationController.setupAppThemeNavigationBar()
                userProfileViewController.userId = row.fromId
                userProfileViewController.userName = row.title
                userProfileViewController.firstName = row.title
                userProfileViewController.profileType = .AcceptDecline
                profileNavigationController.viewControllers = [userProfileViewController]
                self.present(profileNavigationController, animated: true, completion: nil)
                
                break;
                
            case 1:
                //Event Invite
                let newEventViewController = EventOwnerViewController()
                newEventViewController.id = row.event.id
                newEventViewController.eventTitle = row.event.title
                newEventViewController.isEventInvite = true
                let peventNavigationController = UINavigationController()
                peventNavigationController.setupAppThemeNavigationBar()
                peventNavigationController.viewControllers = [newEventViewController]
                
                self.present(peventNavigationController, animated: true, completion: nil)
                
                break;
            case 2:
                //New message
                break;
            case 3:
                //Event Cancel
                break;
            case 4:
                //You are added in Swarm
                
                let swarmBaseViewController = SwarmBaseViewController()
                swarmBaseViewController.swarmId = row.fromId
                swarmBaseViewController.swarmTitle = row.title
                let swarmBaseNavigationController = UINavigationController()
                swarmBaseNavigationController.setupAppThemeNavigationBar()
                swarmBaseNavigationController.viewControllers = [swarmBaseViewController]
                self.present(swarmBaseNavigationController, animated: true, completion: nil)
                break;
            case 5:
                //Hive request Accepted
                
                let userProfileViewController = UserProfileViewController()
                let profileNavigationController = UINavigationController()
                profileNavigationController.setupAppThemeNavigationBar()
                userProfileViewController.userId = row.fromId
                userProfileViewController.userName = row.title
                userProfileViewController.firstName = row.title
                userProfileViewController.profileType = .InHive
                profileNavigationController.viewControllers = [userProfileViewController]
                self.present(profileNavigationController, animated: true, completion: nil)
                break;
            case 6:
                //You are removed from an event
                break;
            case 7:
                //Event Updated
                let newEventViewController = EventOwnerViewController()
                let newEventNavigationController = UINavigationController()
                newEventNavigationController.setupAppThemeNavigationBar()
                newEventViewController.id = row.event.id
                newEventViewController.eventTitle = row.event.title
                newEventNavigationController.viewControllers = [newEventViewController]
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.present(newEventNavigationController, animated: true, completion: nil)
                }
                break;
            case 8:
                //Comment on an Event
                let newEventViewController = EventOwnerViewController()
                let newEventNavigationController = UINavigationController()
                newEventNavigationController.setupAppThemeNavigationBar()
                newEventViewController.id = row.event.id
                newEventViewController.eventTitle = row.event.title
                newEventNavigationController.viewControllers = [newEventViewController]
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.present(newEventNavigationController, animated: true, completion: nil)
                }
                break;
            case 9:
                //owner updated the swarm, should navigate to swarm
                let swarmBaseViewController = SwarmBaseViewController()
                swarmBaseViewController.swarmId = row.fromId
                swarmBaseViewController.swarmTitle = row.title
                let swarmBaseNavigationController = UINavigationController()
                swarmBaseNavigationController.setupAppThemeNavigationBar()
                swarmBaseNavigationController.viewControllers = [swarmBaseViewController]
                self.present(swarmBaseNavigationController, animated: true, completion: nil)
                
                break;
                
            case 10,11:
                //Event Update
                let newEventViewController = EventOwnerViewController()
                newEventViewController.id = row.event.id
                newEventViewController.eventTitle = row.event.title
                newEventViewController.isEventInvite = true
                let peventNavigationController = UINavigationController()
                peventNavigationController.setupAppThemeNavigationBar()
                peventNavigationController.viewControllers = [newEventViewController]
                
                self.present(peventNavigationController, animated: true, completion: nil)
                
                break;
            default:
                
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 1 {
            return UISwipeActionsConfiguration()
        }
        let deleteAction =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
            self.doDeleteNotification(notificationId: self.notificationsDataSource[indexPath.row].id)
            completionHandler(true)
        })
        deleteAction.image = #imageLiteral(resourceName: "cross-color")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8274844289, green: 0.379353106, blue: 0.209089905, alpha: 1)
        let confrigation = UISwipeActionsConfiguration(actions: [deleteAction])
        return confrigation
    }
}
