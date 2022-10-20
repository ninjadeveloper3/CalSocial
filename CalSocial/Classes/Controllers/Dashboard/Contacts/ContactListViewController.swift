//
//  ContactListViewController.swift
//  CalSocial
//
//  Created by DevBatch on 30/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper
import TwilioChatClient
import TwilioAccessManager

protocol ContactListViewControllerDelegate {
    func didContactListViewAppear(isSwarm: Bool)
    func didUpdateBarButton(isUpdate: Bool, isHive: Bool)
}

class ContactListViewController: UIViewController {
    
    //MARK: - Variables
    
    let refreshControl = UIRefreshControl()
    
    var isSwarm = false
    
    var isSynced = true
    
    var isEditSwarm = false
    
    var isEditHive = false
    
    var delegate: ContactListViewControllerDelegate?
    
    var hiveDatasource = [HiveModel]()
    
    var swarmDatasouce = [SwarmModel]()
    
    var hiveContactId = 0
    
    var swarmContactId = 0
    
    var isOwner = false
    
    var isDataLoading:Bool=false
    
    var pageNo : Int = 1
    
    var limit : Int = 10
    
    var offset : Int = 0 //pageNo*limit
    
    var isPullToRefresh = false
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var clearCross: UIButton!
    
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var contactListTableView: UITableView!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.didContactListViewAppear(isSwarm: isSwarm)
        if Utility.isContactsEditable {
            DispatchQueue.main.async {
                self.contactListTableView.reloadData()
            }
//            contactListTableView.reloadData()
        }
        DispatchQueue.main.async {
            self.refreshControl.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)
            self.contactListTableView.refreshControl = self.refreshControl
        }
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        contactListTableView.delegate = self
        contactListTableView.dataSource = self
        contactListTableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.swarmUpdate),
            name: NSNotification.Name(rawValue: "NewSwarmNotificationIdentifier"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updateTableView),
            name: NSNotification.Name(rawValue: "NotificationIdentifier"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updateHiveList),
            name: NSNotification.Name(rawValue: "UpdateHiveList"),
            object: nil)
        
        
        
        if isSwarm {
            getSwarm(pageNo: pageNo, limit: limit)
            
        } else {
            getHive(pageNo: pageNo, limit: limit)
        }
    }
    
    //MARK: - Private Methods
    
    @objc private func swarmUpdate(notification: NSNotification) {
        if isSwarm {
            self.swarmDatasouce.removeAll()
            getSwarm(pageNo: 1, limit: 30)
        }
    }
    
    @objc private func updateHiveList(notification: NSNotification) {
        //do stuff using the userInfo property of the notification object
        self.hiveDatasource.removeAll()
        getHive(pageNo: pageNo, limit: limit)
    }
    
    @objc private func updateTableView(notification: NSNotification) {
        //do stuff using the userInfo property of the notification object
        
        if isSwarm {
            if isEditSwarm {
                isEditSwarm = false
                
            } else {
                isEditSwarm = true
            }
            
        } else {
            if isEditHive {
                isEditHive = false
                
            } else {
                isEditHive = true
            }
            
        }
        
        if isEditHive || isEditSwarm {
            delegate?.didUpdateBarButton(isUpdate: true, isHive: isEditHive)
            
        } else {
            delegate?.didUpdateBarButton(isUpdate: false, isHive: isEditHive)
        }
        
        contactListTableView.reloadData()
    }
    
    @IBAction func clearSearchTapped(_ sender: Any) {
        searchTextField.text = ""
        clearCross.isHidden = true
        if isSwarm{
            
            getSwarm(pageNo: pageNo, limit: limit, isClearAll: true)
            
        } else {
            
            getHive(pageNo: pageNo, limit: limit, isClearAll: true)
        }
    }
    
    
    @IBAction func searchTextChanged(_ sender: UITextField) {
        if sender.text!.count == 0 {
            clearCross.isHidden = true
            if isSwarm{
                
                getSwarm(pageNo: pageNo, limit: limit, isClearAll: true)
            
            } else {
                
                getHive(pageNo: pageNo, limit: limit, isClearAll: true)
            }
            
        } else {
            clearCross.isHidden = false
            let txt = sender.text!.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            if isSwarm {
                searchSwarm(TxtSearch: txt,pageNo: 0, limit: 10)
                
            }
            else{
                searchHive(TxtSearch: txt,pageNo: 0, limit: 10)
                print("search user-->",txt)
            }
            
        }
    }
    
    func searchSwarm(TxtSearch: String,pageNo: Int,limit: Int){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.doSearchSwarm(searchUser: TxtSearch,page: pageNo, limit: limit) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            self.swarmDatasouce.removeAll()
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<SwarmModel>().mapArray(JSONObject: result) {
                    if data.count == 0 {
                        self.isDataLoading = true
                    }
                    self.swarmDatasouce.removeAll()
                    self.swarmDatasouce = data
                    self.isDataLoading = false
                    DispatchQueue.main.async {
                        self.contactListTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func searchHive(TxtSearch: String,pageNo: Int,limit: Int){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.doSearchHive(searchUser: TxtSearch,page: pageNo, limit: limit) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            self.swarmDatasouce.removeAll()
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<HiveModel>().mapArray(JSONObject: result) {
                    if data.count == 0 {
                        self.isDataLoading = true
                    }
                    self.hiveDatasource.removeAll()
                    self.hiveDatasource = data
                    self.isDataLoading = false
                    DispatchQueue.main.async {
                        self.contactListTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func getHive(pageNo: Int, limit: Int, isClearAll: Bool = false) {
        if !isPullToRefresh {
            Utility.showLoading(viewController: self)
        }
        APIClient.sharedClient.getHive(page: pageNo, limit: limit) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if !self.isPullToRefresh {
                Utility.hideLoading(viewController: self)
            } else {
                self.refreshControl.endRefreshing()
                
            }
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if isClearAll {
                    self.hiveDatasource.removeAll()
                }
                
                if let data = Mapper<HiveModel>().mapArray(JSONObject: result) {
                    if self.isPullToRefresh {
                        self.isPullToRefresh = false
                        self.hiveDatasource.removeAll()
                    }
                    self.hiveDatasource.append(contentsOf: data)
                    self.contactListTableView.reloadData()
                    if self.hiveDatasource.count == 0 {
                        Utility.emptyHiveTableViewMessageWithImage(viewController: self, tableView: self.contactListTableView)
                        self.searchTextField.isUserInteractionEnabled = false
                        
                    } else {
                        self.contactListTableView.backgroundView = UIView()
                        self.searchTextField.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
    
    func getSwarm(pageNo: Int, limit: Int, isClearAll: Bool = false) {
        if !isPullToRefresh {
            Utility.showLoading(viewController: self)
        }
        APIClient.sharedClient.getSwarm(page: pageNo, limit: limit) { (response, result, error, message) in
            if !self.isPullToRefresh {
                Utility.hideLoading(viewController: self)
            } else {
                self.refreshControl.endRefreshing()
                //                self.isPullToRefresh = false
            }
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if isClearAll {
                    self.swarmDatasouce.removeAll()
                    self.contactListTableView.backgroundView = UIView()
                }
                if let data = Mapper<SwarmModel>().mapArray(JSONObject: result) {
                    if self.isPullToRefresh {
                        self.isPullToRefresh = false
                        self.swarmDatasouce.removeAll()
                    }
                    if data.count == 0 {
                        self.searchTextField.isUserInteractionEnabled = false
                        
                    } else {
                        self.searchTextField.isUserInteractionEnabled = true
                    }
                    self.swarmDatasouce.append(contentsOf: data)
                    DispatchQueue.main.async {
                        self.contactListTableView.reloadData()
                    }
                    
                } else {
                    self.contactListTableView.backgroundView = UIView()
                }
            }
        }
    }
    
    func setFavourite(id: Int, type: String) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.setFavorite(id: id, type: type) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                //                self.contactListTableView.reloadData()
            }
        }
    }
    
    func setUnfavourite(id: Int, type: String) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.setUnfavorite(id: id, type: type) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                //                self.contactListTableView.reloadData()
            }
        }
    }
    
    func leaveGroup(id: Int) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.leaveSwarm(id: id) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.swarmDatasouce = self.swarmDatasouce.filter { $0.swarm.id != id }
                self.contactListTableView.reloadData()
            }
        }
    }
    
    func removeFromHive(id: Int) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.removeFromHive(userId: id) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.hiveDatasource = self.hiveDatasource.filter { $0.hiveMember.id != id }
                self.contactListTableView.reloadData()
            }
        }
    }
    
    func deleteSwarm(id: Int) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.deleteSwarm(id: id) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.swarmDatasouce = self.swarmDatasouce.filter { $0.swarm.id != id }
                self.contactListTableView.reloadData()
            }
        }
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        
        pageNo = 1
        limit = 20
        self.isPullToRefresh = true
        if Utility.isKeyPresentInUserDefaults(key: kToken) {
            if isSwarm {
                getSwarm(pageNo: pageNo, limit: limit)
                
            } else {
                getHive(pageNo: pageNo, limit: limit)
            }
        }
        else{
            NSError.showErrorWithMessage(message: "Please login first to see your order history", viewController: self, type: .error, isNavigation: true)
        }
    }
}

extension ContactListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if !isSynced {
                searchTextField.isUserInteractionEnabled = false
                Utility.unsycedSwarmTableView(label: "You do not belong to any swarm group yet. You can create one  by tapping the button below", titleButton: "Create New Swarm", viewController: self, tableView: tableView)
                return 0
            }
            if isSwarm {
                searchTextField.isUserInteractionEnabled = true
                if swarmDatasouce.count != 0 {
                    contactListTableView.backgroundView = UIView()
                    if Utility.isContactsEditable {
                        return swarmDatasouce.count
                        
                    } else {
                        return swarmDatasouce.count + 1
                    }
                    
                } else {
                    searchTextField.isUserInteractionEnabled = false
                    Utility.unsycedSwarmTableView(label: "You do not belong to any swarm group yet. You can create one  by tapping the button below", titleButton: "Create New Swarm", viewController: self, tableView: tableView)
                    return 0
                }
            }
            searchTextField.isUserInteractionEnabled = true
            return hiveDatasource.count
            
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if Utility.isContactsEditable {
                let removalCell = RemovalTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                if isSwarm {
                    removalCell.nameLabel.text = swarmDatasouce[indexPath.row].swarm.title
                    removalCell.delegate = self
                    if swarmDatasouce[indexPath.row].role == 1 {
                        removalCell.leaveLabel.isHidden = true
                        removalCell.deleteButton.isHidden = false
                        
                    } else {
                        removalCell.leaveLabel.isHidden = false
                        removalCell.deleteButton.isHidden = true
                    }
                    if swarmDatasouce[indexPath.row].swarm.coverPicture == "" {
                        removalCell.emptyImageView.isHidden = false
                        removalCell.emptyImageLabelText.text = swarmDatasouce[indexPath.row].swarm.title.getFirstChar()
                        removalCell.emptyImageView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(swarmDatasouce[indexPath.row].swarm.backgroundColor, alpha: 1.0)
                        
                    } else {
                        removalCell.emptyImageView.isHidden = true
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(swarmDatasouce[indexPath.row].swarm.coverPicture)") {
                            print("url",url)
                            removalCell.displayPicture.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                    }
                    
                    if swarmDatasouce[indexPath.row].isFavorites == 0 {
                        removalCell.favIconImageView.image = #imageLiteral(resourceName: "Favorite-F (1)")
                        swarmDatasouce[indexPath.row].isSelected = false
                    }
                    else{
                        swarmDatasouce[indexPath.row].isSelected = true
                        removalCell.favIconImageView.image = #imageLiteral(resourceName: "star")
                    }
                    
                }
                else {
                    removalCell.delegate = self
                    removalCell.nameLabel.text = "\(hiveDatasource[indexPath.row].hiveMember.firstName) \(hiveDatasource[indexPath.row].hiveMember.lastName)"
                    
                    if hiveDatasource[indexPath.row].isFavourite == 0 {
                        removalCell.favIconImageView.image = #imageLiteral(resourceName: "Favorite-F (1)")
                        hiveDatasource[indexPath.row].isSelected = false
                    }
                    else{
                        hiveDatasource[indexPath.row].isSelected = true
                        removalCell.favIconImageView.image = #imageLiteral(resourceName: "star")
                    }
                    
                    if hiveDatasource[indexPath.row].hiveMember.profilePicture == "" {
                        removalCell.emptyImageView.isHidden = false
                        removalCell.emptyImageLabelText.text = hiveDatasource[indexPath.row].hiveMember.firstName.getFirstChar()+hiveDatasource[indexPath.row].hiveMember.lastName.getFirstChar()
                        removalCell.emptyImageView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha( hiveDatasource[indexPath.row].hiveMember.color, alpha: 1.0)
                        
                    } else {
                        removalCell.emptyImageView.isHidden = true
                        if let url = URL(string: "\(kImageDownloadBaseUrl)\(hiveDatasource[indexPath.row].hiveMember.profilePicture)") {
                            print("url",url)
                            removalCell.displayPicture.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                    }
                }
                return removalCell
            }
            
            if isSwarm {
                if indexPath.row == 0 {
                    let buttonCell = CreateNewSwarmTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                    buttonCell.delegate = self
                    return buttonCell
                }
                let swarmCell = SwarmTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                var namesOfMembers = ""
                swarmCell.swarmTitle.text = swarmDatasouce[indexPath.row-1].swarm.title
                
                if swarmDatasouce[indexPath.row-1].isFavorites == 1 {
                    swarmCell.favIcon.isHidden = false
                    
                } else {
                    swarmCell.favIcon.isHidden = true
                }
                if swarmDatasouce[indexPath.row-1].swarm.swarmMembers.count > 0 {
                    let members = swarmDatasouce[indexPath.row-1].swarm.swarmMembers
                    
                    for (idx,names) in members.enumerated() {
                        if idx == members.endIndex-1 {
                            namesOfMembers = namesOfMembers + "\(names.firstName)" 
                        }
                        else{
                            namesOfMembers = "\(names.firstName ), " + namesOfMembers
                        }
                    }
                }
                if swarmDatasouce[indexPath.row-1].swarm.coverPicture == "" {
                    swarmCell.emptyImageView.isHidden = false
                    swarmCell.emptyImageLabelText.text = swarmDatasouce[indexPath.row-1].swarm.title.getFirstChar()
                    swarmCell.emptyImageView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(swarmDatasouce[indexPath.row-1].swarm.backgroundColor, alpha: 1.0)
                }
                else{
                    swarmCell.emptyImageView.isHidden = true
                    if let url = URL(string: "\(kImageDownloadBaseUrl)\(swarmDatasouce[indexPath.row-1].swarm.coverPicture)") {
                        print("url",url)
                        swarmCell.profilePic.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                        })
                    }
                }
                swarmCell.membersLabel.text = namesOfMembers
                if swarmDatasouce[indexPath.row-1].isFavorites == 1 {
                    swarmCell.favIcon.isHidden = false
                    
                } else {
                    swarmCell.favIcon.isHidden = true
                }
                swarmCell.delegate = self
                return swarmCell
                
            } else {
                let cell = HiveContactTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                cell.delegate = self
                cell.nameLabel.text = "\(hiveDatasource[indexPath.row].hiveMember.firstName) \(hiveDatasource[indexPath.row].hiveMember.lastName)"
                
                if hiveDatasource[indexPath.row].isFavourite == 1 {
                    cell.favIconImageView.isHidden = false
                    
                } else {
                    cell.favIconImageView.isHidden = true
                }
                
                if self.hiveDatasource[indexPath.row].hiveMember.profilePicture == "" {
                    cell.emptyImageView.isHidden = false
                    cell.profileImage.isHidden = true
                    if hiveDatasource[indexPath.row].hiveMember.firstName != "" {
                        cell.emptyImageLabelText.text = hiveDatasource[indexPath.row].hiveMember.firstName.getFirstChar()+hiveDatasource[indexPath.row].hiveMember.lastName.getFirstChar()
                        cell.emptyImageView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(hiveDatasource[indexPath.row].hiveMember.color, alpha: 1.0)
                        
                    } else {
                        cell.emptyImageLabelText.text = "A"
                    }
                    
                } else {
                    cell.emptyImageView.isHidden = true
                    cell.profileImage.isHidden = false
                    if let url = URL(string: "\(kImageDownloadBaseUrl)\(self.hiveDatasource[indexPath.row].hiveMember.profilePicture)") {
                        print("url",url)
                        cell.profileImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                        })
                        
                    } else {
                        cell.emptyImageLabelText.text = hiveDatasource[indexPath.row].hiveMember.firstName.getFirstChar()+hiveDatasource[indexPath.row].hiveMember.lastName.getFirstChar()
                        cell.emptyImageView.backgroundColor = UIColor.CustomColorFromHexaWithAlpha(hiveDatasource[indexPath.row].hiveMember.color, alpha: 1.0)
                    }
                }
                
                return cell
            }
            
        } else {
            let dummyCell = DummyTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            return dummyCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if Utility.isContactsEditable == false {
                if isSwarm {
                    if indexPath.row > 0 {
                        let newEventViewController = SwarmBaseViewController()
                        newEventViewController.delegate = self
                        newEventViewController.modalPresentationStyle = .fullScreen
                        newEventViewController.swarmId = swarmDatasouce[indexPath.row-1].swarmId
                        newEventViewController.swarmTitle = swarmDatasouce[indexPath.row-1].swarm.title
                        newEventViewController.roleId = swarmDatasouce[indexPath.row-1].role
                        let newEventNavigationController = UINavigationController()
                        newEventNavigationController.setupAppThemeNavigationBar()
                        newEventViewController.isFavourite = swarmDatasouce[indexPath.row-1].isFavorites
                        newEventNavigationController.viewControllers = [newEventViewController]
                        newEventNavigationController.modalPresentationStyle = .fullScreen
                        self.present(newEventNavigationController, animated: true, completion: nil)
                    }
                    
                } else {
                    let profileViewController  = UserProfileViewController()
                    profileViewController.delegate = self
                    profileViewController.modalPresentationStyle = .fullScreen
                    let profileNavigationController = UINavigationController()
                    profileNavigationController.setupAppThemeNavigationBar()
                    profileViewController.userId = hiveDatasource[indexPath.row].hiveMember.id
                    profileViewController.userName = hiveDatasource[indexPath.row].hiveMember.firstName+" "+hiveDatasource[indexPath.row].hiveMember.lastName
                    profileViewController.firstName = hiveDatasource[indexPath.row].hiveMember.firstName
                    profileViewController.profileType = .InHive
                    profileNavigationController.viewControllers = [profileViewController]
                    profileNavigationController.modalPresentationStyle = .fullScreen
                    self.present(profileNavigationController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        
        if ((contactListTableView.contentOffset.y + contactListTableView.frame.size.height) >= contactListTableView.contentSize.height)
        {
            if isSwarm {
                isDataLoading = true
                self.pageNo=self.pageNo+1
                getSwarm(pageNo: self.pageNo, limit: self.limit)
            }
            else{
                isDataLoading = true
                self.pageNo=self.pageNo+1
                getHive(pageNo: self.pageNo, limit: self.limit)
            }
        }
    }
}

extension ContactListViewController : SwarmEmptyViewDelegate {
    
    func didFinishTask() {
        let newEventViewController = NewSwarmViewController()
        let newEventNavigationController = UINavigationController()
        newEventNavigationController.setupAppThemeNavigationBar()
        newEventViewController.delegate = self
        newEventNavigationController.viewControllers = [newEventViewController]
        newEventNavigationController.modalPresentationStyle = .fullScreen
        self.present(newEventNavigationController, animated: true, completion: nil)
    }
}

extension ContactListViewController: HiveContactTableViewCellDelegate {
    
    func didTappedCreateEvent(cell: HiveContactTableViewCell) {
        if let indexPath = contactListTableView.indexPath(for: cell) {
            if !isSwarm {
                let userDatasource = Mapper<BizeeUserModel>().map(JSON: [:])!
                userDatasource.hives.append(hiveDatasource[indexPath.row])
                let newEventViewController = EventFormViewController()
                newEventViewController.modalPresentationStyle = .fullScreen
                let newEventNavigationController = UINavigationController()
                newEventNavigationController.setupAppThemeNavigationBar()
                newEventViewController.userContactDataSource = userDatasource
                newEventViewController.titleReload = true
                newEventViewController.isOneToOneEvent = true
                newEventNavigationController.viewControllers = [newEventViewController]
                newEventNavigationController.modalPresentationStyle = .fullScreen
                self.present(newEventNavigationController, animated: true, completion: nil)
            }
        }
    }
    
    func didTappedMessageIcon(cell: HiveContactTableViewCell) {
        
        Utility.showLoading(viewController: self)
        if let indexPath = contactListTableView.indexPath(for: cell) {
            if !isSwarm {
                MessagingManager.sharedManager().chatClientDelegate = self
                let user = Mapper<AttMember>().map(JSON: [:])!
                user.id = self.hiveDatasource[indexPath.row].hiveMember.id
                user.name = "\(self.hiveDatasource[indexPath.row].hiveMember.firstName) \(self.hiveDatasource[indexPath.row].hiveMember.lastName)"
                user.picture = self.hiveDatasource[indexPath.row].hiveMember.profilePicture
                MessagingManager.sharedManager().setUpChannels(users: [user, Utility.getUserModel()], viewController: self)
            }
        }
    }
}

extension ContactListViewController: SwarmTableViewCellDelegate {
    
    func didTapCreateEvent(cell: SwarmTableViewCell) {
        if let indexPath = contactListTableView.indexPath(for: cell) {
            if isSwarm {
                let userDatasource = Mapper<BizeeUserModel>().map(JSON: [:])!
                userDatasource.swarms.append(swarmDatasouce[indexPath.row-1])
                let newEventViewController = EventFormViewController()
                newEventViewController.modalPresentationStyle = .fullScreen
                let newEventNavigationController = UINavigationController()
                newEventNavigationController.setupAppThemeNavigationBar()
                newEventViewController.userContactDataSource = userDatasource
                newEventViewController.swarmTitle = swarmDatasouce[indexPath.row - 1].swarm.title
                newEventViewController.isSwarm = true
                newEventViewController.titleReload = true
                newEventViewController.isOneToOneEvent = true
                newEventNavigationController.viewControllers = [newEventViewController]
                newEventNavigationController.modalPresentationStyle = .fullScreen
                self.present(newEventNavigationController, animated: true, completion: nil)
            }
        }
    }
    
    func didTapMessage(cell: SwarmTableViewCell) {
        if let indexPath = contactListTableView.indexPath(for: cell) {
            if isSwarm {
                Utility.showLoading(viewController: self)
                MessagingManager.sharedManager().chatClientDelegate = self
                var swarmUsers = [AttMember]()
                swarmUsers.removeAll()
                for swarmMembers in self.swarmDatasouce[indexPath.row - 1].swarm.swarmMembers {
                    let user = Mapper<AttMember>().map(JSON: [:])!
                    user.id = swarmMembers.userId
                    user.name = "\(swarmMembers.firstName) \(swarmMembers.lastName)"
                    user.picture = swarmMembers.profilePicture
                    swarmUsers.append(user)
                }
//                swarmUsers.append(Utility.getUserModel())
                MessagingManager.sharedManager().setUpChannels(users: swarmUsers, viewController: self)
            }
        }
    }
}

extension ContactListViewController: CreateNewSwarmTableViewCellDelegate {
    func didTapCreateSwarm() {
        let newEventViewController = NewSwarmViewController()
        newEventViewController.delegate = self
        let newEventNavigationController = UINavigationController()
        newEventNavigationController.setupAppThemeNavigationBar()
        newEventNavigationController.modalPresentationStyle = .fullScreen
        newEventNavigationController.viewControllers = [newEventViewController]
        self.present(newEventNavigationController, animated: true, completion: nil)
    }
}

extension ContactListViewController: RemovalTableViewCellDelegate {
    func didTapFavoritesButton(cell: RemovalTableViewCell) {
        if let indexPath = contactListTableView.indexPath(for: cell) {
            if isSwarm {
                let id = swarmDatasouce[indexPath.row].swarm.id
                
                if swarmDatasouce[indexPath.row].isFavorites == 1 {
                    swarmDatasouce[indexPath.row].isFavorites = 0
                    cell.favIconImageView.image = #imageLiteral(resourceName: "Favorite-F (1)")
                    self.setUnfavourite(id: id, type: "Swarm")
                
                } else { 
                    swarmDatasouce[indexPath.row].isFavorites = 1
                    cell.favIconImageView.image = #imageLiteral(resourceName: "star")
                    self.setFavourite(id: id, type: "Swarm")
                }
    
            } else {
                let id = hiveDatasource[indexPath.row].hiveMember.id
                if hiveDatasource[indexPath.row].isFavourite == 1 {
                    hiveDatasource[indexPath.row].isFavourite = 0
                    cell.favIconImageView.image = #imageLiteral(resourceName: "Favorite-F (1)")
                    self.setUnfavourite(id: id, type: "Hive")
                
                } else {
                    hiveDatasource[indexPath.row].isFavourite = 1
                    cell.favIconImageView.image = #imageLiteral(resourceName: "star")
                    self.setFavourite(id: id, type: "Hive")
                }
            }
        }
    }
    
    func didTapDeleteButton(cell: RemovalTableViewCell) {
        if let indexPath = contactListTableView.indexPath(for: cell) {
            if isSwarm {
                let id = swarmDatasouce[indexPath.row].swarm.id
                swarmContactId = id
                let popUp = RemoveConfirmViewController()
                if swarmDatasouce[indexPath.row].role == 1 {
                    isOwner = true
                    popUp.removal = .DeleteSwarm
                    
                } else {
                    popUp.removal = .LeaveSwarm
                }
                
                popUp.modalPresentationStyle = .overCurrentContext
                popUp.delegate = self
                self.present(popUp, animated: true, completion: nil)
                
            } else {
                let id = hiveDatasource[indexPath.row].hiveMember.id
                hiveContactId = id
                let popUp = RemoveConfirmViewController()
                popUp.modalPresentationStyle = .overCurrentContext
                popUp.delegate = self
                self.present(popUp, animated: true, completion: nil)
            }
        }
    }
}

extension ContactListViewController : SwarmBaseViewControllerDelegate {
    func didDeleteSwarm(swarmId: Int) {
        self.swarmDatasouce.removeAll()
        getSwarm(pageNo: 1, limit: 30)
    }
    
    func didSwarmModifications() {
        self.swarmDatasouce.removeAll()
        getSwarm(pageNo: 1, limit: 30)
    }
}

extension ContactListViewController : UserProfileViewControllerDelegate {
    func didUpdateUserProfile() {
        self.hiveDatasource.removeAll()
        getHive(pageNo: 1, limit: 30)
    }
}
extension ContactListViewController : NewSwarmViewControllerDelegate {
    func didCreateNewSwarm() {
        self.swarmDatasouce.removeAll()
        getSwarm(pageNo: 1, limit: 30)
    }
}

extension ContactListViewController: confirmPopUpSelectionDelegate {
    func didSelectOption(selection: Bool) {
        if selection {
            print("confirm delete")
            self.dismiss(animated: true, completion: nil)
            if isSwarm
            {
                if isOwner {
                    self.deleteSwarm(id: swarmContactId)
                
                } else {
                    self.leaveGroup(id: swarmContactId)
                }
                
            } else {
                self.removeFromHive(id: hiveContactId)
            }
         
        } else {
            print("do nothind")
            hiveContactId = 0
            swarmContactId = 0
            isOwner = false
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension ContactListViewController: MessagingManagerDelegate {
    func didDeleteChannel(channel: TCHChannel) {
        
    }
    
    func didNotDeleteChannel() {
        
    }
    
    func didDeleteChannel(client: TwilioChatClient) {
        
    }
    
    func didGetChatList(client: TwilioChatClient) {
        print("Channel Update")
    }
    
    func didGetMessagesList(message: [TCHMessage]) {
        
    }
    
    func didListMessage(message: TCHMessage) {
        
    }
    
    func didJoinChannel(channel: TCHChannel) {
        Utility.hideLoading(viewController: self)
        let navigationViewController = UINavigationController()
        let messageViewController = NewMessageViewController()
        navigationViewController.setupAppThemeNavigationBar()
        messageViewController.channel = channel
        messageViewController.title = String().getChatTitle(attributes: channel.attributes()!)
        messageViewController.chatMembersDataSource = attributesMembers(attributes: channel.attributes()!)
        navigationViewController.viewControllers = [messageViewController]
        self.present(navigationViewController, animated: true, completion: nil)
    }
    
    func attributesMembers(attributes: [String:Any]) -> [AttMember] {
        var chatMembers = [AttMember]()
        chatMembers.removeAll()
        if let members = attributes["members"] as? [[String:Any]] {
            for member in members {
                let chatMember = Mapper<AttMember>().map(JSON: [:])!
                chatMember.id = (member["id"] as? Int)!
                chatMember.name = (member["name"] as? String)!
                chatMember.picture = (member["picture"] as? String)!
                chatMembers.append(chatMember)
            }
        }
        chatMembers = chatMembers.removingDuplicates(byKey: { $0.id })
        return chatMembers
    }
}

extension ContactListViewController: TwilioChatClientDelegate {
    
    func chatClient(_ client: TwilioChatClient, channelAdded channel: TCHChannel) {
//        print()
    }
}


