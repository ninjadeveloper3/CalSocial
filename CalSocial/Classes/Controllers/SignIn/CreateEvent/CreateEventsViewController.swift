//
//  CreateEventsViewController.swift
//  CalSocial
//
//  Created by DevBatch on 30/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class CreateEventsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func createEventButtonTapped(_ sender: Any) {
        setUpTabController(isCreateEvent: true)
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        setUpTabController(isCreateEvent: false)
    }
    
    //MARK: - Private Methods
    
    func setUpTabController(isCreateEvent: Bool) {
        Utility.setUpNavDrawerController(isCreateEvent: isCreateEvent)
        self.present(Utility.tabController, animated: true, completion: nil)
    }
}
