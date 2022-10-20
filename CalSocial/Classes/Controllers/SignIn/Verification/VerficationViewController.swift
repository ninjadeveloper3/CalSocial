//
//  VerficationViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 30/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper
import OneSignal

class VerficationViewController: UIViewController {
    
    //MARK: - Variables
    
    var dataSource = Mapper<SignUpUser>().map(JSON: [:])!
    
    var isOnboarding = false
    
    var totalCodeCount = 0
    
    var userId = 0
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var vCodeOneTextField: BUITextField! {
        didSet {
            vCodeOneTextField.delegate = self
        }
    }
    
    @IBOutlet weak var vCodeTwoTextField: BUITextField! {
        didSet {
            vCodeTwoTextField.delegate = self
        }
    }
    
    @IBOutlet weak var vCodeThreeTextField: BUITextField! {
        didSet {
            vCodeThreeTextField.delegate = self
        }
    }
    
    @IBOutlet weak var vCodeFourTextFIeld: BUITextField! {
        didSet {
            vCodeFourTextFIeld.delegate = self
        }
    }
    
    @IBOutlet weak var vCodeFiveTextField: BUITextField! {
        didSet {
            vCodeFiveTextField.delegate = self
        }
    }
    
    @IBOutlet weak var vCodeSixTextField: BUITextField! {
        didSet {
            vCodeSixTextField.delegate = self
        }
    }
    
    @IBOutlet weak var resendCodeLabel: UILabel!
    
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        vCodeOneTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        vCodeTwoTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        vCodeThreeTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        vCodeFourTextFIeld.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        vCodeFiveTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        vCodeSixTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func resendTapped(_ sender: Any) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.resendCode(userId: userId){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: false)
                
            }
            else{
                NSError.showErrorWithMessage(message: "A verification code has been resent to your number", viewController: self, type: .success, isNavigation: false)
            }
        }
    }
    
    
    @IBAction func contiuneButtonTapped(_ sender: Any) {
        
        if(vCodeOneTextField.text!.isEmpty){
            NSError.showErrorWithMessage(message: "Invalid Verification Code", viewController: self, type: .error, isNavigation: false)
            return
        }
        if(vCodeTwoTextField.text!.isEmpty){
            NSError.showErrorWithMessage(message: "Invalid Verification Code", viewController: self, type: .error, isNavigation: false)
            return
        }
        if(vCodeThreeTextField.text!.isEmpty){
            NSError.showErrorWithMessage(message: "Invalid Verification Code", viewController: self, type: .error, isNavigation: false)
            return
        }
        if(vCodeFourTextFIeld.text!.isEmpty){
            NSError.showErrorWithMessage(message: "Invalid Verification Code", viewController: self, type: .error, isNavigation: false)
            return
        }
        if(vCodeFiveTextField.text!.isEmpty){
            NSError.showErrorWithMessage(message: "Invalid Verification Code", viewController: self, type: .error, isNavigation: false)
            return
        }
        if(vCodeSixTextField.text!.isEmpty){
            NSError.showErrorWithMessage(message: "Invalid Verification Code", viewController: self, type: .error, isNavigation: false)
            return
        }
        
        let code = "\(vCodeOneTextField.text!)" + "\(vCodeTwoTextField.text!)" + "\(vCodeThreeTextField.text!)" + "\(vCodeFourTextFIeld.text!)" + "\(vCodeFiveTextField.text!)" + "\(vCodeSixTextField.text!)"
        
        
        if isOnboarding {
        
            activateAccountApi(code: code)

        }
        else {
            verifyAccountForLogin(code: code)
        }
    }
    
    //MARK: - Private Methods
    
    func verifyAccountForLogin(code: String) {
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.verifyAccountForLogin(userId: userId, code: code, playerId: getPlayerID()){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self,isNavigation: false)
                
            }
            else{
                if let data = Mapper<SignUpUser>().map(JSONObject: result) {
                    self.dataSource = data
                    UserDefaults.standard.set(self.dataSource.token, forKey: kToken)
                    UserDefaults.standard.set(self.dataSource.id, forKey: kUserId)
                    UserDefaults.standard.set(self.dataSource.fname, forKey: kUserFirstName)
                    UserDefaults.standard.set(self.dataSource.lname, forKey: kUserLastName)
                    UserDefaults.standard.set(self.dataSource.color, forKey: kUserColorCode)
                    if self.dataSource.profilePic != "" {
                        UserDefaults.standard.set(self.dataSource.profilePic, forKey: kUserProfileImageUrl)
                    }
                    Utility.setUpNavDrawerController()
                    self.present(Utility.tabController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func activateAccountApi(code: String){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.activateAccount(userId: userId, code: code, playerId: getPlayerID()){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self,isNavigation: false)
                
            }
            else{
                if let data = Mapper<SignUpUser>().map(JSONObject: result) {
                    self.dataSource = data
                    UserDefaults.standard.set(self.dataSource.token, forKey: kToken)
                    UserDefaults.standard.set(self.dataSource.id, forKey: kUserId)
                    UserDefaults.standard.set(self.dataSource.fname, forKey: kUserFirstName)
                    UserDefaults.standard.set(self.dataSource.lname, forKey: kUserLastName)
                    UserDefaults.standard.set(self.dataSource.color, forKey: kUserColorCode)
                    if self.dataSource.profilePic != "" {
                        UserDefaults.standard.set(self.dataSource.profilePic, forKey: kUserProfileImageUrl)
                    }
                    self.navigationController?.pushViewController(ProfileInfoViewController(), animated: true)
                }
            }
        }
    }
    
    func getPlayerID() -> String {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let userID = status.subscriptionStatus.userId
        print("userID = \(userID!)")
        UserDefaults.standard.set("\(userID!)", forKey: kDeviceToken)
        return "\(userID!)"
    }
}

extension VerficationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 1
    }
    
    
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        
        if text?.utf16.count == 1 {
            switch textField {
                
            case vCodeOneTextField:
                vCodeTwoTextField.becomeFirstResponder()
                
            case vCodeTwoTextField:
                vCodeThreeTextField.becomeFirstResponder()
                
            case vCodeThreeTextField:
                vCodeFourTextFIeld.becomeFirstResponder()
                
            case vCodeFourTextFIeld:
                vCodeFiveTextField.becomeFirstResponder()
                
            case vCodeFiveTextField:
                vCodeSixTextField.becomeFirstResponder()
                
            case vCodeSixTextField:
                vCodeSixTextField.resignFirstResponder()
            default:
                break
            }
        } else { }
    }
}
