//
//  AddChatGuestViewController.swift
//  CalSocial
//
//  Created by DevBatch on 27/02/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

protocol AddChatGuestViewControllerDelegate {
    func didAddUserContacts(userContacts: BizeeUserModel)
}

class AddChatGuestViewController: UIViewController {
    
    //MARK: - Variables
    
    var userDataSource = Mapper<BizeeUserModel>().map(JSON: [:])!
    
    var selectedUserContacts = Mapper<BizeeUserModel>().map(JSON: [:])!
    
    var memberDatasource = [EventMember]()
    
    var delegate: AddChatGuestViewControllerDelegate?
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        tableView.separatorStyle = .none
        
        self.navigationItem.title = "New Message"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(addButtonTapped(sender:)))
        getAllExistingUser(page: 1, limit: 30000)
    }
    
    //MARK: - Private Methods
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addButtonTapped(sender: UIBarButtonItem) {
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
        if selectedUserContacts.hives.count > 0 || selectedUserContacts.swarms.count > 0 {
            delegate?.didAddUserContacts(userContacts: self.selectedUserContacts)
        }
        self.navigationController?.popViewController(animated: true)
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
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension AddChatGuestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return userDataSource.hives.count
        }
        return userDataSource.swarms.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addGuestTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        cell.delegate = self
        if indexPath.section == 0 {
            cell.initCellHiveData(dataSource: userDataSource.hives[indexPath.row])
        }
        
        if indexPath.section == 1 {
            cell.initCellSwarmData(dataSource: userDataSource.swarms[indexPath.row])
        }
        return cell
    }
}

extension AddChatGuestViewController: addGuestTableViewCellDelegate {
    func didTapSelectButton(cell: addGuestTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            
            if indexPath.section == 0 {
                userDataSource.hives[indexPath.row].isSelected = !userDataSource.hives[indexPath.row].isSelected
                cell.selectionMemberCheck(isSelected: userDataSource.hives[indexPath.row].isSelected)
                
            } else if indexPath.section == 1 {
                userDataSource.swarms[indexPath.row].isSelected = !userDataSource.swarms[indexPath.row].isSelected
                cell.selectionMemberCheck(isSelected: userDataSource.swarms[indexPath.row].isSelected)
            }
        }
    }
}

