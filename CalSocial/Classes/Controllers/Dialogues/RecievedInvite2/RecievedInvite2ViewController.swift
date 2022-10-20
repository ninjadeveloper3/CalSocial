//
//  RecievedInvite2ViewController.swift
//  CalSocial
//
//  Created by Moiz Amjad on 10/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol RecievedInvite2ViewControllerDelegate {
    func didTapSuggests()
    func didTapSelection()
}

class RecievedInvite2ViewController: UIViewController {
    
    //MARK: - Variables
    
    var eventId = 0
    
    var status = 0

    var delegate : RecievedInvite2ViewControllerDelegate?
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var joinButton: MBButton!
    
    @IBOutlet weak var cantJoinButton: MBButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func suggestionButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: {
            self.delegate?.didTapSuggests()
        })
    }
    
    @IBAction func selectionButtonTapped(_ sender: MBButton) {
        
        if sender == joinButton {
            status = 1
            
        } else {
            status = 0
        }
        setStatus(status: status)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setStatus(status: Int) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.setEventStatus(status: status, eventId: eventId) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.dismiss(animated: true, completion: {
                    self.delegate?.didTapSelection()
                })
            }
        }
    }
}
