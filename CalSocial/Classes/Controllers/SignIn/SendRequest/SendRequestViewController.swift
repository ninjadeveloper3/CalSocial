//
//  SendRequestViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 30/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class SendRequestViewController: UIViewController {
    
    //MARK: - Veriables
    
    var userId = 0
    
    var dataSource = [BizeeContactsModel]()
    
    var selectedContacts = [BizeeContactsRequestModel]()
    
    var isAllSelected = false
    
    var isDataLoading:Bool=false
    
    var pageNo:Int=1
    
    var limit:Int=10
    
    var offset:Int=0 //pageNo*limit
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var contactTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        contactTableView.delegate = self
        contactTableView.dataSource = self
        contactTableView.separatorStyle = .none
        if Utility.isKeyPresentInUserDefaults(key: kUserId){
            self.userId = UserDefaults.standard.object(forKey: kUserId) as! Int
        }
        pageNo = 1
        getBizeeUsersContactsList(pageNo: pageNo, limit: limit)
    }
    
    //MARK: - Private Methods
    
    func getBizeeUsersContactsList(pageNo: Int, limit: Int){
        Utility.showLoading(viewController: self)
        
        APIClient.sharedClient.getBizeeUsersList(userId: userId,pageNo: pageNo,limit: limit) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<BizeeContactsModel>().mapArray(JSONObject: result) {
                    self.dataSource.append(contentsOf: data)
                    self.contactTableView.reloadData()
                }
            }
        }
    }
    
    func doSendBizeeRequest(){
        
        
        APIClient.sharedClient.sendBizeeRequest(contactsList: selectedContacts){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            }
            else{
                
               self.navigationController?.pushViewController(calenderSyncSelectionViewController(), animated: true)
            }
        }
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func sendRequestButtonTapped(_ sender: Any) {
        if dataSource.count > 0 {
            if selectedContacts.count > 0 {
                doSendBizeeRequest()
            }
            else{
                NSError.showErrorWithMessage(message: "Please select atleast 1 contact for sending request!", viewController: self, type: .error, isNavigation: false)
            }
            
        } else {
            NSError.showErrorWithMessage(message: "You do not have Bizee contacts in your Phone contacts. Please press Skip for now", viewController: self, type: .error, isNavigation: false)
        }
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        self.navigationController?.pushViewController(calenderSyncSelectionViewController(), animated: true)
    }
}
extension SendRequestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let labCell = RequestSendTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        
        if !isAllSelected {
            labCell.radioButton.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            
        } else {
            labCell.radioButton.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        }
        
        if indexPath.row == 0 {
            if (dataSource.count > 0){
            labCell.contantNameLabel.text = "Select All"
            }
            else{
                labCell.isHidden = true
            }
            
            
        } else {
            labCell.contantNameLabel.text = dataSource[indexPath.row - 1].name
            if !(dataSource[indexPath.row-1].isSelected) {
                labCell.radioButton.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
                
            } else {
                labCell.radioButton.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
            }
        }
        
        
        return labCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            isAllSelected = !isAllSelected
                for (index,_) in dataSource.enumerated() {
                    dataSource[index].isSelected = isAllSelected
                    let contactObject = Mapper<BizeeContactsRequestModel>().map(JSON: [:])!
                    contactObject.id = dataSource[index].id
                    selectedContacts.append(contactObject)
                }
            if !isAllSelected {
                selectedContacts.removeAll()
            }
            print("check",selectedContacts)
            
        } else {
            dataSource[indexPath.row-1].isSelected = !dataSource[indexPath.row-1].isSelected
            if dataSource[indexPath.row-1].isSelected{
                let contactObject = Mapper<BizeeContactsRequestModel>().map(JSON: [:])!
                contactObject.id = dataSource[indexPath.row-1].id
                selectedContacts.append(contactObject)
            }
            else{
                for val in selectedContacts  {
                    if val.id == dataSource[indexPath.row-1].id {
                        if let index = selectedContacts.index(where: { $0.id == val.id }) {
                            print("to remove",index)
                            selectedContacts.remove(at: index)
                        }
                    }
                }
                print("filtered array",selectedContacts)
            }
            isAllSelected = false
        }
        contactTableView.reloadData()
    }
}
