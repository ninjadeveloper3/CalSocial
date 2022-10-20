//
//  CanMakeItViewController.swift
//  CalSocial
//
//  Created by Moiz Amjad on 10/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol CanMakeItViewControllerDelegate {
    func didSelectionTapped()
}

class CanMakeItViewController: UIViewController {
    
    //MARK: - Variables
    
    var eventId = 0
    
    var status = 0
    
    var delegate : CanMakeItViewControllerDelegate?
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var noButton: MBButton!
    
    @IBOutlet weak var maybeButton: MBButton!
    
    @IBOutlet weak var yesButton: MBButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func selectionButtonTapped(_ sender: MBButton) {
        
        if sender == noButton {
            status = 0
            
        } else if sender == maybeButton {
            status = 2
            
        } else {
            status = 1
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
                    self.delegate?.didSelectionTapped()
                })
            }
        }
    }
}
