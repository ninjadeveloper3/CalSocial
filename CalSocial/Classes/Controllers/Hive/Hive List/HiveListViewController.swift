//
//  HiveListViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 03/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireImage

class HiveListViewController: UIViewController {
    
    //MARK:- Variables
    
    var userId = 0
    
    var myUserId = 0
    
    var userName = ""
    
    var fName = ""
    
    var lName = ""
    
    var hiveContactsdataSource = [HiveUser]()
    
    var selectedContact = [BizeeContactsRequestModel]()
    
    var isDataLoading:Bool=false
    
    var pageNo:Int=1
    
    var limit:Int=10
    
    var offset:Int=0 //pageNo*limit
    
    var myHive = false
    
    //    var dataSource = [HiveList]()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var hiveTableView: UITableView!
    
    @IBOutlet weak var searchInput: UITextField!
    
    @IBOutlet weak var crossButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        pageNo = 1
//        if self.userId == self.myUserId {
//            getMyHiveList(pageNo: pageNo, limit: limit, isSearch: true)
//        }
//        else{
//            getOtherHiveList(pageNo: pageNo, limit: limit, isSearch: true)
//        }
    }
    
    func setUpViewController() {
        
        hiveTableView.delegate = self
        hiveTableView.dataSource = self
        hiveTableView.separatorStyle = .none
        
        if userName == " " ||  userName == ""{
            self.navigationItem.title = fName+"'s Hive"
        }
        else{
        self.navigationItem.title = userName+"'s Hive"
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        if Utility.isKeyPresentInUserDefaults(key: kUserId) {
            if let userid  = UserDefaults.standard.object(forKey: kUserId) as? Int {
                self.myUserId = userid
            }
        }
        pageNo = 1
        if self.userId == self.myUserId {
            getMyHiveList(pageNo: pageNo, limit: limit)
        }
        else{
            getOtherHiveList(pageNo: pageNo, limit: limit)
        }
        
    }
    
    //MARK: - Private Methods
    
    func getMyHiveList(pageNo: Int, limit: Int, isSearch: Bool = false) {
        APIClient.sharedClient.getHive(page: pageNo, limit: limit) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if isSearch {
                self.hiveContactsdataSource.removeAll()
            }
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<HiveUser>().mapArray(JSONObject: result) {
                    if data.count == 0 {
                        self.isDataLoading = true
                        return
                    }
                    self.hiveContactsdataSource.append(contentsOf: data)
                    self.isDataLoading = false
                    self.hiveTableView.reloadData()
                }
            }
        }
    }
    
    func getOtherHiveList(pageNo: Int, limit: Int, isSearch: Bool = false){
        Utility.showLoading(viewController: self)
        
        APIClient.sharedClient.getOtherHive(userId: self.userId, pageNo: pageNo, limit: limit) { (response, result, error, message) in
            if isSearch {
                self.hiveContactsdataSource.removeAll()
            }
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            }
            else{
                if let data = Mapper<HiveUser>().mapArray(JSONObject: result) {
                    if data.count == 0 {
                        self.isDataLoading = true
                        return
                    }
                    
                    self.hiveContactsdataSource.append(contentsOf: data)
                    self.isDataLoading = false
                    self.hiveTableView.reloadData()
                }
            }
        }
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearSearchButtonTapped(_ sender: Any) {
        searchInput.text = ""
        crossButton.isHidden = true
        hiveContactsdataSource.removeAll()
        pageNo = 1
        if self.userId == self.myUserId {
            getMyHiveList(pageNo: pageNo, limit: limit, isSearch: true)
        }
        else{
            getOtherHiveList(pageNo: pageNo, limit: limit,isSearch: true)
        }
    }
    
    
    func sendHiveRequest(){
        APIClient.sharedClient.sendBizeeRequest(contactsList: selectedContact){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                
            }
        }
    }
    
    @IBAction func onEditingChanged(_ sender: UITextField) {
        if sender.text!.isEmpty{
            crossButton.isHidden = true
            hiveContactsdataSource.removeAll()
            pageNo = 1
            if self.userId == self.myUserId {
                getMyHiveList(pageNo: pageNo, limit: limit, isSearch: true)
            }
            else{
                getOtherHiveList(pageNo: pageNo, limit: limit,isSearch: true)
            }
            
        } else {
            crossButton.isHidden = false
            let txt = sender.text!.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            
            if self.userId == self.myUserId {
                searchMyHiveMembers(TxtSearch: txt,pageNo: pageNo, limit: limit)
            
            } else {
                searchHiveMembers(TxtSearch: txt,pageNo: pageNo, limit: limit)
            }
        }
    }
    
    func searchMyHiveMembers(TxtSearch: String,pageNo: Int,limit: Int){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.doSearchHive(searchUser: TxtSearch,page: pageNo, limit: limit) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<HiveUser>().mapArray(JSONObject: result) {
                    if data.count == 0 {
                        self.isDataLoading = true
                    }
                    self.hiveContactsdataSource.removeAll()
                    self.hiveContactsdataSource = data
                    self.isDataLoading = false
                    self.hiveTableView.reloadData()
                }
            }
        }
    }
    
    func searchHiveMembers(TxtSearch: String,pageNo: Int,limit: Int){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.doSearchOtherHive(searchUser: TxtSearch,hiveId: self.userId,page: pageNo, limit: limit) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<HiveUser>().mapArray(JSONObject: result) {
                    if data.count == 0 {
                        self.isDataLoading = true
                    }
                    self.hiveContactsdataSource.removeAll()
                    self.hiveContactsdataSource = data
                    self.isDataLoading = false
                    self.hiveTableView.reloadData()
                }
            }
        }
    }
    
}

extension HiveListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hiveContactsdataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let labCell = HiveListTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        labCell.delegate = self
        if self.hiveContactsdataSource[indexPath.row].member.profilePic == "" {
            labCell.emptyImageView.isHidden = false
            labCell.emptyImageLabel.text = self.hiveContactsdataSource[indexPath.row].member.fname.getFirstChar()+self.hiveContactsdataSource[indexPath.row].member.lname.getFirstChar()
            
        } else {
            labCell.emptyImageView.isHidden = true
            if let url = URL(string: "\(kImageDownloadBaseUrl)\(self.hiveContactsdataSource[indexPath.row].member.profilePic)") {
                print("url",url)
                labCell.contactImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                })
            }
        }
        
        labCell.contactNameLabel.text = self.hiveContactsdataSource[indexPath.row].member.fname+" "+self.hiveContactsdataSource[indexPath.row].member.lname
        if myHive {
            labCell.notHiveLabel.isHidden = true
            labCell.hiveImageView.isHidden = true
            
        } else {
            labCell.setStatus(status: self.hiveContactsdataSource[indexPath.row].status)
        }
        return labCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userProfileViewController = UserProfileViewController()
        
        
        userProfileViewController.userId = self.hiveContactsdataSource[indexPath.row].member.id
        userProfileViewController.userName = self.hiveContactsdataSource[indexPath.row].member.fname
        userProfileViewController.firstName = self.hiveContactsdataSource[indexPath.row].member.fname
        let status = self.hiveContactsdataSource[indexPath.row].status
        
        if status == 0 { //add to hive
            userProfileViewController.profileType = .AddHive
        }
        if status == 1 { //in your hive
            userProfileViewController.profileType = .InHive
        }
        if status == 2 { //request received
            userProfileViewController.profileType = .AcceptDecline
        }
        if status == 3 { //request Sent
            userProfileViewController.profileType = .RequestSent
        }
        userProfileViewController.delegate = self
        let profileNavigationController = UINavigationController()
        profileNavigationController.setupAppThemeNavigationBar()
        profileNavigationController.viewControllers = [userProfileViewController]
        self.present(profileNavigationController, animated: true, completion: nil)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        
        if ((hiveTableView.contentOffset.y + hiveTableView.frame.size.height) >= hiveTableView.contentSize.height) {
            if !isDataLoading {
                isDataLoading = true
                self.pageNo = self.pageNo + 1
            }
            getOtherHiveList(pageNo: self.pageNo, limit: self.limit)
        }
    }
}


extension HiveListViewController : HiveListTableViewCellDelegate{
    func didFinishTask(cell: HiveListTableViewCell) {
        if let indexPath = hiveTableView.indexPath(for: cell) {
            let contactObject = Mapper<BizeeContactsRequestModel>().map(JSON: [:])!
            selectedContact.removeAll()
            contactObject.id = self.hiveContactsdataSource[indexPath.row].member.id
            selectedContact.append(contactObject)
            sendHiveRequest()
        }
    }
    
}

extension HiveListViewController: UserProfileViewControllerDelegate {
    func didUpdateUserProfile() {
            pageNo = 1
            if self.userId == self.myUserId {
                self.hiveContactsdataSource.removeAll()
                getMyHiveList(pageNo: pageNo, limit: limit)
            }
            else{
                self.hiveContactsdataSource.removeAll()
                getOtherHiveList(pageNo: pageNo, limit: limit)
            }
        }
    
    
}
