//
//  ProfileViewController.swift
//  CalSocial
//
//  Created by DevBatch on 03/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    //MARK: - Variables
    
    var isStackedButtons = false
    
    var isEdit = false
    
    var barButton = UIBarButtonItem()
    
    var profileType: ProfileType = .UserProfile
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var bucketTableView: UITableView!
    
    @IBOutlet weak var eventTableView: UITableView!
    
    @IBOutlet weak var hiveButton: MBButton!
    
    @IBOutlet weak var buttonStack: UIStackView!
    
    @IBOutlet weak var createEventImageView: UIImageView!
    
    @IBOutlet weak var messageImageView: UIImageView!
    
    @IBOutlet weak var viewHive: UIView!
    
    @IBOutlet weak var eventsLabel: UILabel!
    
    @IBOutlet weak var favImageView: UIImageView!
    
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        eventTableView.delegate = self
        eventTableView.dataSource = self
        eventTableView.separatorStyle = .none
        bucketTableView.separatorStyle = .none
        
        self.navigationItem.title = "John Smith"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        
        let eventGesture = UITapGestureRecognizer(target: self, action: #selector(createNewEventButtonTapped(sender:)))
        createEventImageView.addGestureRecognizer(eventGesture)
        
        if profileType == .UserProfile {
            userProfile()
        }
        
        if profileType == .AcceptDecline {
            acceptDeclineProfile()
        }
        
        if profileType == .InHive {
            inHiveProfile()
        }
        
        if profileType == .AddHive {
            addHiveProfile()
        }
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func viewHiveListButtonTapped(_ sender: Any) {
    
        self.navigationController?.pushViewController(HiveListViewController(), animated: true)
    }
    
    //MARK: - Private Methods
    
    func userProfile() {
        self.navigationItem.title = "My Profile"
        barButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(menuButtonTapped(sender:)))
        self.navigationItem.rightBarButtonItem = barButton
        self.navigationItem.rightBarButtonItem?.setFontStyle()
        
        hiveButton.isHidden = true
        buttonStack.isHidden = true
        createEventImageView.image = #imageLiteral(resourceName: "settings")
        messageImageView.isHidden = true
        viewHive.isHidden = true
        eventsLabel.isHidden = true
        eventTableView.isHidden = true
        favImageView.isHidden = true
    }
    
    func acceptDeclineProfile() {
        
        barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "More"), style: .plain, target: self, action: #selector(menuButtonTapped(sender:)))
        self.navigationItem.rightBarButtonItem = barButton
        
        hiveButton.isHidden = true
        buttonStack.isHidden = false
        createEventImageView.isHidden = true
        messageImageView.isHidden = true
        viewHive.isHidden = true
    }
    
    func inHiveProfile() {
        barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "More"), style: .plain, target: self, action: #selector(menuButtonTapped(sender:)))
        self.navigationItem.rightBarButtonItem = barButton
        
        hiveButton.isHidden = false
        buttonStack.isHidden = true
        createEventImageView.isHidden = false
        messageImageView.isHidden = false
        viewHive.isHidden = false
    }
    
    func addHiveProfile() {
        barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "More"), style: .plain, target: self, action: #selector(menuButtonTapped(sender:)) )
        self.navigationItem.rightBarButtonItem = barButton
        
        hiveButton.isHidden = false
        buttonStack.isHidden = true
        createEventImageView.isHidden = false
        messageImageView.isHidden = false
        hiveButton.setTitle("Add to Hive", for: .normal)
        viewHive.isHidden = true
    }
    
    func requestSentProfile() {
        barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "More"), style: .plain, target: self, action: #selector(menuButtonTapped(sender:)) )
        self.navigationItem.rightBarButtonItem = barButton
        
        hiveButton.isHidden = false
        buttonStack.isHidden = true
        createEventImageView.isHidden = true
        messageImageView.isHidden = true
        hiveButton.setTitle("Request Sent", for: .normal)
        viewHive.isHidden = true
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
       self.dismiss(animated: true, completion: nil)
    }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        
        if profileType == .UserProfile {
            self.navigationController?.pushViewController(EditProfileViewController(), animated: true)
        }
        
        if profileType == .InHive {
            
            let alert = UIAlertController.init(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
            
            let addAction = UIAlertAction(title: "Add to your favorites", style: UIAlertAction.Style.default) { (action) in
            }
            
            let changeAction = UIAlertAction(title: "Change hive status", style: UIAlertAction.Style.default) { (action) in
            }
            
            let removeAction = UIAlertAction(title: "Remove from hive", style: UIAlertAction.Style.destructive) { (action) in
            }
            
            let blockAction = UIAlertAction(title: "Block", style: UIAlertAction.Style.destructive) {
                (action) in
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            alert.addAction(addAction)
            alert.addAction(changeAction)
            alert.addAction(removeAction)
            alert.addAction(blockAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
        
        if profileType == .AddHive {
            
            let alert = UIAlertController.init(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
            
            let addAction = UIAlertAction(title: "Create Event", style: UIAlertAction.Style.default) { (action) in
            }
            
            let changeAction = UIAlertAction(title: "Send Message", style: UIAlertAction.Style.default) { (action) in
            }
            
            let blockAction = UIAlertAction(title: "Block", style: UIAlertAction.Style.destructive) {
                (action) in
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            alert.addAction(addAction)
            alert.addAction(changeAction)
            alert.addAction(blockAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
    
    @objc func createNewEventButtonTapped(sender: UITapGestureRecognizer) {
        if profileType == .UserProfile {
            let newEventViewController = SettingsViewController()
            let newEventNavigationController = UINavigationController()
            newEventNavigationController.setupAppThemeNavigationBar()
            newEventNavigationController.viewControllers = [newEventViewController]
            self.present(newEventNavigationController, animated: true, completion: nil)
            
        } else {
            let newEventViewController = EventFormViewController()
            let newEventNavigationController = UINavigationController()
            newEventNavigationController.setupAppThemeNavigationBar()
            newEventViewController.emptyEventForm = true
            newEventNavigationController.viewControllers = [newEventViewController]
            self.present(newEventNavigationController, animated: true, completion: nil)
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == bucketTableView {
            return 5
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == bucketTableView {
            let bucketCell = BucketTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            return bucketCell
        }
        
        let eventCell = EventTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        
        return eventCell
    }
}
