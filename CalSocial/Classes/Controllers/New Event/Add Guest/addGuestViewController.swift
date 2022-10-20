//
//  addGuestViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 01/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

protocol addGuestViewControllerDelegate {
    func didAddContacts(contacts: [HiveModel])
    func didAddUserContacts(userContacts: BizeeUserModel)
}

class addGuestViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var addGuestController: UITableView!
    
    //MARK: - Variables
    
    var isMessage = false
    
    var isNewEvent = false
    
    var dataSource = [HiveModel]()
    
    var hiveDataSource = [HiveModel]()
    
    var delegate : addGuestViewControllerDelegate?
    
    var selectedContacts = [HiveModel]()
    
    var userDataSource = Mapper<BizeeUserModel>().map(JSON: [:])!
    
    var selectedUserContacts = Mapper<BizeeUserModel>().map(JSON: [:])!
    
    var dataSourceHolder = [Int]()
    
    var hiveDataSourceHolder = [Int]()
    
    var itemCount = 0
    
    
    @IBOutlet weak var searchInputText: UITextField!
    
    @IBOutlet weak var clearCross: UIButton!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
        if isNewEvent {
            getAllExistingUser(page: 1, limit: 30000)
            
        } else {
            getHive()
        }
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        addGuestController.delegate = self
        addGuestController.dataSource = self
        addGuestController.separatorStyle = .none
        
        
        self.navigationItem.title = "Add Guests"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addButtonTapped(sender:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        self.navigationItem.rightBarButtonItem?.setBoldFontStyle()
    }
    
    //MARK: - Private Methods
    
    @IBAction func clearCrossTapped(_ sender: Any) {
        clearCross.isHidden = true
        searchInputText.text = ""
        if isNewEvent {
            userDataSource = Mapper<BizeeUserModel>().map(JSON: [:])!
            getAllExistingUser(page: 1, limit: 30000)
            
        } else {
            dataSource.removeAll()
            getHive()
        }
    }
    
    
    @IBAction func onEditingChanged(_ sender: UITextField) {
        if sender.text!.isEmpty{
            
            clearCross.isHidden = true
            
            if isNewEvent {
                userDataSource = Mapper<BizeeUserModel>().map(JSON: [:])!
                getAllExistingUser(page: 1, limit: 30000)
                
            } else {
                                dataSource.removeAll()
                                getHive()
            }
        }
        else{
            clearCross.isHidden = false
            let txt = sender.text!.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            if isNewEvent {
                searchHiveContacts(TxtSearch: txt,pageNo: 0, limit: 10)
            }
            else{
            doSearchHive(TxtSearch: txt,pageNo: -1, limit: 10)
            }
            
        }
    }
    
    func searchHiveContacts(TxtSearch: String,pageNo: Int,limit: Int){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.searchFromAllExistingUsers(searchUser: TxtSearch) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                
                if let data = Mapper<BizeeUserModel>().map(JSONObject: result) {
                    
                    
                    self.userDataSource = data                    
                    
                    if self.userDataSource.phoneContacts.count > 0 {
                        for (index,phoneContact) in self.userDataSource.phoneContacts.enumerated() {
                            for selection in self.dataSourceHolder {
                                if phoneContact.id == selection {
                                    self.userDataSource.phoneContacts[index].isSelected = true
                                }
                            }
                        }
                    }
                    if self.userDataSource.hives.count > 0 {
                        for (index,phoneContact) in self.userDataSource.hives.enumerated() {
                            for selection in self.dataSourceHolder {
                                if phoneContact.id == selection {
                                    self.userDataSource.hives[index].isSelected = true
                                }
                            }
                        }
                    }
                    if self.userDataSource.swarms.count > 0 {
                        for (index,phoneContact) in self.userDataSource.swarms.enumerated() {
                            for selection in self.dataSourceHolder {
                                if phoneContact.id == selection {
                                    self.userDataSource.swarms[index].isSelected = true
                                }
                            }
                        }
                    }
                    
                    self.selectedUserContacts = Mapper<BizeeUserModel>().map(JSON: [:])!
                    self.addGuestController.reloadData()
                }
            }
        }
    }
    
    func doSearchHive(TxtSearch: String,pageNo: Int,limit: Int){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.doSearchHive(searchUser: TxtSearch, page: -1, limit: 500) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<HiveModel>().mapArray(JSONObject: result) {
                    self.dataSource = [HiveModel]()
                    self.dataSource = data

                    for (index,phoneContact) in self.dataSource.enumerated() {
                        for selection in self.hiveDataSourceHolder {
                            if phoneContact.hiveMember.id == selection {
                                self.dataSource[index].isSelected = true
                            }
                        }
                    }
                    self.selectedContacts = [HiveModel]()
                    self.addGuestController.reloadData()
                }
            }
        }
    }
    
    
    @objc func addButtonTapped(sender: UIBarButtonItem) {
        
        if isNewEvent {
            
            for phoneContact in userDataSource.phoneContacts {
                if phoneContact.isSelected {
                    selectedUserContacts.phoneContacts.append(phoneContact)
                }
            }
            
            for hives in userDataSource.hives {
                if hives.isSelected {
                    selectedUserContacts.hives.append(hives)
                }
            }
            
            for swarm in userDataSource.swarms {
                if swarm.isSelected {
                    selectedUserContacts.swarms.append(swarm)
                }
            }
            delegate?.didAddUserContacts(userContacts: selectedUserContacts)
            
        } else {
            selectedContacts = [HiveModel]()
            for contact in dataSource {
                if contact.isSelected {
                    selectedContacts.append(contact)
                }
            }
            delegate?.didAddContacts(contacts: self.selectedContacts)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getHive() {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getHive(page: 1, limit: 2000) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<HiveModel>().mapArray(JSONObject: result) {
                    self.dataSource = [HiveModel]()
                    self.dataSource = data
                    if self.hiveDataSourceHolder.count > 0 {
                        for (index,phoneContact) in self.dataSource.enumerated() {
                                for selection in self.hiveDataSourceHolder {
                                    if phoneContact.hiveMember.id == selection{
                                        self.dataSource[index].isSelected = true
                                    }
                                }
                        }
                    }
                    else{
                            for (index,phoneContact) in self.dataSource.enumerated() {
                                for userContact in self.selectedContacts {
                                    if userContact.hiveMember.id == phoneContact.hiveMember.id {
                                        self.dataSource[index].isSelected = true
                                        self.hiveDataSourceHolder.append(phoneContact.hiveMember.id)
                                    }
                                }
                            }
                    }
                    self.addGuestController.reloadData()
                }
            }
        }
    }
    
    func getAllExistingUser(page: Int, limit: Int) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getAllExistingUsers(page: page, limit: limit) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<BizeeUserModel>().map(JSONObject: result) {
                    self.userDataSource = data
                    
                    if self.dataSourceHolder.count > 0 {
                        if self.userDataSource.phoneContacts.count > 0 {
                            for (index,phoneContact) in self.userDataSource.phoneContacts.enumerated() {
                                if self.dataSourceHolder.count > 0 {
                                    for selection in self.dataSourceHolder {
                                        if phoneContact.id == selection{
                                            self.userDataSource.phoneContacts[index].isSelected = true
                                        }
                                    }
                                }
                            }
                        }
                        if self.userDataSource.swarms.count > 0 {
                            for (index,swarm) in self.userDataSource.swarms.enumerated() {
                                if self.dataSourceHolder.count > 0 {
                                    for selection in self.dataSourceHolder {
                                        if swarm.id == selection {
                                            self.userDataSource.swarms[index].isSelected = true
                                        }
                                    }
                                }
                            }
                        }
                        if self.userDataSource.hives.count > 0 {
                            for (index,hive) in self.userDataSource.hives.enumerated() {
                                if self.dataSourceHolder.count > 0 {
                                    for selection in self.dataSourceHolder {
                                        if hive.id == selection {
                                            self.userDataSource.hives[index].isSelected = true
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    else{
                        if self.selectedUserContacts.phoneContacts.count > 0 {
                            for (index,phoneContact) in self.userDataSource.phoneContacts.enumerated() {

                                for (index,phoneContact) in self.userDataSource.phoneContacts.enumerated() {
                                    for userContact in self.selectedUserContacts.phoneContacts {
                                        if userContact.id == phoneContact.id {
                                            self.userDataSource.phoneContacts[index].isSelected = true
                                            self.dataSourceHolder.append(phoneContact.id)
                                        }
                                    }
                                }
                            }
                        }
                        if self.selectedUserContacts.swarms.count > 0 {
                            for (index,swarm) in self.userDataSource.swarms.enumerated() {

                                for (index,swarm) in self.userDataSource.swarms.enumerated() {
                                    for userSwarm in self.selectedUserContacts.swarms {
                                        if userSwarm.swarmId == swarm.swarmId {
                                            self.userDataSource.swarms[index].isSelected = true
                                            self.dataSourceHolder.append(swarm.id)
                                        }
                                    }
                                }
                                
                            }
                        }
                        if self.selectedUserContacts.hives.count > 0 {
                            for (index,hive) in self.userDataSource.hives.enumerated() {
                                
                                for userHive in self.selectedUserContacts.hives {
                                    if userHive.hiveMember.id == hive.hiveMember.id {
                                        self.userDataSource.hives[index].isSelected = true
                                        self.dataSourceHolder.append(hive.id)
                                    }
                                }
                            }
                        }
                    }
                    self.selectedUserContacts = Mapper<BizeeUserModel>().map(JSON: [:])!
                    self.addGuestController.reloadData()
                }
            }
        }
    }
}

extension addGuestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isNewEvent {
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isNewEvent {
            if section == 0 {
                return self.userDataSource.hives.count
            }
            if section == 1 {
                return self.userDataSource.swarms.count
            }
            return self.userDataSource.phoneContacts.count
        }
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactCell = addGuestTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        contactCell.delegate = self
        if isNewEvent {
            if indexPath.section == 0 {
                contactCell.initCellHiveData(dataSource: userDataSource.hives[indexPath.row])
                
            } else if indexPath.section == 1 {
                contactCell.initCellSwarmData(dataSource: userDataSource.swarms[indexPath.row])
                
            } else {
                contactCell.initCellPhoneContactData(dataSource: userDataSource.phoneContacts[indexPath.row])
            }
            
        } else {
            contactCell.initCellData(dataSource: dataSource[indexPath.row])
        }
        return contactCell
    }
}

extension addGuestViewController: addGuestTableViewCellDelegate {
    func didTapSelectButton(cell: addGuestTableViewCell) {
        if let indexPath = addGuestController.indexPath(for: cell) {
            if isNewEvent {
                if indexPath.section == 0 {
                    userDataSource.hives[indexPath.row].isSelected = !userDataSource.hives[indexPath.row].isSelected
                    cell.selectionMemberCheck(isSelected: userDataSource.hives[indexPath.row].isSelected)
                    self.dataSourceHolder.append(userDataSource.hives[indexPath.row].id)
                    
                } else if indexPath.section == 1 {
                    userDataSource.swarms[indexPath.row].isSelected = !userDataSource.swarms[indexPath.row].isSelected
                    cell.selectionMemberCheck(isSelected: userDataSource.swarms[indexPath.row].isSelected)
                    self.dataSourceHolder.append(userDataSource.swarms[indexPath.row].id)
                    
                } else {
                    userDataSource.phoneContacts[indexPath.row].isSelected = !userDataSource.phoneContacts[indexPath.row].isSelected
                    cell.selectionMemberCheck(isSelected: userDataSource.phoneContacts[indexPath.row].isSelected)
                    self.dataSourceHolder.append(userDataSource.phoneContacts[indexPath.row].id)
                }
                
            } else {
                dataSource[indexPath.row].isSelected = !dataSource[indexPath.row].isSelected
                cell.selectionMemberCheck(isSelected: dataSource[indexPath.row].isSelected)
                self.hiveDataSourceHolder.append(dataSource[indexPath.row].hiveMember.id)
            }
            
            for hive in userDataSource.hives {
                if hive.isSelected {
                    itemCount = itemCount + 1
                }
            }
            
            for swarm in userDataSource.swarms {
                if swarm.isSelected {
                    itemCount = itemCount + 1
                }
            }
            
            for phone in userDataSource.phoneContacts {
                if phone.isSelected {
                    itemCount = itemCount + 1
                }
            }
            
            if itemCount > 0 {
                self.navigationItem.title = "\(itemCount) selected"
                itemCount = 0
            
            } else {
                self.navigationItem.title = "Add Guests"
            }
        }
    }
}
