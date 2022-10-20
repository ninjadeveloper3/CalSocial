//
//  ChooseTimeViewController.swift
//  CalSocial
//
//  Created by DevBatch on 02/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

protocol ChooseTimeViewControllerDelegate {
    func didUseTimeTapped(date: String, startTime: String, endTime: String)
}

class ChooseTimeViewController: UIViewController {

    //MARK: - IBOutlets
    
    var userContactDataSource = Mapper<BizeeUserModel>().map(JSON: [:])!
    
    var swarmMemberDataSource = [SwarmMember]()
    
    var selectedDate = ""
    
    var userId = 0
    
    var selectedStartTime = ""
    
    var selectedEndTime = ""
    
    var dataSource = [EventData]()
    
    var guestIds = [Int]()
    
    var isLoadData = false
    
    var dateObject = Date()
    
    var stringStartTime = ""
    
    var stringEndTime = ""
    
    var suggestedScore = [Guests]()
    
    
    
    var delegate: ChooseTimeViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var eventDateView: UILabel!
    
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var endTime: UILabel!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        guestIds.removeAll()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        
        let timeFormatter = DateFormatter()
        var startDateHolder = Date()
        var endDateHolder = Date()
        timeFormatter.dateFormat = "hh:mma"
        startDateHolder = timeFormatter.date(from: stringStartTime) ?? Date()
        stringStartTime = timeFormatter.string(from: startDateHolder)
        
        endDateHolder = timeFormatter.date(from: stringEndTime) ?? Date()
        stringEndTime = timeFormatter.string(from: endDateHolder)
        
//        timeFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
//        var dateObj = timeFormatter.date(from: selectedDate)
////        let modifiedDate = Calendar.current.date(byAdding: .day, value: -1, to: dateObj ?? Date()) ?? Date()
//        let date = timeFormatter.string(from: dateObj ?? Date())
        
        let stringDateFormatter = DateFormatter()
        stringDateFormatter.dateFormat = "yyyy-MM-dd"
        let customDate = stringDateFormatter.date(from: selectedDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let modifiedDate = dateFormatter.string(from: customDate ?? Date())
        
        
        startTime.text =  stringStartTime
        endTime.text = stringEndTime
        eventDateView.text = modifiedDate
        
        self.navigationItem.title = "Date & Time"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        dataSource.removeAll()
        getEventData()
    }
    
    //MARK: - Private Methods
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    func getEventData() {
        if userContactDataSource.phoneContacts.count > 0 {
            for phoneContacts in userContactDataSource.phoneContacts {
                guestIds.append(phoneContacts.id)
            }
        }
        
        if userContactDataSource.swarms.count > 0 {
            for swarm in userContactDataSource.swarms {
                for members in swarm.swarm.swarmMembers {
                    guestIds.append(members.userId)
                }
            }
        }
        
        if userContactDataSource.hives.count > 0 {
            for hives in userContactDataSource.hives {
                guestIds.append(hives.hiveMember.id)
            }
        }
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getEventData(hostId: userId, guestIds: guestIds, eventDate: selectedDate, startTime: selectedStartTime, endTime: selectedEndTime) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.isLoadData = true
                if let data = Mapper<EventData>().mapArray(JSONObject: result) {
                    self.dataSource = data
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension ChooseTimeViewController: UITableViewDelegate, UITableViewDataSource, ChooseTimeTableViewCellDelegate {
    func didUseButtonTapped(cell: ChooseTimeTableViewCell) {
        
        if let indexPath = tableView.indexPath(for: cell) {
            let controllers = self.navigationController?.viewControllers
            for vc in controllers! {
                if vc is EventFormViewController {
                    let eventViewController = vc as! EventFormViewController
                    if indexPath.section == 0 {
                        self.suggestedScore =  dataSource[0].guests.filter({$0.guestId != userId })
                        eventViewController.selectedDate = dataSource[0].eventDate
                        eventViewController.selectedStartTime = dataSource[0].startTime
                        eventViewController.selectedEndTime = dataSource[0].endTime
                        eventViewController.score = dataSource[0].score
                        eventViewController.isScoreUpdate = true
                        eventViewController.suggestedScore = self.suggestedScore
                        
                    } else {
                        self.suggestedScore = dataSource[indexPath.row+1].guests.filter({$0.guestId != userId })
                        eventViewController.selectedDate = dataSource[indexPath.row+1].eventDate
                        eventViewController.selectedStartTime = dataSource[indexPath.row+1].startTime
                        eventViewController.selectedEndTime = dataSource[indexPath.row+1].endTime
                        eventViewController.score = dataSource[indexPath.row+1].score
                        eventViewController.isScoreUpdate = true
                        eventViewController.suggestedScore = self.suggestedScore
                    }
                    self.navigationController?.popToViewController(eventViewController, animated: true)
                }
            }
        }
    }
    
    func contentUpdate(cell: ChooseTimeTableViewCell) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoadData {
            if section == 0 {
                return 1
            }
            if section == 1 {
                if self.dataSource.count > 1 {
                    return 1
                }
                return 0
            }
            if dataSource.count > 1 {
                return self.dataSource.count - 1
            }
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChooseTimeTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        
        if indexPath.section == 0 {
            cell.useButton.setTitleColor(#colorLiteral(red: 1, green: 0.7616637349, blue: 0.04396914691, alpha: 1), for: .normal)
            cell.borderCell.backgroundColor = #colorLiteral(red: 1, green: 0.7616637349, blue: 0.04396914691, alpha: 1)
            cell.expandCell()
            cell.initCellData(dataSource: dataSource[indexPath.row])
        }
        
        if indexPath.section == 1 {
            let cell = SuggestionTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            return cell
        }
        
        if  indexPath.section == 2 {
            cell.useButton.setTitleColor(#colorLiteral(red: 0.3102487624, green: 0.5006980896, blue: 0.5967903137, alpha: 1), for: .normal)
            cell.borderCell.backgroundColor = #colorLiteral(red: 0.3102487624, green: 0.5006980896, blue: 0.5967903137, alpha: 1)
            cell.collapseCell()
            cell.initCellData(dataSource: dataSource[indexPath.row + 1])
        }
//        cell.timeLabel.text = "\(stringStartTime) - \(stringEndTime)"
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

