//
//  SignInViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 27/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class SignInViewController: UIViewController {
    
    //MARK: - Variables
    
    var dataSource = Mapper<SignUpUser>().map(JSON: [:])!
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var fNameInput: BUITextField!{
        didSet{
            fNameInput.setupPadding()
        }
    }
    @IBOutlet weak var lNameInput: BUITextField!{
        didSet{
            lNameInput.setupPadding()
        }
    }
    
    @IBOutlet weak var phoneInput: BUITextField!{
        didSet{
            phoneInput.setupPadding()
            phoneInput.isMobileNumberTextField = true
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func agreeButtonTapped(_ sender: Any) {
        
        if fNameInput.text!.isEmpty {
            NSError.showErrorWithMessage(message: "First name cannot be empty", viewController: self, type: .error, isNavigation: false)
            return
        }
        
        if lNameInput.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Last name cannot be empty", viewController: self, type: .error, isNavigation: false)
            return
        }
        
        if phoneInput.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Phone Number cannot be empty", viewController: self, type: .error, isNavigation: false)
            return
        }
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.doSignUp(fname: fNameInput.text!, lname: lNameInput.text!, phone: phoneInput.text!){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: false)
                
            } else {
                if let data = Mapper<SignUpUser>().map(JSONObject: result) {
                    self.dataSource = data
                    let verficationViewController  = VerficationViewController()
                    verficationViewController.isOnboarding = true
                    verficationViewController.userId = self.dataSource.id
                    self.navigationController?.pushViewController(verficationViewController, animated: true)
                }
            }
        }
    }
    
    @IBAction func alreadyButtonTapped(_ sender: Any) {
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
}
