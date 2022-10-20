//
//  HiveConnectionsViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 08/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class HiveConnectionsViewController: UIViewController {
    
    //MARK:- Variables
    
    var settings = Mapper<Settings>().map(JSON: [:])!
    
    var settingsDatasource = Mapper<Settings>().map(JSON: [:])!
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var inHiveSwitch: UISwitch!
    
    @IBOutlet weak var myHiveViewMember: UISwitch!
    
    @IBOutlet weak var profileDetails: UISwitch!
    
    @IBOutlet weak var outHiveViewMember: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        self.title = "Hive Connections"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)) )
        inHiveSwitch.isOn = settings.inHiveMember
        myHiveViewMember.isOn = settings.outHiveMember
        profileDetails.isOn = settings.outHiveFromProfile
        outHiveViewMember.isOn = settings.outHiveMyHiveMember
        
    }
    //MARK: - IBActions
    
    @IBAction func inHiveSwitch(_ sender: UISwitch) {
        if sender.isOn{
            settings.inHiveMember = true
        }
        else{
            settings.inHiveMember = false
        }
    }
    
    
    @IBAction func outHiveViewMembers(_ sender: UISwitch) {
        if sender.isOn{
            settings.outHiveMember = true
        }
        else{
            settings.outHiveMember = false
        }
    }
    
    @IBAction func outHiveProfileView(_ sender: UISwitch) {
        if sender.isOn{
            settings.outHiveFromProfile = true
        }
        else{
            settings.outHiveFromProfile = false
        }
    }
    
    @IBAction func outHiveOtherMemberView(_ sender: UISwitch) {
        if sender.isOn{
            settings.outHiveMyHiveMember = true
        }
        else{
            settings.outHiveMyHiveMember = false
        }
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.setHiveConnectionsSettings(options: settings){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
            }
            else{

                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
}
