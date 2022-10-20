//
//  SetPrivacyViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 08/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper


class SetPrivacyViewController: UIViewController {
    
    //MARK: - Variables
    
    var settingsDatasource = Mapper<Settings>().map(JSON: [:])!
    
    var settings = Mapper<Settings>().map(JSON: [:])!

    //MARK: - IBOutlets
    
    
    @IBOutlet weak var accountPrivacySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    //MARK: - UIViewController Methods
    
    func setUpViewController() {
        
        self.title = "Set Your Privacy"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        accountPrivacySwitch.isOn = settings.accountPrivacy
    }


    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func accountSwitchChanged(_ sender: UISwitch) {
        var accountPrivacy = 0
        if sender.isOn {
            print("on")
            accountPrivacy = 1
        }
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.setAccountPrivacy(status: accountPrivacy){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
            }
            else{
                
                
            }
        }
        
    }
    
    
    
    @IBAction func hiveConnection(_ sender: Any) {
        let hiveCon = HiveConnectionsViewController()
        hiveCon.settings = settings
        self.navigationController?.pushViewController(hiveCon, animated: true)
    }
    
    @IBAction func blockUser(_ sender: Any) {
        let block = BlockedUsersViewController()
        self.navigationController?.pushViewController(block, animated: true)
    }
}
