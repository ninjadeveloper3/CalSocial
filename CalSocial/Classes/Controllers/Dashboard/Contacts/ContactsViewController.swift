//
//  ContactsViewController.swift
//  CalSocial
//
//  Created by DevBatch on 30/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import CarbonKit

class ContactsViewController: UIViewController {
    
    //MARK: - Variables
    
    let items = ["Hive","Swarms"]
    
    var selectedIndex = 0
    
    var isAddContact = false
    
    var carbonTabSwipeNavigation =  CarbonTabSwipeNavigation()
    
    //MARK: - Outlets
    
    @IBOutlet weak var createEventButton: MBButton!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setupViewController() {
        
        self.navigationItem.title = "Contacts"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped(sender:)) )
        self.navigationItem.leftBarButtonItem?.setFontStyle()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Plus"), style: .plain, target: self, action: #selector(addNewContactButtonTapped(sender:)))
        
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNavigation.setSelectedColor(#colorLiteral(red: 0.4391649365, green: 0.4392448664, blue: 0.4391598701, alpha: 1), font: UIFont.muliBold(18.0))
        carbonTabSwipeNavigation.setNormalColor(#colorLiteral(red: 0.7646217346, green: 0.764754355, blue: 0.7646133304, alpha: 1), font: UIFont.muliRegular(18.0))
        carbonTabSwipeNavigation.setIndicatorColor(#colorLiteral(red: 1, green: 0.7616637349, blue: 0.04396914691, alpha: 1))
        carbonTabSwipeNavigation.toolbar.tintColor = #colorLiteral(red: 1, green: 0.7616637349, blue: 0.04396914691, alpha: 1)
        carbonTabSwipeNavigation.toolbar.barTintColor = .white
        carbonTabSwipeNavigation.toolbar.backgroundColor = .white
        carbonTabSwipeNavigation.toolbarHeight.constant = 55.0
        carbonTabSwipeNavigation.setIndicatorHeight(0.8)
        carbonTabSwipeNavigation.carbonTabSwipeScrollView.isScrollEnabled = false
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(Utility.getScreenWidth()/2, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(Utility.getScreenWidth()/2, forSegmentAt: 1)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        view.bringSubviewToFront(createEventButton)
    }
    
    //MARK: - Private Methods
    
    @objc func editButtonTapped(sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: nil)
    }
    
    @objc func addNewContactButtonTapped(sender: UIBarButtonItem) {
        if isAddContact {
            let newEventViewController = AddNewContactViewController()
            newEventViewController.modalPresentationStyle = .fullScreen
            let newEventNavigationController = UINavigationController()
            newEventNavigationController.setupAppThemeNavigationBar()
            newEventNavigationController.viewControllers = [newEventViewController]
            newEventNavigationController.modalPresentationStyle = .fullScreen
            self.present(newEventNavigationController, animated: true, completion: nil)
            
        } else {
            let newEventViewController = NewSwarmViewController()
            newEventViewController.delegate = self
            newEventViewController.modalPresentationStyle = .fullScreen
            let newEventNavigationController = UINavigationController()
            newEventNavigationController.setupAppThemeNavigationBar()
            newEventNavigationController.viewControllers = [newEventViewController]
            newEventNavigationController.modalPresentationStyle = .fullScreen
            self.present(newEventNavigationController, animated: true, completion: nil)
        }
    }
    
    @IBAction func createEventButtonTapped(_ sender: Any) {
        let newEventViewController = EventFormViewController()
        newEventViewController.modalPresentationStyle = .fullScreen
        let newEventNavigationController = UINavigationController()
        newEventNavigationController.setupAppThemeNavigationBar()
        newEventViewController.emptyEventForm = true
        newEventNavigationController.viewControllers = [newEventViewController]
        self.present(newEventNavigationController, animated: true, completion: nil)

    }
}

extension ContactsViewController: CarbonTabSwipeNavigationDelegate {
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        selectedIndex = Int(index)
        if index == 1 {
            let contactListViewController  = ContactListViewController()
            contactListViewController.isSwarm = true
            contactListViewController.isSynced = true
            contactListViewController.delegate = self
            return contactListViewController
        }
        let contactListViewController  = ContactListViewController()
        contactListViewController.delegate = self
        return contactListViewController
    }
}

extension ContactsViewController: ContactListViewControllerDelegate {
    
    func didUpdateBarButton(isUpdate: Bool, isHive: Bool) {
        Utility.isContactsEditable = isUpdate
        if !isUpdate {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped(sender:)))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Plus"), style: .plain, target: self, action: #selector(addNewContactButtonTapped(sender:)))
            self.navigationItem.leftBarButtonItem?.setFontStyle()
            
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(editButtonTapped(sender:)))
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(editButtonTapped(sender:)))
            self.navigationItem.leftBarButtonItem?.setFontStyle()
            self.navigationItem.rightBarButtonItem?.setBoldFontStyle()
        }
    }
    
    func didContactListViewAppear(isSwarm: Bool) {
        isAddContact = !isSwarm
    }
}

extension ContactsViewController: NewSwarmViewControllerDelegate {
    func didCreateNewSwarm() {
        NotificationCenter.default.post(name: Notification.Name("NewSwarmNotificationIdentifier"), object: nil, userInfo: nil)
    }
}

