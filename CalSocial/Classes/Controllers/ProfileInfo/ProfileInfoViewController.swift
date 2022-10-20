//
//  ProfileInfoViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 30/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class ProfileInfoViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var locationInput: BUITextField!{
        didSet{
            locationInput.setupPadding()
        }
    }
    
    @IBOutlet weak var bioTextView: UITextView!{
        didSet{
            bioTextView.placeholder = "A little bit about yourself..."
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if(locationInput.text!.isEmpty){
            NSError.showErrorWithMessage(message: "Please enter your location first", viewController: self, type: .error, isNavigation: false)
            return
        }
        if (bioTextView.text!.isEmpty){
            NSError.showErrorWithMessage(message: "Please tell us little about yourself", viewController: self, type: .error, isNavigation: false)
            return
        }
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.addBio(address: locationInput.text!, bio: bioTextView.text){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: false)
            }
            else{
                self.navigationController?.pushViewController(SyncContactsViewController(), animated: true)
            }
        }
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        self.navigationController?.pushViewController(SyncContactsViewController(), animated: true)
    }
}
