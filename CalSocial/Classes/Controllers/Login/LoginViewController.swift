//
//  LoginViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 30/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper


class LoginViewController: UIViewController {
    
    //MARK:- Variables
    
    var dataSource = Mapper<SignUpUser>().map(JSON: [:])!
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var LoginInput: BUITextField!{
        didSet{
            LoginInput.setupPadding()
            LoginInput.isMobileNumberTextField = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        if LoginInput.text!.isEmpty {
            NSError.showErrorWithMessage(message: "The phone must be between 8 and 12 digits", viewController: self, type: .error, isNavigation: false)
            return
        }
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.doSignIn(phone: LoginInput.text!){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: false)
            
            } else {
                if let data = Mapper<SignUpUser>().map(JSONObject: result) {
                    self.dataSource = data
                    let verficationViewController  = VerficationViewController()
                    verficationViewController.isOnboarding = false
                    verficationViewController.userId = self.dataSource.id
                    self.navigationController?.pushViewController(verficationViewController, animated: true)
                }
            }
        }
    }
    
    @IBAction func goBackButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
