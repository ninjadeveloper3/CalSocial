//
//  PhoneContactViewController.swift
//  CalSocial
//
//  Created by DevBatch on 02/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper
import ContactsUI


class PhoneContactViewController: UIViewController {
    
    //MARK: - Variables
    
    var contactDatasouce = [Contacts]()
    
    var selectedContact = [BizeeContactsRequestModel]()
    
    var isSynced = true
    
    var isSwarm = false
    
    var userId = 0
    
    var isDataLoading:Bool=false
    
    var pageNo:Int=1
    
    var limit:Int=10
    
    var offset:Int=0 //pageNo*limit
    
    var dataSource = [PhoneContacts]()
    
    var bizeeContactsdataSource = [AllBizeeContactsonNetwork]()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var addContactTableView: UITableView!
    
    @IBOutlet weak var emptyView: UIView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var clearCross: UIButton!
    
    
    //MARK:- UIViewController Methods
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.emptyView.isHidden = true
        }
        doSyncPhoneContacts()
        setUpViewController()
    }
    
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        pageNo = 1
        
        if Utility.isKeyPresentInUserDefaults(key: kUserId){
            self.userId = UserDefaults.standard.object(forKey: kUserId) as! Int
        }
        addContactTableView.separatorStyle = .none
        //        if isSwarm {
        //            bizeeContactsdataSource.removeAll()
        //            doGetBizeeContacts(pageNo: pageNo, limit: limit)
        //
        //        } else {
        //            dataSource.removeAll()
        //            doGetPhoneContacts(pageNo: pageNo, limit: limit)
        //        }
        //        DispatchQueue.main.async {
        //            self.searchTextField.text = ""
        //        }
    }
    
    //MARK: - Private Methods
    
    func doGetPhoneContacts(pageNo: Int, limit: Int, isSearch: Bool = false){
        Utility.showLoading(viewController: self)
        
        APIClient.sharedClient.getPhoneContactsList(userId: self.userId, pageNo: pageNo, limit: limit) { (response, result, error, message) in
            if isSearch {
                self.dataSource.removeAll()
            }
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: true)
                
            } else {
                if let data = Mapper<PhoneContacts>().mapArray(JSONObject: result) {
                    self.dataSource.append(contentsOf: data)
                    if self.dataSource.count == 0 {
                        DispatchQueue.main.async {
                            if !isSearch {
                                self.emptyView.isHidden = false
                            }
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        self.addContactTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func doGetBizeeContacts(pageNo: Int, limit: Int, isSearch: Bool = false){
        Utility.showLoading(viewController: self)
        
        APIClient.sharedClient.getBizeeContactsList(userId: self.userId, pageNo: pageNo, limit: limit) { (response, result, error, message) in
            if isSearch {
                self.bizeeContactsdataSource.removeAll()
            }
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: true)
                
            }
            else{
                if let data = Mapper<AllBizeeContactsonNetwork>().mapArray(JSONObject: result) {
                    if data.count == 0 {
                        self.isDataLoading = true
                        return
                    }
                    //                    self.bizeeContactsdataSource = data
                    self.bizeeContactsdataSource.append(contentsOf: data)
                    if self.bizeeContactsdataSource.count == 0 {
                        DispatchQueue.main.async {
                            self.emptyView.isHidden = false
                        }
                        return
                    }
                    self.isDataLoading = false
                    DispatchQueue.main.async {
                        self.addContactTableView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: - IBActions
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addSwarmTapped(sender: UIBarButtonItem) {
        if isSwarm {
            self.navigationController?.pushViewController(NewSwarmViewController(), animated: true)
        }
        
    }
    
    @IBAction func syncContactsButtonTapped(_ sender: Any) {
        doSyncPhoneContacts()
    }
    
    @IBAction func clearSearchTapped(_ sender: Any) {
        searchTextField.text = ""
        clearCross.isHidden = true
        pageNo = 1
        if isSwarm{
            bizeeContactsdataSource.removeAll()
            doGetBizeeContacts(pageNo: pageNo, limit: limit)
        }
        else{
            dataSource.removeAll()
            doGetPhoneContacts(pageNo: pageNo, limit: limit, isSearch: true)
        }
    }
    
    
    @IBAction func searchChanged(_ sender: UITextField) {
        if sender.text!.isEmpty{
            
            clearCross.isHidden = true
            if isSwarm {
                bizeeContactsdataSource.removeAll()
                doGetBizeeContacts(pageNo: pageNo, limit: limit, isSearch: true)
            }
            else{
                dataSource.removeAll()
                doGetPhoneContacts(pageNo: pageNo, limit: limit, isSearch: true)
            }
        }
        else{
            clearCross.isHidden = false
            let txt = sender.text!.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            if isSwarm {
                searchBizeeContacts(TxtSearch: txt,pageNo: -1, limit: 1000)
                
            }
            else{
                searchPhoneContacts(TxtSearch: txt,pageNo: -1, limit: 1000)
                
            }
        }
    }
    
    func searchBizeeContacts(TxtSearch: String,pageNo: Int,limit: Int){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.doSearchBizeeContacts(searchUser: TxtSearch,page: -1, limit: 1000) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<AllBizeeContactsonNetwork>().mapArray(JSONObject: result) {
                    if data.count == 0 {
                        self.isDataLoading = true
                    }
                    self.dataSource.removeAll()
                    self.bizeeContactsdataSource = data
                    self.isDataLoading = false
                    DispatchQueue.main.async {
                        self.addContactTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func searchPhoneContacts(TxtSearch: String,pageNo: Int,limit: Int){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.doSearchContacts(searchUser: TxtSearch,page: -1, limit: 1000) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<PhoneContacts>().mapArray(JSONObject: result) {
                    if data.count == 0 {
                        self.isDataLoading = true
                    }
                    self.dataSource.removeAll()
                    self.dataSource = data
                    self.isDataLoading = false
                    DispatchQueue.main.async {
                        self.addContactTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func doSyncPhoneContacts(){
        //contact syncing
        Utility.showLoading(viewController: self)
        
        var contacts = [CNContact]()
        let contactStore = CNContactStore()
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),CNContactPhoneNumbersKey] as [Any] //CNContactIdentifierKey
        
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        
        do {
            try contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
            }
            
            for (_,contact) in contacts.enumerated() {
                //                print("contact name-->",contact.givenName)
                
                for (_,phone) in contact.phoneNumbers.enumerated() {
                    //                    print("phone Number->",phone.value.stringValue)
                    
                    if let countryCode = phone.value.value(forKey: "countryCode") as? String {
                        if countryCode == "us" {
                            let contactObject = Mapper<Contacts>().map(JSON: [:])!
                            contactObject.name = contact.givenName != "" ? contact.givenName : "NoName"
                            contactObject.phone = phone.value.stringValue != "" ? phone.value.stringValue : ""
                            contactObject.phone = contactObject.phone.replacingOccurrences(of: " ", with: "")
                            contactObject.phone = contactObject.phone.replacingOccurrences(of: "(", with: "")
                            contactObject.phone = contactObject.phone.replacingOccurrences(of: ")", with: "")
                            contactObject.phone = contactObject.phone.replacingOccurrences(of: "-", with: "")
                            debugPrint(contactObject.name)
                            debugPrint(contactObject.phone)
                            //                            let phone = contactObject.phone
                            //                            let countryCode = String(phone.prefix(2))
                            //                            if countryCode == "+1" {
                            //                                contactDatasouce.append(contactObject)
                            //                            }
                            contactDatasouce.append(contactObject)
                        }
                        
                    }
                }
            }
            doSaveContactsApi()
        }
        catch {
            Utility.hideLoading(viewController: self)
            NSError.showErrorWithMessage(message: "Unable to fetch contacts", viewController: self, type: .error, isNavigation: true)
            
            print("unable to fetch contacts")
        }
    }
    
    func doSaveContactsApi(){
        
        APIClient.sharedClient.saveContactsList(contactsList: contactDatasouce){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: true)
                
            }
            else{
                self.emptyView.isHidden = true
                if self.isSwarm{
                    self.doGetBizeeContacts(pageNo: self.pageNo, limit: self.limit)
                }
                else{
                    self.doGetPhoneContacts(pageNo: self.pageNo, limit: self.limit)
                }
            }
        }
    }
    
    func sendHiveRequest(){
        APIClient.sharedClient.sendBizeeRequest(contactsList: selectedContact){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: true)
                
            }
            else{
                print("success")
            }
        }
    }
    
    func sendBizeeAppRequest(datasource: PhoneContacts){
        APIClient.sharedClient.sendBizeeAppRequest(phone: datasource.phone){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: true)
                
            }
            else{
            }
        }
    }
}

extension PhoneContactViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSwarm {
            return bizeeContactsdataSource.count
        }
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if isSwarm {
            let CalSocialCell = NonCalSocialContactTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            CalSocialCell.delegate = self
            if self.bizeeContactsdataSource[indexPath.row].pic == "" {
                CalSocialCell.emptyImageView.isHidden = false
                CalSocialCell.emptyImageViewText.text = self.bizeeContactsdataSource[indexPath.row].fname.getFirstChar()+self.bizeeContactsdataSource[indexPath.row].lname.getFirstChar()
                CalSocialCell.profileImageView.image = nil
                
            } else {
                CalSocialCell.emptyImageView.isHidden = true
                if let url = URL(string: "\(kImageDownloadBaseUrl)\(self.bizeeContactsdataSource[indexPath.row].pic)") {
                    print("url",url)
                    CalSocialCell.profileImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                }
            }
            CalSocialCell.statusLabel.text = ""
            CalSocialCell.contactNameLabel.text =  "\(self.bizeeContactsdataSource[indexPath.row].fname) \(self.bizeeContactsdataSource[indexPath.row].lname)"
            CalSocialCell.setStatus(status: self.bizeeContactsdataSource[indexPath.row].status,type: "")
            return CalSocialCell
            
        } else {
            
            let nonCalSocialCell = NonCalSocialContactTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            nonCalSocialCell.delegate = self
            nonCalSocialCell.contactNameLabel.text = self.dataSource[indexPath.row].name
            nonCalSocialCell.emptyImageView.isHidden = false
            nonCalSocialCell.emptyImageViewText.text = self.dataSource[indexPath.row].name.getFirstChar()
            nonCalSocialCell.setStatus(status: self.dataSource[indexPath.row].contactStatus,type: "nonBizee")
            return nonCalSocialCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSwarm {
            let userProfileViewController = UserProfileViewController()
            let profileNavigationController = UINavigationController()
            profileNavigationController.setupAppThemeNavigationBar()
            userProfileViewController.userId = self.bizeeContactsdataSource[indexPath.row].id
            userProfileViewController.userName = self.bizeeContactsdataSource[indexPath.row].fname+" "+self.bizeeContactsdataSource[indexPath.row].lname
            userProfileViewController.fName = self.bizeeContactsdataSource[indexPath.row].fname
            userProfileViewController.lName = self.bizeeContactsdataSource[indexPath.row].lname
            userProfileViewController.firstName = self.bizeeContactsdataSource[indexPath.row].fname
            userProfileViewController.canIvited = self.bizeeContactsdataSource[indexPath.row].canBeInvited
            userProfileViewController.delegate = self
            let status = self.bizeeContactsdataSource[indexPath.row].status
            
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
            
            profileNavigationController.viewControllers = [userProfileViewController]
            profileNavigationController.modalPresentationStyle = .fullScreen
            self.present(profileNavigationController, animated: true, completion: nil)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        
        if ((addContactTableView.contentOffset.y + addContactTableView.frame.size.height) >= addContactTableView.contentSize.height)
        {
            if !isDataLoading {
                isDataLoading = true
                self.pageNo=self.pageNo+1
                if isSwarm{
                    doGetBizeeContacts(pageNo: self.pageNo, limit: self.limit)
                
                } else {
                    doGetPhoneContacts(pageNo: self.pageNo, limit: self.limit)
                }
            }
        }
    }
}

extension PhoneContactViewController : NonCalSocialContactTableViewCellDelegate{
    func didFinishTask(cell: NonCalSocialContactTableViewCell) {
        if let indexPath = addContactTableView.indexPath(for: cell) {
            if isSwarm {
                print(self.bizeeContactsdataSource[indexPath.row].id)
                let contactObject = Mapper<BizeeContactsRequestModel>().map(JSON: [:])!
                contactObject.id = self.bizeeContactsdataSource[indexPath.row].id
                selectedContact.removeAll()
                selectedContact.append(contactObject)
                if(cell.requestSendLabel.isHidden){
                    cell.uploadIconBtn.isHidden = true
                    cell.requestSendLabel.isHidden = false
                    self.bizeeContactsdataSource[indexPath.row].status = 3
                    self.addContactTableView.reloadData()
                }
                sendHiveRequest()
                
            } else {
                
                if self.dataSource[indexPath.row].contactStatus == 5 { //send bizee join invitation
                    self.dataSource[indexPath.row].contactStatus = 3
                    cell.setStatus(status: self.dataSource[indexPath.row].contactStatus, type: "nonBizee")
                    self.sendBizeeAppRequest(datasource: self.dataSource[indexPath.row])
                    
                } else if self.dataSource[indexPath.row].contactStatus == 0 { //send hive request
                    let contactObject = Mapper<BizeeContactsRequestModel>().map(JSON: [:])!
                    contactObject.id = self.dataSource[indexPath.row].ifContactId
                    selectedContact.removeAll()
                    selectedContact.append(contactObject)
                    cell.requestSendLabel.text = "Request Sent!"
                    
                    cell.uploadIconBtn.isHidden = true
                    cell.requestSendLabel.isHidden = false
                    
                    self.dataSource[indexPath.row].contactStatus = 3
                    self.addContactTableView.reloadData()
                    sendHiveRequest()
                }
            }
        }
    }
}

extension PhoneContactViewController: UserProfileViewControllerDelegate {
    func didUpdateUserProfile() {
        if isSwarm {
            bizeeContactsdataSource.removeAll()
            doGetBizeeContacts(pageNo: pageNo, limit: limit)
        }
    }
}
