//
//  AddNewContactViewController.swift
//  CalSocial
//
//  Created by DevBatch on 02/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import CarbonKit
import ContactsUI
import ObjectMapper

class AddNewContactViewController: UIViewController {
    
    //MARK: - Variables
    
    let items = ["Phone Contacts","Bizee Network"]
    
    var contactDatasouce = [Contacts]()
    
    var permission = false
    
    var findFriends = false
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setupViewController() {
        
        self.navigationItem.title = "Add New Contact"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNavigation.setSelectedColor(#colorLiteral(red: 0.4391649365, green: 0.4392448664, blue: 0.4391598701, alpha: 1), font: UIFont.muliBold(18.0))
        carbonTabSwipeNavigation.setNormalColor(#colorLiteral(red: 0.7646217346, green: 0.764754355, blue: 0.7646133304, alpha: 1), font: UIFont.muliRegular(18.0))
        carbonTabSwipeNavigation.setIndicatorColor(#colorLiteral(red: 1, green: 0.7616637349, blue: 0.04396914691, alpha: 1))
        carbonTabSwipeNavigation.toolbar.tintColor = #colorLiteral(red: 1, green: 0.7616637349, blue: 0.04396914691, alpha: 1)
        carbonTabSwipeNavigation.toolbar.backgroundColor = .white
        carbonTabSwipeNavigation.toolbarHeight.constant = 55.0
        carbonTabSwipeNavigation.carbonTabSwipeScrollView.isScrollEnabled = false
        carbonTabSwipeNavigation.setIndicatorHeight(0.8)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(Utility.getScreenWidth()/2, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(Utility.getScreenWidth()/2, forSegmentAt: 1)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        contactDatasouce.removeAll()
        if findFriends {
            carbonTabSwipeNavigation.currentTabIndex = 1
        }
        //        syncContactButtonTapped()
    }
    
    //MARK: - Private Methods
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func syncContactButtonTapped() {
        
        //contact syncing
        
        var contacts = [CNContact]()
        let contactStore = CNContactStore()
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),CNContactPhoneNumbersKey] as [Any] //CNContactIdentifierKey
        
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        
        do {
            try contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
                self.permission = true
            }
            
            for (_,contact) in contacts.enumerated() {
                for (_,phone) in contact.phoneNumbers.enumerated() {
                    if let countryCode = phone.value.value(forKey: "countryCode") as? String {
                        if countryCode == "us" {
                            let contactObject = Mapper<Contacts>().map(JSON: [:])!
                            contactObject.name = contact.givenName
                            contactObject.phone = phone.value.stringValue
                            contactObject.phone = contactObject.phone.replacingOccurrences(of: " ", with: "")
                            contactObject.phone = contactObject.phone.replacingOccurrences(of: "(", with: "")
                            contactObject.phone = contactObject.phone.replacingOccurrences(of: ")", with: "")
                            contactObject.phone = contactObject.phone.replacingOccurrences(of: "-", with: "")
                            contactDatasouce.append(contactObject)
                        }
                        
                        if countryCode == "ca" {
                            let contactObject = Mapper<Contacts>().map(JSON: [:])!
                            contactObject.name = contact.givenName
                            contactObject.phone = phone.value.stringValue
                            contactObject.phone = contactObject.phone.replacingOccurrences(of: " ", with: "")
                            contactObject.phone = contactObject.phone.replacingOccurrences(of: "(", with: "")
                            contactObject.phone = contactObject.phone.replacingOccurrences(of: ")", with: "")
                            contactObject.phone = contactObject.phone.replacingOccurrences(of: "-", with: "")
                            contactDatasouce.append(contactObject)
                        }
                        contactDatasouce = contactDatasouce.removingDuplicates(byKey:{$0.phone})
                    }
                }
            }
            doSaveContactsApi()
            
        } catch {
            Utility.hideLoading(viewController: self)
            NSError.showErrorWithMessage(message: "Unable to fetch contacts", viewController: self, type: .error, isNavigation: false)
        }
    }
    
    func doSaveContactsApi() {
        APIClient.sharedClient.saveContactsList(contactsList: contactDatasouce){ (response, result, error, message) in
        }
    }
}

extension AddNewContactViewController: CarbonTabSwipeNavigationDelegate {
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        if index == 0 {
            let phoneContactViewController = PhoneContactViewController()
            phoneContactViewController.isSynced = false
            return phoneContactViewController
            
        } else {
            let swarmViewController = PhoneContactViewController()
            swarmViewController.isSwarm = true
            swarmViewController.isSynced = false
            return swarmViewController
        }
    }
}

