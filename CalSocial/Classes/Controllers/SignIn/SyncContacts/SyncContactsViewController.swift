//
//  SyncContactsViewController.swift
//  CalSocial
//
//  Created by Zeeshan Haider on 30/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ContactsUI
import ObjectMapper


class SyncContactsViewController: UIViewController {
    
    //MAR: - Variables
    
    var contactDatasouce = [Contacts]()
    
    var permission = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Mark: - Private Functions
    
    func doSaveContactsApi(){
       
        APIClient.sharedClient.saveContactsList(contactsList: contactDatasouce){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: false)

            } else {
//                NSError.showErrorWithMessage(message: "Hive request have been sent", viewController: self, type: .success, isNavigation: false)
//                DispatchQueue.main.asyncAfter(deadline: .now()+2.0, execute: {
                 self.navigationController?.pushViewController(SendRequestViewController(), animated: true)
//                })
            }
        }
    }

    //MARK: - IBAction
    
    @IBAction func syncContactButtonTapped(_ sender: Any) {
        
        //contact syncing
        Utility.showLoading(viewController: self)

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
//                print("contact name-->",contact.givenName)

                for (_,phone) in contact.phoneNumbers.enumerated() {
//                    print("phone Number->",phone.value.stringValue)

                    if let countryCode = phone.value.value(forKey: "countryCode") as? String {
                        if countryCode == "us" {
                            let contactObject = Mapper<Contacts>().map(JSON: [:])!
                            contactObject.name = contact.givenName != "" ? contact.givenName : ""
                            contactObject.phone = phone.value.stringValue != "" ? phone.value.stringValue : ""
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
        }
        catch {
            Utility.hideLoading(viewController: self)
            NSError.showErrorWithMessage(message: "Unable to fetch contacts", viewController: self, type: .error, isNavigation: false)
            
            print("unable to fetch contacts")
        }
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        self.navigationController?.pushViewController(calenderSyncSelectionViewController(), animated: true)
    }
    
    func setUpTabController() {
        Utility.setUpNavDrawerController()
        self.present(Utility.tabController, animated: true, completion: nil)
    }
}
