//
//  BlockedUsersViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 08/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class BlockedUsersViewController: UIViewController {
    
    //MARK: - Variables
    
    var isDataLoading:Bool=false
    
    var pageNo:Int=1
    
    var limit:Int=10
    
    var offset:Int=0 //pageNo*limit
    
    var blockedUsersDataSource = [BlockedUsers]()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var crossButton: UIButton!
    
    @IBOutlet weak var searchInput: UITextField!
    
    
    
    @IBOutlet weak var blockedUsersTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        // Do any additional setup after loading the view.
    }
    
    func setUpViewController() {
        blockedUsersTableView.delegate = self
        blockedUsersTableView.dataSource = self
        blockedUsersTableView.separatorStyle = .none
        self.title = "Blocked Users"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)) )
        getBlockedUsersList(pageNo: pageNo, limit: limit)
    }
    //MARK: - IBActions
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    func getBlockedUsersList(pageNo: Int, limit: Int){
        Utility.showLoading(viewController: self)
        
        APIClient.sharedClient.doGetBlockedUsers(page: pageNo, limit: limit) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            }
            else{
                if let data = Mapper<BlockedUsers>().mapArray(JSONObject: result) {
                    if data.count == 0 {
                        self.isDataLoading = true
                        return
                    }
                    self.blockedUsersDataSource = data
//                    self.blockedUsersDataSource.append(contentsOf: data)
                    self.isDataLoading = false
                    self.blockedUsersTableView.reloadData()
                }
            }
        }
    }
    
    func doUnBlockUser(userId: Int){
        Utility.showLoading(viewController: self)
        
        APIClient.sharedClient.doUnBlockUser(userId: userId) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            }
            else{
                
                self.blockedUsersDataSource = self.blockedUsersDataSource.filter { $0.id != userId }
                self.blockedUsersTableView.reloadData()
            }
        }
    }
    
    @IBAction func crossButtonTapped(_ sender: Any) {
        searchInput.text = ""
        crossButton.isHidden = true
        blockedUsersDataSource.removeAll()
        getBlockedUsersList(pageNo: pageNo, limit: limit)
    }
    
    
    @IBAction func searchBlockedUser(_ sender: UITextField) {
        //        if sender.text!.count > 0 {
        //            self.searchIcon.image = #imageLiteral(resourceName: "close")
        //            self.searchIcon.bounds.size = CGSize(width: 15, height: 15)
        //        }
        if sender.text!.isEmpty{
            crossButton.isHidden = true
            blockedUsersDataSource.removeAll()
            getBlockedUsersList(pageNo: pageNo, limit: limit)
            
        }
        else{
            crossButton.isHidden = false
            let txt = sender.text!.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
                        searchBlockedUsersList(TxtSearch: txt)
            print("search user-->",txt)
        }
    }
    
        func searchBlockedUsersList(TxtSearch: String){
            Utility.showLoading(viewController: self)
            APIClient.sharedClient.doSearchBlockedUsersList(searchUser: TxtSearch) { (response, result, error, message) in
                Utility.hideLoading(viewController: self)
                if error != nil {
                    error?.showErrorBelowNavigation(viewController: self)
    
                } else {
                    if let data = Mapper<BlockedUsers>().mapArray(JSONObject: result) {
                        if data.count == 0 {
                            self.isDataLoading = true
                            return
                        }
                        self.blockedUsersDataSource.removeAll()
//                        self.blockedUsersDataSource.append(contentsOf: data)
                        self.blockedUsersDataSource = data
                        self.isDataLoading = false
                        self.blockedUsersTableView.reloadData()
                    }
                }
            }
        }
    
}

extension BlockedUsersViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockedUsersDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BlockedUsersTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        cell.delegate = self
        cell.name.text = self.blockedUsersDataSource[indexPath.row].firstName+" "+self.blockedUsersDataSource[indexPath.row].lastName
        if self.blockedUsersDataSource[indexPath.row].profilePic == "" {
            cell.emptyImageView.isHidden = false
            cell.emptyImageLabel.text = self.blockedUsersDataSource[indexPath.row].firstName.getFirstChar()+self.blockedUsersDataSource[indexPath.row].lastName.getFirstChar()
        }
        else{
            cell.emptyImageView.isHidden = true
            if let url = URL(string: "\(kImageDownloadBaseUrl)\(self.blockedUsersDataSource[indexPath.row].profilePic)") {
                cell.profileImage.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                })
            }
        }
        return cell
    }
    
}

extension BlockedUsersViewController : BlockedUsersTableViewCellDelegate{
    func didSelectRow(cell: BlockedUsersTableViewCell) {
        if let indexPath = blockedUsersTableView.indexPath(for: cell) {
            let blockedUserObj = self.blockedUsersDataSource[indexPath.row]
            //                        selectedContact.removeAll()
            //                        contactObject.id = self.hiveContactsdataSource[indexPath.row].member.id
            //                        selectedContact.append(contactObject)
            //                        sendHiveRequest()
            self.doUnBlockUser(userId: blockedUserObj.id)
        }
    }
}
