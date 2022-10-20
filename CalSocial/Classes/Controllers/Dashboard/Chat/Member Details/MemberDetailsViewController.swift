//
//  MemberDetailsViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 02/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class MemberDetailsViewController: UIViewController {
    
    //MARK: - Variables
    
    var members = [AttMember]()
    
    var hiveContactsdataSource = [ChatMembersModel]()
    
    var selectedContact = [BizeeContactsRequestModel]()
    
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
        
        self.navigationItem.title = "Details"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        tableView.separatorStyle = .none
        self.hiveContactsdataSource.removeAll()
        getMembersStatus()
    }
    
    //MARK: - Private Methods
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getMembersStatus() {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getUserHiveStatus(members: self.members) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<ChatMembersModel>().mapArray(JSONObject: result) {
                    self.hiveContactsdataSource = data.removingDuplicates(byKey:{ $0.id })
                    self.tableView.reloadData()
                }
            }
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
}

extension MemberDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hiveContactsdataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let labCell = HiveListTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        labCell.delegate = self
        if self.hiveContactsdataSource[indexPath.row].profilePic == "" {
            labCell.emptyImageView.isHidden = false
            labCell.emptyImageLabel.text = self.hiveContactsdataSource[indexPath.row].fname.getFirstChar() + self.hiveContactsdataSource[indexPath.row].lname.getFirstChar()
            
        } else {
            labCell.emptyImageView.isHidden = true
            if let url = URL(string: "\(kImageDownloadBaseUrl)\(self.hiveContactsdataSource[indexPath.row].profilePic)") {
                print("url",url)
                labCell.contactImageView.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "Group 4098"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                })
            }
        }
        
        labCell.contactNameLabel.text = self.hiveContactsdataSource[indexPath.row].fname+" "+self.hiveContactsdataSource[indexPath.row].lname
        
        if let userId = UserDefaults.standard.object(forKey: kUserId) as? Int {
            if  userId == self.hiveContactsdataSource[indexPath.row].id {
                labCell.setStatus(status: -1)
                
            } else {
                labCell.setStatus(status: self.hiveContactsdataSource[indexPath.row].status)
            }
        }
        return labCell
    }
}

extension MemberDetailsViewController : HiveListTableViewCellDelegate {
    func didFinishTask(cell: HiveListTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let contactObject = Mapper<BizeeContactsRequestModel>().map(JSON: [:])!
            selectedContact.removeAll()
            contactObject.id = self.hiveContactsdataSource[indexPath.row].id
            selectedContact.append(contactObject)
            sendHiveRequest()
        }
    }
}
