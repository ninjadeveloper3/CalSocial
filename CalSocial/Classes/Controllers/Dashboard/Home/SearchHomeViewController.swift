//
//  SearchHomeViewController.swift
//  CalSocial
//
//  Created by DevBatch on 07/02/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class SearchHomeViewController: UIViewController {

    //MARK: - Variables
    
    var isLoadData = false
    
    var dataSource = [UserCalender]()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var clearCross: UIButton!
    
    @IBOutlet weak var inputTextField: UITextField!
    
    //MARK:- UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    
    //MARK: - Setup ViewController Methods
    
    func setUpViewController() {
        self.navigationItem.title = "Search Events"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)) )
        
        tableView.separatorStyle = .none
        searchApi(searchTerm: "")
    }
    
    
    //MARK: - IBAction Methods
    
    @IBAction func searchClearTapped(_ sender: Any) {
        inputTextField.text = ""
        clearCross.isHidden = true
        searchApi(searchTerm: "")
    }
    
    
    @IBAction func searchTextAction(_ sender: UITextField) {
        if (sender as AnyObject).text!.count == 0 {
            clearCross.isHidden = true
        }else{
            clearCross.isHidden = false
        }
        
        searchApi(searchTerm: sender.text!)
    }
    
    //MARK: - Private Methods
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchApi(searchTerm: String) {
        let seachText = searchTerm.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.searchUserCalendar(searchTerm: seachText) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                self.dataSource.removeAll()
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.dataSource.removeAll()
                if let data = Mapper<UserCalender>().mapArray(JSONObject: result) {
                    self.isLoadData = true
                    self.dataSource = data
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension SearchHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoadData {
            return self.dataSource.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoadData {
            if section < self.dataSource.count {
                return self.dataSource[section].phoneEventData.count + self.dataSource[section].bizeeEventData.count + 1
            }
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == IndexPath(row: 0, section: indexPath.section) {
            let headCell = HeaderTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            if indexPath.section == 0 {
                headCell.dateLabel.textColor = #colorLiteral(red: 0.3102487624, green: 0.5006980896, blue: 0.5967903137, alpha: 1)
                
            } else {
                headCell.dateLabel.textColor = .gray
            }
            headCell.dateLabel.text = Date().convertDateFormat(date: dataSource[indexPath.section].date)
            return headCell
            
        } else {
            if (indexPath.row - 1) < self.dataSource[indexPath.section].phoneEventData.count  {
                let nonBizeeCell = NonEventTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                nonBizeeCell.initData(dataSource: self.dataSource[indexPath.section].phoneEventData[indexPath.row - 1])
                return nonBizeeCell
            
            } else {
                let index = indexPath.row - self.dataSource[indexPath.section].phoneEventData.count - 1
                
                
                if self.dataSource[indexPath.section].bizeeEventData[index].swarms.members.count > 0 {
                    let swarmEventCell = SwarmEventTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                    swarmEventCell.initData(dataSource: self.dataSource[indexPath.section].bizeeEventData[index],dateFormat: false)
                    return swarmEventCell
                    
                } else {
                    
                    let eventCell = EventTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                    eventCell.initData(dataSource: self.dataSource[indexPath.section].bizeeEventData[index],dateFormat: false)
                    eventCell.setStatus(status: self.dataSource[indexPath.section].bizeeEventData[index].myStatus)
                    return eventCell
                }
                
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath != IndexPath(row: 0, section: indexPath.section) {
            if (indexPath.row - 1) >= self.dataSource[indexPath.section].phoneEventData.count {
                let index = indexPath.row - self.dataSource[indexPath.section].phoneEventData.count - 1
                let newEventViewController = EventOwnerViewController()
                let newEventNavigationController = UINavigationController()
                newEventNavigationController.setupAppThemeNavigationBar()
                newEventViewController.id = self.dataSource[indexPath.section].bizeeEventData[index].id
                newEventViewController.eventTitle = self.dataSource[indexPath.section].bizeeEventData[index].title
                newEventNavigationController.viewControllers = [newEventViewController]
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.present(newEventNavigationController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section >= self.dataSource.count {
            return 120
        }
        return 0
    }    
}
