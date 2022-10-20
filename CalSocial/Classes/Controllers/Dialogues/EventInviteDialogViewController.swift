//
//  EventInviteDialogViewController.swift
//  CalSocial
//
//  Created by DevBatch on 06/02/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import UIKit

class EventInviteDialogViewController: UIViewController {
    
    //MARK:- Variables
    
    var isOnlyHost = false
    
    var eventUpdated = false
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var eventPopupHeader: UILabel!
    
    @IBOutlet weak var eventPopupSubTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if isOnlyHost {
            eventPopupHeader.text = "Event Created"
            eventPopupSubTitle.text = "Event has been created"
        }
        if eventUpdated {
            eventPopupHeader.text = "Event Updated"
            eventPopupSubTitle.text = "Event has been updated"
        }
    }
    
    @IBAction func dimissScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
